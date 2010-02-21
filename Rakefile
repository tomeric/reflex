require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "reflex"
    gem.summary = %Q{Reflex connects your app to the React Social API}
    gem.description = %Q{Reflex is a gem that allows you to connect your application to the React Social API}
    gem.email = "tomeric@i76.nl"
    gem.homepage = "http://github.com/i76/reflex"
    gem.authors = ["Tom-Eric Gerritsen"]
    gem.add_development_dependency "mocha", ">= 0.9.8"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "fakeweb", ">= 1.2.8"
    gem.add_development_dependency "mime-types", ">= 1.16"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "reflex #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'cucumber/rake/task'
  load 'features/support/rails_root/Rakefile'

  namespace :cucumber do
    Cucumber::Rake::Task.new({:ok => ['db:reset']}, 'Run features that should pass') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'default'
    end

    Cucumber::Rake::Task.new({:wip => ['db:reset']}, 'Run features that are being worked on') do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'wip'
    end

    desc 'Run all features'
    task :all => [:ok, :wip]
  end
  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'

  task :default => :cucumber

  task :features => :cucumber do
    STDERR.puts "*** The 'features' task is deprecated. See rake -T cucumber ***"
  end

rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

namespace :reflex do
  desc "Configure reflex"
  task :config do
    require 'yaml'
    require 'lib/reflex'
    
    config_file = File.join(File.dirname(__FILE__), 'spec', 'reflex.yml')    
    
    if File.exists?(config_file)
      settings = YAML.load(File.open(config_file))
      configuration = settings.inject({}) do |options, (key, value)|
                        options[(key.to_sym rescue key) || key] = value
                        options
                      end

      Reflex.configure(configuration)
    else
      puts "** [Reflex] #{config_file} does not exist, skipping Reflex configuration"
    end
  end
  
  desc "List methods that have not yet been added to the library, but are available"
  task :missing_methods do
    Rake::Task['reflex:config'].invoke
    
    def class_exists? kls
      begin
        kls = constantize(kls)
        kls.kind_of? Class
      rescue Exception
        false
      end
    end
    
    def constantize(kls)
      Object.module_eval("::#{kls}", __FILE__, __LINE__)      
    end
    
    all_methods = Reflex::System.list_methods
    all_methods.each do |method|
      remote_class, camel_cased_method = method.split('.')
      local_class  = "Reflex::#{remote_class}"
      local_method = camel_cased_method.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase.to_sym
      
      class_exists  = class_exists?(local_class)
      method_exists = class_exists && constantize(local_class).respond_to?(local_method)
      
      unless class_exists && method_exists
        method_description = Reflex::System.method_description(method)
        parameters  = method_description['parameters'].map { |name, doc| "(#{doc['type']}) #{name} : #{doc['description']}" }.join("\n             ")
        description = method_description['method']['description']
        
        puts "\n             == #{method} ==\n      Local: #{local_class}.#{local_method}\n Parameters: #{parameters}\nDescription: #{description}\n"
      end
    end
  end
end
