module WpBackup
  class Database

    def initialize(db_name, login, password)
      @db_name = db_name
      @login = login
      @password = password
    end

    def dump_to(file)
      cmd = "mysqldump --opt --skip-add-locks -u#{@login} "
      cmd += "-p'#{@password}' " unless @password.empty?
      cmd += " #{@db_name} > #{file}"
      result = system(cmd)
      raise("ERROR: mysqldump failed (#{$?})") unless result
    end
  end
end
