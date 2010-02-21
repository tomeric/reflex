class ReflexProviderMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'create_reflex_providers.rb', 'db/migrate',
                           :migration_file_name => 'create_reflex_providers'
    end
  end
  
  def file_name
    'create_reflex_providers'
  end
end