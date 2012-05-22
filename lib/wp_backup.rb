%w(backup cli config  database s3 site).each do |file|
  require_relative "wp_backup/#{file}"
end

module WpBackup
  class BackupError < StandardError
  end
end
