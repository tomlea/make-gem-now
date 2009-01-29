module MakeGemNow
  class Scanner
    include Enumerable
    def initialize(path)
      @base_path = path
    end
    
    def each
      Dir.new(@base_path).each do |f|
        next if f =~ /^\./

        path = File.join(@base_path, f)
        next unless File.directory? path

        gemspec = File.join(path, File.basename(path)+".gemspec")
        next unless File.exist?( gemspec )
        
        yield(gemspec)
      end
    end
  end
end
