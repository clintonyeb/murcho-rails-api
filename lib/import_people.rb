class ImportPeople
  def self.do_import(church_id, file_url)
      # Download file
    file_path = CloudStorage.download_file(file_url,  'people_imports')

    data = create_file_object(file_path)
    header = data.row(1)

    (2..data.last_row).each do |i|
      row = Hash[[header, data.row(i)].transpose]
      person = Person.new()
      person.attributes = row.to_hash.slice(*accessible_attributes)
      person.save!
    end
  end

  def self.create_file_object(file_path)
    require 'csv'

    case File.extname(file_path)
    when ".csv" then Csv.new(file_path, nil, :ignore)
    when ".xls" then  Roo::Excel.new(file_path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file_path, nil, :ignore)
    else raise "Unknown file type: #{file_path}"
    end
  end

  private
end