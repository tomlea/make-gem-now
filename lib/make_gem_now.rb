require "rubygems/indexer"

module MakeGemNow
  def make_all(source_paths, output_path = ".")
    gems_path = File.join(output_path, "gems")
    Dir.mkdir(gems_path) unless File.exists? gems_path
    MakeGemNow::Scanner.new(source_paths).each do |gemspec|
      begin
        MakeGemNow::Builder.new(gemspec, gems_path).build!
      rescue => e
        puts "Could not build #{gemspec}:"
        puts "    "+e.message
      end
    end
    Gem::Indexer.new(output_path).generate_index
  end
  extend self
end

require File.join(File.dirname(__FILE__), *%w[make_gem_now builder])
require File.join(File.dirname(__FILE__), *%w[make_gem_now scanner])
