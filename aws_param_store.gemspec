# frozen_string_literal: true

require_relative 'lib/aws_param_store/version'

Gem::Specification.new do |spec|
  spec.name = 'aws_param_store'
  spec.version = AwsParamStore::VERSION
  spec.authors = ['Rails team']
  spec.email = ['team.rails@infinum.com']

  spec.summary = 'Manage app parameters using AWS SSM Parameter store'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/infinum/aws_param_store'
  spec.license = 'Apache-2.0'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?('bin/', 'spec/', '.git', '.github', 'Gemfile')
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-ssm', '~> 1.162'
end
