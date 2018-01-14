require 'erb'
require 'open3'
require 'yaml'

namespace :db do
  namespace :data do
    desc 'Export the database into a SQL file or stdout'
    task :dump, [:file] do |_, args|
      if args[:file]
        File.open(args[:file], 'w') { |f| f.write(mysqldump) }
      else
        puts mysqldump
      end
    end

    desc 'Import database data from a file'
    task :import, [:file] do |_, args|
      raise(ArgumentError, 'No file provided to load') unless args[:file]
      #
      data = File.open(args[:file], &:read)
      stdout, stderr, stat = Open3.capture3(mysql, stdin_data: data)
      raise stderr unless stat.success?
      #
      puts stdout
    end
  end
end

# fetches the current database configuration for the given environment
# defaults to the development environment
def current_db_config(env = nil)
  env ||= ENV.fetch('RAILS_ENV', 'development')
  #
  config_file = Rails.root.join('config', 'database.yml')
  YAML.safe_load(ERB.new(IO.read(config_file)).result, [], [], true)[env]
end

# returns mysql command string using the current config
def mysql
  sql_cmd('mysql', current_db_config)
end

# dumps the data from the provided environment's database
def mysqldump
  `#{sql_cmd('mysqldump -x', current_db_config)}`
end

# executes a sql command using config parameters
def sql_cmd(sql_command, config)
  "#{sql_command} ".tap do |cmd|
    cmd << "-u#{config['username']} " if config['username']
    cmd << "-h#{config['host']} " if config['host']
    cmd << "-P#{config['port']} " if config['port']
    cmd << config['database'] if config['database']
  end
end
