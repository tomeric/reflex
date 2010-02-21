class ReflexConnectionMigrationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'create_reflex_connections.rb', 'db/migrate',
                           :migration_file_name => 'create_reflex_connections'
    end
  end
  
  def file_name
    'create_reflex_connections'
  end
end