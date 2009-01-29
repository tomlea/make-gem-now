require "rubygems"
require "yaml"
require "rubygems/package"

module MakeGemNow
  class Builder
    def initialize(path_to_gemspec, output_path = ".")
      @path_to_gemspec = path_to_gemspec
      @output_path = output_path
      raise "Could not find gemspec!" unless File.exist? @path_to_gemspec
    end
    
    def generate_spec
      @spec_file = File.read(@path_to_gemspec)
      @spec = nil
      Thread.new { @spec = eval("$SAFE = 3\n#{@spec_file}") }.join
      @spec
    end
    
    def build!
      generate_spec

      open File.join(@output_path, @spec.file_name), 'wb' do |gem_io|
        Gem::Package.open gem_io, 'w', nil do |pkg|
          pkg.metadata = @spec.to_yaml

          @spec.files.map{|f| File.join(File.dirname(@path_to_gemspec), f)}.each do |file|
            next if File.directory? file
            next if file == @spec.file_name # Don't add gem onto itself

            stat = File.stat file
            mode = stat.mode & 0777
            size = stat.size

            pkg.add_file_simple file, mode, size do |tar_io|
              tar_io.write open(file, "rb") { |f| f.read }
            end
          end
        end
      end
    end
  end
end
