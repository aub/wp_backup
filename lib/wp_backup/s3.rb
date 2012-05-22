require 'aws-sdk'

module WpBackup
  class S3
    def initialize(aws_config, root_bucket)
      AWS.config(aws_config)
      @s3 = AWS::S3.new
      @root_bucket = root_bucket

      @bucket = @s3.buckets.create(@root_bucket)
    end

    def store(file_name)
      basename = File.basename(file_name)
      object = @bucket.objects[basename]
      object.write(:file => file_name)
    end

    def read(key)
      use_key = "wp-backup-#{key}.tar.gz"
      @bucket.objects[use_key].read
    end

    def keys
      [].tap do |keys|
        @bucket.objects.each do |obj|
          if obj.key =~ /wp-backup-(\d+).tar.gz/
            keys <<  $1
          end
        end
      end
    end

    def delete_keys(keys)
      keys.each do |key|
        puts "Deleting #{key}"
        use_key = "wp-backup-#{key}.tar.gz"
        @bucket.objects[use_key].delete
      end
    end
  end
end
