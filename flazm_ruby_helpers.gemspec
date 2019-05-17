# frozen_string_literal: true

lib = File.expand_path('lib', '..')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'flazm_ruby_helpers'
  spec.version       = IO.read('VERSION').chomp
  spec.authors       = ['Ryan Fortman']
  spec.email         = ['r.fortman.dev@gmail.com']

  spec.summary       = 'Misc (flazm) helpers for ruby.  Class extensions and static methods'
  spec.homepage      = 'https://github.com/fortman/flazm_ruby_helpers'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_runtime_dependency 'bundler', '~> 2.0'
end
