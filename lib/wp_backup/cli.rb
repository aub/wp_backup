require 'thor'

module WpBackup
  class CLI < Thor
    desc 'backup', 'back up the blog residing in the given directory to S3'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    method_option :db_only, :aliases => '-d', :desc => 'Only back up the database.'
    method_option :site_only, :aliases => '-s', :desc => 'Only back up the site.'
    def backup
      config = Config.new(options[:config_file])
      key = Backup.new(config).create(!options[:site_only], !options[:db_only])
      puts "Backed up to #{key}"
    end

    desc 'list', 'list the currently saved backups'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def list
      config = Config.new(options[:config_file])
      keys = config.s3.keys
      puts "Found #{keys.count} versions:"
      puts "========================"
      keys.each { |k| puts k }
    end

    desc 'cleanup', 'delete the least recent n backups'
    method_option :keep, :aliases => '-k', :desc => 'The number of backups to keep, defaults to 10'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def cleanup
      config = Config.new(options[:config_file])
      keep = options[:keep]
      timestamps = {}
      config.s3.keys.each { |k| timestamps[Time.parse(k, "%Y%m%d%H%M%S")] = k }
      remove = timestamps.keys.sort.reverse.slice(keep.to_i, timestamps.length)
      timestamps.keep_if { |k,v| remove.include?(k) }
      config.s3.delete_keys(timestamps.values)
    end

    desc 'restore KEY', 'restore from the given backup key. See the List command for the set of available keys.'
    method_option :config_file, :aliases => '-c', :desc => 'The location of the configuration file. This is assumed to be wp_backup.yml in the current directory unless given.'
    def restore(key)
      config = Config.new(options[:config_file])
      Backup.new(config).restore(key)
    end

    desc 'create_config file', 'create a sample config file'
    def create_config(file)
      Config.write_sample(file)
    end
  end
end
