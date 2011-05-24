require 'rake/testtask'

Rake::TestTask.new :test do |t|
  require 'redgreen' if Gem.available?('redgreen')
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = true
end
