module WpBackup
  class Backup

    def initialize(config)
      @config = config
    end

    def create(backup_db=true, backup_site=true)
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      root_dir = "/tmp/wp-backup-#{timestamp}"
      package_file = "/tmp/wp-backup-#{timestamp}.tar.gz"

      begin
        dirs = []

        if backup_site
          site_dir = File.join(root_dir, 'site')
          FileUtils.mkdir_p(site_dir)
          site_file = @config.site.dump_to(File.join(root_dir, 'site', 'site.tar'))
          dirs << 'site'
        end

        if backup_db
          db_dir = File.join(root_dir, 'db')
          FileUtils.mkdir_p(db_dir)
          db_file = @config.database.dump_to(File.join(db_dir, 'db.sql'))
          dirs << 'db'
        end

        `cd #{root_dir} && tar -czf #{package_file} #{dirs.join(' ')}`

        @config.s3.store(package_file)
      ensure
        `rm -rf #{root_dir} #{package_file}`
      end

      timestamp
    end

    def restore(key)
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      root_dir = "/tmp/wp-restore-#{timestamp}"

      FileUtils.mkdir_p(root_dir)

      begin
        File.open(File.join(root_dir, 'restore.tar.gz'), 'wb') do |file|
          file.write(@config.s3.read(key))
        end

        `cd #{root_dir} && tar -xzf restore.tar.gz`

        db_file = File.join(root_dir, 'db', 'db.sql')
        if File.exists?(db_file)
          @config.database.restore_from(db_file)
        end

        site_file = File.join(root_dir, 'site', 'site.tar')
        if File.exists?(site_file)
          @config.site.restore_from(site_file)
        end
      ensure
        `rm -rf #{root_dir}`
      end
    end
  end
end
