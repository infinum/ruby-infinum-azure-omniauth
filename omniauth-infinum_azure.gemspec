lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require_relative 'lib/omniauth/infinum_azure/version'

Gem::Specification.new do |spec|
  spec.name = 'omniauth-infinum_azure'
  spec.version = Omniauth::InfinumAzure::VERSION
  spec.authors = ['Marko Ćilimković']
  spec.email = ['marko.cilimkovic@infinum.hr']

  spec.summary = 'Gem that contains OAuth2 strategies for Infinum, such as Infinum Azure AD'
  spec.homepage = 'https://github.com/infinum/ruby-infinum-azure-omniauth'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/infinum/ruby-infinum-azure-omniauth'
  spec.metadata['changelog_uri'] = 'https://github.com/infinum/ruby-infinum-azure-omniauth/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split('\x0').reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'omniauth-oauth2'
end