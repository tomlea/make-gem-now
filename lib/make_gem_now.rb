require "rubygems/indexer"
require "logger"
module MakeGemNow
  def make_all(source_paths, output_path = ".")
    gems_path = File.join(output_path, "gems")
    Dir.mkdir(gems_path) unless File.exists? gems_path

    MakeGemNow::Scanner.new(source_paths).each do |gemspec|
      update_repo(File.dirname(gemspec))
      begin
        builder = MakeGemNow::Builder.new(gemspec, gems_path)
        if builder.should_build?
          builder.build!
        else
          puts "Skipping build of #{gemspec}. Already built this one."
        end
      rescue => e
        puts "Could not build #{gemspec}:"
        puts "    "+e.message
      end
    end
    Gem::Indexer.new(output_path).generate_index
  end

  def update_repo(path)
    if File.directory?(File.join(path, ".git"))
      require 'git'
      g = Git.open(path, :log => Logger.new(STDOUT))
      g.fetch
      g.reset "--hard", "origin/master"
    end
  end

  extend self
end

require File.join(File.dirname(__FILE__), *%w[make_gem_now builder])
require File.join(File.dirname(__FILE__), *%w[make_gem_now scanner])
