class CloudStorage

  def self.setup_s3
    @bucket_name = 'murch-app'
    @s3 = Aws::S3::Client.new(
      region:               Rails.application.secrets.AWS_REGION,
      access_key_id:        Rails.application.secrets.AWS_ACCESS_KEY_ID,
      secret_access_key:    Rails.application.secrets.AWS_SECRET_ACCESS_KEY
    )
    @s3
  end

  def self.sing_url(file_name, content_type)
    @s3 ||= setup_s3()
    
    signer = Aws::S3::Presigner.new(client: @s3)
    name = "#{SecureRandom.uuid}-#{file_name}"
    
    url = signer.presigned_url(
      :put_object,
      bucket: @bucket_name,
      key: name,
      expires_in: 300,
      content_type: content_type
    )

    return { signed_url: url, file_name: name} 
  end

  # returns path of the file on the cloud-server
  def self.upload_file(file_path, thumbnail)
    @s3 ||= setup_s3()

    resp = @s3.put_object({
      body: IO.read(file_path), 
      bucket: @bucket_name, 
      key: thumbnail, 
    })
    
  end

  def self.get_file_name(photo)
    photo.base_uri.to_s.split('/')[-1]
  end

  def self.download_file(file_path)
    require 'open-uri'
    download = open(file_path)

    dir = Rails.root.join('tmp/photos')
    system 'mkdir', '-p', dir.to_path

    download_path = "#{dir}/#{get_file_name(download)}"
    IO.copy_stream(download, download_path)
    
    download_path
  end
end
