require "rubygems"
require "yaml"
require "rubygems/package"
require 'timeout'

module MakeGemNow
  class Builder
    def initialize(path_to_gemspec, output_path = ".")
      @path_to_gemspec = path_to_gemspec
      @output_path = File.expand_path(output_path)
      raise "Could not find gemspec!" unless File.exist? @path_to_gemspec
    end

    def generate_spec
      spec_file = File.read(@path_to_gemspec)

      IO.popen("-"){|yaml_pipe|
        if yaml_pipe
          Timeout.timeout(1){
            spec = YAML.load(yaml_pipe)
            raise "This isn't a freaking gemspec, what you trying to pull here buddy?" unless spec.class == Gem::Specification
            return spec
          }
        else
          puts eval("$SAFE = 3\n (\n#{spec_file}\n).to_yaml")
        end
      }

      raise "Loading the YAML failed." unless $?.success?
    end

    def spec
      @spec ||= generate_spec
    end

    def should_build?
      ! File.exists?(File.join(@output_path, spec.file_name))
    end

    def self.on_build(&block)
      @on_build_callbacks ||= []
      @on_build_callbacks << Proc.new(&block)
    end

    def self.do_on_build_callbacks(builder)
      @on_build_callbacks.each do |callback|
        callback.call(builder)
      end
    end

    def build!
      Dir.chdir(File.dirname(@path_to_gemspec)) do
        open File.join(@output_path, spec.file_name), 'wb' do |gem_io|
          Gem::Package.open gem_io, 'w', nil do |pkg|
            pkg.metadata = spec.to_yaml
            spec.files.each do |file|
              next if File.directory? file
              next if file == spec.file_name # Don't add gem onto itself

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
      self.class.do_on_build_callbacks(self)
    end
  end
end
