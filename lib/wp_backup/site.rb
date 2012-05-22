module WpBackup
  class Site

    def initialize(root_dir)
      @root_dir = root_dir
    end

    def dump_to(dir)
      cmd = "cp -rp #{@root_dir} #{dir}"
      result = system(cmd)      
      raise("Copy of site failed (#{$?})") unless result
    end
  end
end
