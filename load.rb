require 'aws-sdk-s3'
require 'yaml'

class Load
  def self.run(params)
    new(params).send(:perform)
  end

  private

  attr_accessor :region, :access_key, :secret_access_key, :bucket, :destination

  def initialize(params)
    %w(region access_key secret_access_key bucket destination).each do |k|
      val = params[k]
      fail "#{k} missing parameter" if val.nil?
      instance_variable_set("@#{k}", val)
    end
  end

  def perform
    return unless bucket_exists?

    upload_dirs
  end

  def s3
    @s3 ||= Aws::S3::Client.new(
      access_key_id:     access_key,
      secret_access_key: secret_access_key,
      region:            region
    )
  end

  def bucket_exists?
    return true if s3.list_objects_v2(bucket:   bucket,
                                      max_keys: 1,
                                      prefix:   destination)
    false
  rescue StandardError => e
    puts "Error: #{e.message}"
    return false
  end

  def upload_dirs
    source_dirs.each { |dir| upload_files(dir) }
  end

  def upload_files(dir)
    get_files(dir).each { |f| upload_file(f) }
  end

  def upload_file(file)
    key = "#{destination}#{file[2..file.length]}"
    s3.get_object({ bucket: bucket, key: key })
    puts "Skipping upload. #{key} already exists."
  rescue Aws::S3::Errors::NoSuchKey
    puts "Uploading #{key}...."
    s3.put_object({ bucket: bucket, key: key, body: File.read(file)})
  end

  def get_files(dir)
    Dir.glob("./#{dir}/**/*").select { |f| !File.directory?(f) }
  end

  def source_dirs
    Dir.entries('./').select do |f|
      File.directory?("./#{f}") && !['.','..','var'].include?(f)
    end
  end
end

Load.run(YAML.load_file('env').dig('s3'))
