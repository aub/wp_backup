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

    # # Print all backups in a particular bucket
    # def print_bucket(name)
    #   msg "Showing contents of #{bucket_name(name)}"
    #   bucket = AWS::S3::Bucket.find(bucket_name(name))
    #   bucket.objects.each do |object|
    #     size = format("%.2f", object.size.to_f/1048576)
    #     puts "Name: #{object.key} (#{size}MB)"
    #   end
    # end

    # # Remove all but KEEP_NUM objects from a particular bucket
    # def cleanup_bucket(name, keep_num)
    #   msg "Cleaning up #{bucket_name(name)} (keeping last #{keep_num})"
    #   bucket = AWS::S3::Bucket.find(bucket_name(name))
    #   objects = bucket.objects
    #   remove = objects.size-keep_num-1
    #   objects[0..remove].each do |object|
    #     response = object.delete
    #   end unless remove < 0
    # end
  end
end
