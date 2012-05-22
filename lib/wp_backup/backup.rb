module WpBackup
  class Backup

    def initialize(config)
      @config = config
    end

    def create(backup_db=true, backup_site=true)
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      root_dir = "/tmp/wp-backup-#{timestamp}"

      begin
        if backup_site
          site_dir = File.join(root_dir, 'site')
          FileUtils.mkdir_p(site_dir)
          site_file = @config.site.dump_to(File.join(root_dir, 'site', 'site.tar'))
        end

        if backup_db
          db_dir = File.join(root_dir, 'db')
          FileUtils.mkdir_p(db_dir)
          db_file = @config.database.dump_to(File.join(db_dir, 'db.sql'))
        end

        package_file = "/tmp/wp-backup-#{timestamp}.tar.gz"
        `cd #{root_dir} && tar -czf #{package_file} db site`

        @config.s3.store(package_file)
      ensure
        `rm -rf #{root_dir}`
      end

      timestamp
    end

    def restore(key)
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      root_dir = "/tmp/wp-restore-#{timestamp}"

      FileUtils.mkdir_p(root_dir)

      begin
        File.open(File.join(root_dir, 'restore.tar.gz'), 'w') do |file|
          file.puts(@config.s3.read(key))
        end

        `cd #{root_dir} && tar -xzvf restore.tar.gz`

        @config.database.restore_from(File.join(root_dir, 'db', 'db.sql'))
        @config.site.restore_from(File.join(root_dir, 'site', 'site.tar'))
      ensure
        `rm -rf #{root_dir}`
      end
    end
  end
end
