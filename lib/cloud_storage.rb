class CloudStorage
  def self.sing_url(file_name, content_type)
    bucket_name = 'murch-app'

    s3 = Aws::S3::Client.new(
      region:               Rails.application.secrets.AWS_REGION,
      access_key_id:        Rails.application.secrets.AWS_ACCESS_KEY_ID,
      secret_access_key:    Rails.application.secrets.AWS_SECRET_ACCESS_KEY
    )
    
    signer = Aws::S3::Presigner.new(client: s3)
    name = "#{SecureRandom.uuid}-#{file_name}"
    
    # bucket = s3.bucket(bucket_name)
    # obj = bucket.object(name)
    
    url = signer.presigned_url(
      :put_object,
      bucket: bucket_name,
      key: name,
      expires_in: 300,
      # acl: 'public-read',
      content_type: content_type
    )

    return { signed_url: url, file_name: name} 
  end

  # returns path of the file on the cloud-server
  def upload_file(path)
  end
end
