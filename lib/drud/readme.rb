require 'chef/cookbook/metadata'
require 'octokit'
require 'rake'
require 'rake/task_manager'
require 'erb'
require 'ostruct'
require 'yaml'

module Drud
  # Constructs a new ERB object for rendering a Readme.md file.
  class ReadmeTemplate < OpenStruct
    # Desribe the behaviour of the method
    #
    # ==== Attributes
    #
    # * +:template+ - The template to render against.
    #
    # ==== Examples
    # Assuming this is the content of template.erb:
    #    My metadata is <%= metadata %>
    # You would render it with the following:
    #    markdown = ReadmeTemplate.new(metadata: @metadata)
    #    markdown.render(File.read('template.erb'))
    def render(template)
      ERB.new(template).result(binding)
    end
  end
  # Evaluates an opscode chef cookbook's
  # {metadata}[http://docs.opscode.com/essentials_cookbook_metadata.html] and
  # {github}[https://github.com/] history to generate a README.md file. The
  # README.rb is placed in the root level of the cookbook. This forces cookbook
  # developers to properly use metadata to document their cookbooks
  # efficiently.  Additionally, it provides proper attribution for all
  # committers in the project with links back to the contributors github
  # profile. It is written to take advantage of cookbooks that properly utilize
  # both Rake tasks and metadata.
  class Readme
    # The path to the cookbook being processed.
    attr_accessor :cookbook
    # The cookbook as represented by Chef::Cookbook::Metadata.
    attr_accessor :metadata
    # The raw git log for the cookbook.
    attr_accessor :logs
    # A scaled down version of the logs, eg: {commit, author}
    attr_accessor :commits
    # A hash containing credit information by author keyed by the authors
    # github profile uri.
    attr_accessor :credit
    # Rake task information extracted from the target cookbook.
    attr_accessor :tasks

    # Initialize a new instance of Drud::Readme
    #
    # ==== Attributes
    #
    # * +:path+ - The local path of the cookbook.
    #
    # ==== Examples
    # This can be placed in a convenient location, such as a Rake task inside
    # the cookbook. When the render method is called, it will overwrite the
    # cookbooks README.md
    #    readme = Drud::Readme.new(File.dirname(__FILE__))
    #    readme.render
    def initialize(path)
      @cookbook = path
      @type = :chef
      @metadata = load_metadata
      @logs = load_logs
      @commits, @credit, @tasks = {}, {}, {}
      @octokit_auth = { access_token: ENV['DRUD_OAUTH'] } if ENV['DRUD_OAUTH']
      parse_rake_tasks
      parse_commits
      parse_credit
    end

    # Renders the README.md file and saves it in the cookbooks path.
    def render
      markdown = ReadmeTemplate.new(
        metadata: @metadata, tasks: @tasks, credit: @credit
      )
      readme = markdown.render(File.read(template_path))
      File.open("#{@cookbook}/README.md", 'w') { |file| file.write(readme) }
    end

    private

    # Goes thru a heirarchy of potential template locations to get the template_path
    def template_path
      # Memoized
      return @template_path if @template_path

      paths = []
      paths << File.join(
        @cookbook,
        "templates",
        "default",
        "README.md.erb"
      )

      paths << File.join(
        File.expand_path("~/.chef"),
        "README.md.erb"
      )

      paths << File.join(
        File.dirname(File.expand_path(__FILE__)),
        '../../templates/readme.md.erb'
      )
      
      paths.each do |path|
        if File.exists? path
          @template_path = path
          puts "Using Template: #{@template_path}"
          return path
        end
      end
      
      # IF we got to here then a template was never found
      STDERR.puts "ERROR: Can not fine a README.md template in:\n\t#{paths.join("\n\t")}"
      exit(-1)
    end

    # Reads the cookbooks metadata and instantiates an instance of
    # Chef::Cookbook::Metadata
    def load_metadata # :doc:
      metadata = Chef::Cookbook::Metadata.new
      metadata.from_file("#{@cookbook}/metadata.rb")
      metadata
    end

    # Uses the git log command to extract the cookbook's log information.
    def load_logs # :doc:
      logs = `cd #{@cookbook} && git log`.split('commit ')
      logs.shift
      logs
    end

    # Parses the results of git log and creates a simplified hash, eg:
    # {commit, author}.
    def parse_commits # :doc:
      @logs.map do |log|
        @commits[log.split("\n").shift] = /(^A[a-z]+: )(.+)$/.match(log)[2]
      end
    end

    # Parses a hash of commit information and generates a hash containing the
    # authors github profile path and number of commits. Some authors may have
    # multiple author names so the resulting hash is passed to format_credit
    # for additional processing.
    def parse_credit # :doc:
      credit = {}
      @commits.each do |commit, author|
        credit[author][:count] += 1 unless credit[author].nil?
        next unless credit[author].nil?
        credit[author] = {}
        credit[author][:count] = 1
        credit[author][:html_url] = github_html_url commit
      end
      format_credit credit
    end

    # Formats the hash generated by parse_credit.
    #
    # ==== Attributes
    #
    # * +:credit+ - A hash of credit information to parse.
    def format_credit(credit) # :doc:
      f = @credit
      credit.each do |name, data|
        f[data[:html_url]] = {} if f[data[:html_url]].nil?
        f[data[:html_url]][:names] = Set.new if f[data[:html_url]][:names].nil?
        clean_name = /([^<]*)/.match(name)[1].strip
        f[data[:html_url]][:names].add(clean_name)
        count = f[data[:html_url]][:count]
        f[data[:html_url]][:count] += data[:count] unless count.nil?
        f[data[:html_url]][:count] = data[:count] if count.nil?
      end
    end

    # Uses the Ocktokit client to read information about a commit from the
    # cookbooks origin. This is an unauthenticated request to the github API
    # and might be throttled if you exceed github's limits.  It is only called
    # once per author in a cookbooks project. This only returns the html_url to
    # the authors github profile.
    #
    # If the environment variable DRUD_OAUTH is set, it will be used as an OAUTH
    # token for accessing GITHUB
    #
    # ==== Attributes
    #
    # * +:commit+ - The commit hash to get information from.
    def github_html_url(commit) # :doc:
      info = `cd #{@cookbook} && git remote -v`
      origin = /^origin.+?:([^\.+]*)/.match(info)[1]
      if @octokit_auth
        client = Octokit::Client.new @octokit_auth
      else
        client = Octokit::Client.new
      end
      
      begin
        detail = client.commit(origin, commit)
      rescue Octokit::NotFound
        puts "ERROR: Accessing Github origin: #{origin} commit: #{commit} @octokit_auth: #{@octokit_auth.inspect}"
        unless @octokit_auth
          puts "\tNeed to set environment variable DRUD_OAUTH to a valid Github access token for private repos"
          puts "\tSee https://help.github.com/articles/creating-an-access-token-for-command-line-use"
        end
        exit(-1)
      end
      detail[:author][:html_url]
    end

    # Loads an instance of Rake::Application from the cookbooks Rakefile for
    # additional processing.
    def load_rake # :doc:
      Dir.chdir @cookbook
      rake = Rake::Application.new
      Rake::TaskManager.record_task_metadata = true
      Rake.application = rake
      rake.init
      rake.load_rakefile
    end

    # Parses metadata from the cookbooks Rake Tasks.
    def parse_rake_tasks # :doc:
      load_rake
      Rake.application.tasks.each do |t|
        @tasks[t] = {
          'sources' => t.sources, 'full_comment' => t.full_comment,
          'actions' => t.actions, 'application' => t.application,
          'comment' => t.comment, 'prerequisites' => t.prerequisites,
          'scope' => t.scope
        }
      end
    end
  end
end
