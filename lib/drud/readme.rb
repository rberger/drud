require 'chef/cookbook/metadata'
require 'octokit'
require 'rake'
require 'rake/task_manager'
require 'erb'
require 'ostruct'
require 'yaml'

module Drud
  class ReadmeTemplate < OpenStruct
    def render(template)
      ERB.new(template).result(binding)
    end
  end

  class Readme
    attr_accessor :cookbook
    attr_accessor :metadata
    attr_accessor :logs
    attr_accessor :commits
    attr_accessor :credit
    attr_accessor :tasks

    def initialize(path)
      @cookbook = path
      @type = :chef
      @metadata = load_metadata
      @logs = load_logs
      @commits = {}
      @credit = {}
      @tasks = {}
      parse_rake_tasks
      parse_commits
      parse_credit
      render
    end

    def load_metadata
      metadata = Chef::Cookbook::Metadata.new
      metadata.from_file("#{@cookbook}/metadata.rb")
      metadata
    end

    def load_logs
      logs = `cd #{@cookbook} && git log`.split('commit ')
      logs.shift
      logs
    end

    def parse_commits
      @logs.map do |log|
        @commits[log.split("\n").shift] = /(^A[a-z]+: )(.+)$/.match(log)[2]
      end
    end

    def parse_credit
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

    def format_credit(credit)
      f = {}
      credit.each do |name, data|
        f[data[:html_url]] = {} if f[data[:html_url]].nil?
        f[data[:html_url]][:names] = Set.new if f[data[:html_url]][:names].nil?
        clean_name = /([^<]*)/.match(name)[1].strip
        f[data[:html_url]][:names].add(clean_name)
        f[data[:html_url]][:count] += data[:count] unless f[data[:html_url]][:count].nil?
        f[data[:html_url]][:count] = data[:count] if f[data[:html_url]][:count].nil?
      end
      @credit = f
    end

    def github_html_url(commit)
      info = `cd #{@cookbook} && git remote -v`
      origin = /^origin.+?:([^\.+]*)/.match(info)[1]
      client = Octokit::Client.new
      detail = client.commit(origin, commit)
      detail[:author][:html_url]
    end

    def load_rake
      Dir.chdir @cookbook
      rake = Rake::Application.new
      Rake::TaskManager.record_task_metadata = true
      Rake.application = rake
      rake.init
      rake.load_rakefile
    end

    def parse_rake_tasks
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

    def render
      markdown = ReadmeTemplate.new(metadata: @metadata, tasks: @tasks, credit: @credit)
      template_path = File.join(File.dirname(File.expand_path(__FILE__)), '../../templates/readme.md.erb')
      readme = markdown.render(File.read(template_path))
      File.open("#{@cookbook}/README.md", 'w') { |file| file.write(readme) }
    end
  end
end
