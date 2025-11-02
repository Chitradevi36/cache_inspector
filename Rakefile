# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "Build gem"
task :build do
  sh "gem build cache_inspector.gemspec"
end

desc "Release gem to RubyGems"
task :release do
  version = File.read("lib/cache_inspector/version.rb")[/VERSION\s*=\s*["'](.+?)["']/, 1]
  abort("Version not found") unless version
  sh "gem build cache_inspector.gemspec"
  sh "git add . && git commit -m 'Release v#{version}' || true"
  sh "git tag v#{version}"
  sh "git push origin main --tags"
  sh "gem push cache_inspector-#{version}.gem"
end