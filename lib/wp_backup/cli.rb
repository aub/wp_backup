require 'thor'

module WpBackup
  class CLI < Thor
    desc 'backup', 'back up the blog residing in the given directory to S3'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def backup
      Backup.new(options[:config_file]).backup
    end

    desc 'list', 'list the currently saved backups'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def list
      config_file = options[:config_file]
    end

    desc 'cleanup', 'delete the least recent n backups'
    method_option :keep, :aliases => '-k', :desc => 'The number of backups to keep, defaults to 10'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def cleanup
      config_file = options[:config_file]
      keep = options[:keep]
    end

    desc 'restore', 'restore from a backup'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def restore
      Backup.new(options[:config_file]).restore
    end

    desc 'create_config file', 'create a sample config file'
    def create_config(file)
      Config.write_sample(file)
    end
  end
end
