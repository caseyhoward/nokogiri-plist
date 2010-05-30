require 'rake/testtask'

desc 'Run all tests'
task :test do
  ENV['RAILS_ENV'] = 'test'
  $LOAD_PATH.unshift(File.expand_path('test'))
  require 'redgreen' if Gem.available?('redgreen')
  require 'test/unit'
  Dir['test/*/**/test_*.rb'].each {|test| require test }
end