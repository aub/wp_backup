module WpBackup
  class Backup

    def initialize(config_file)
      @config = Config.new(config_file)
    end

    def create
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      root_dir = "/tmp/wp_backup-#{timestamp}"

      db_dir = File.join(root_dir, 'db')
      site_dir = File.join(root_dir, 'site')

      FileUtils.mkdir_p(db_dir)
      FileUtils.mkdir_p(site_dir)

      db_file = @config.database.dump_to(File.join(db_dir, 'db.sql'))
      site_file = @config.site.dump_to(root_dir)

      package_file = "/tmp/wp-backup-#{timestamp}.tar.gz"
      `tar -cpzf #{package_file} #{root_dir}`

      @config.s3.store(package_file)
    end

    def restore

    end
  end
end
