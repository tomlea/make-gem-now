# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{make-gem-now}
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Lea"]
  s.date = %q{2009-01-30}
  s.default_executable = %q{make-gem-now}
  s.description = %q{A tool to build all gems in a given dir, and index them appropriately.}
  s.email = %q{commits@tomlea.co.uk}
  s.executables = ["make-gem-now"]
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["Rakefile", "README.markdown", "lib/make_gem_now/builder.rb", "lib/make_gem_now/scanner.rb", "lib/make_gem_now.rb", "bin/make-gem-now"]
  s.has_rdoc = true
  s.rdoc_options = ["--line-numbers", "--inline-source", "--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{A tool to build all gems in a given dir, and index them appropriately.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
