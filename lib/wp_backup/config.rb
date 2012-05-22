module WpBackup
  class Config

    def initialize(file)
      @config = YAML.load_file(file)
      @bucket_name = @config['aws'].delete('bucket')
    end
    
    def s3
      S3.new(aws_config, root_bucket)
    end

    def database
      Database.new(
        database_config['name'],
        database_config['user'],
        database_config['password']
      )
    end

    def site
      Site.new(wordpress_config['home'])
    end

    def self.write_sample(file)
      File.open(file, 'w') do |file|
        file.puts(<<-EOF
database:
  name:
  user:
  password:
wordpress:
  home:
aws:
  access_key_id:
  secret_access_key:
  bucket:
          EOF
        )
      end
    end

    private

    def aws_config
      @aws_config ||= @config['aws']
    end

    def database_config
      @database_config ||= @config['database']
    end

    def bucket_name
      @bucket_name
    end

    def wordpress_config
      @wordpress_config ||= @config['wordpress']
    end
  end
end
