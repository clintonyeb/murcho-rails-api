class ExportPeople
  def self.export(format, church_id, people_ids)
    people = Person.where("church_id = ? AND id IN (?)", church_id, people_ids).select(:first_name, :last_name, :photo, :phone_number, :email, :membership_status, :date_joined, :created_at, :updated_at)
    church = Church.find(church_id)
    church_name = church.name.parameterize.underscore
    current_time = Time.now.strftime("%d_%m_%Y_%H_%M_%S_%L")
    file_name = "#{church_name}-#{current_time}.csv"

    case format
    when 'csv'
      file_path  = self.to_csv(people, file_name)
      CloudStorage.upload_file(file_path, file_name)
      delete_file(file_path)

      return CloudStorage.get_aws_url(file_name)
    else
      return false
    end
  end

  private

  def self.to_csv(people, file_name)
    require 'csv'

    dir = Rails.root.join('tmp/people_exports')
    system 'mkdir', '-p', dir.to_path

    file = "#{dir.to_path}/#{file_name}"

    CSV.open(file, "wb") do |csv|
      csv << people.attribute_names
      people.each do |person|
        csv << person.attributes.values
      end
    end
    
    file
  end

  def self.delete_file(file_path)
    system 'rm', '-f', file_path
  end
end