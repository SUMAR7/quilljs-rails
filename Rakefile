require "bundler/gem_tasks"
require "rake/testtask"

# Load custom rake tasks from lib/tasks
Dir.glob(File.expand_path('lib/tasks/**/*.rake', __dir__)).each { |r| load r }

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test
