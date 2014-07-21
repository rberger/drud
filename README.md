# Drud

Evaluates an opscode chef cookbook's [metadata](https://github.com/cyberswat){http://docs.opscode.com/essentials_cookbook_metadata.html} and [github](https://github.com/) history to generate a README.md file. The README.md is placed in the root level of the cookbook. This forces cookbook developers to properly use metadata to document their cookbooks efficiently.  Additionally, it provides proper attribution for all committers in the project with links back to the contributors github profile. It is written to take advantage of cookbooks that properly utilize both Rake tasks and metadata.

You can see this in use in our cookbooks. Our reference cookbook is https://github.com/newmediadenver/nmd-skeletor

## Installation

Add this line to your application's Gemfile:

    gem 'drud'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drud

## Usage

Here's an example rake task that could be placed in your cookbooks Rake file.

    desc 'Generate the Readme.md file.'
    task :readme do
      drud = Drud::Readme.new(File.dirname(__FILE__))
      drud.render
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/drud/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

