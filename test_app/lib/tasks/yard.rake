require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['/../lib/**/*.rb', '/../app/models/**/*.rb']
end