module WpBackup
  class Site

    def initialize(root_dir, backup_paths)
      @root_dir = root_dir
      @backup_paths = backup_paths || []
    end

    def dump_to(file)
      result = `cd #{@root_dir} && tar -cf #{file} #{@backup_paths.any? ? @backup_paths.join(' ') : '.'}`
      raise("Copy of site failed (#{$?})") unless result
    end

    def restore_from(file)
      if File.exists?(file)
        `cd #{@root_dir} && tar -xf #{file}`
      end
    end
  end
end
