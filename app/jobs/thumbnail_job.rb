class ThumbnailJob < ApplicationJob
  queue_as :default

  def perform(person_id)
    person = Person.find(person_id)

    person.photo.blank? and return false
    
    # Download file
    file_path = CloudStorage.download_file(person.photo,  'photos')
    # if file_path.blank? raise "could not download file"

    # Use Convert to resize it
    resize_image(file_path)

    # Upload back to s3
    thumbnail_file = "thumbnail_#{get_file_name(file_path)}"
    CloudStorage.upload_file(file_path, thumbnail_file)

    # Save new url as thumbnail
    person.update(thumbnail: CloudStorage.get_aws_url(thumbnail_file))

    # Delete photo
    delete_file(file_path)

  end

  def resize_image(file_path)
    system 'convert', file_path, '-resize', '50x50', file_path
  end

  def delete_file(file_path)
    system 'rm', '-f', file_path
  end

  def get_file_name(photo)
    File.basename(photo)
  end

end
