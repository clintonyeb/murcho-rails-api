class SmsJob < ApplicationJob
  queue_as :default

  def perform(person_ids, message)
    items_str = "'phone number'"

    people = Person.not_trashed.find_by_sql(["
      SELECT *
      FROM crosstab($$SELECT schema_items.person_id as id, name, schema_items.data 
                    FROM section_schemas 
                    LEFT JOIN schema_items 
                    ON schema_items.section_schema_id=section_schemas.id
                    WHERE person_id IN (?)
                    AND name = #{items_str}
                    ORDER BY 1, 2$$) AS subs (\"id\" bigint, \"phone_number\" varchar);", person_ids
    ])
  
    count = 0
    
    people.each do |person|
      next if person[:'phone_number'].nil?
      SMSService.send_sms(person['phone_number'], message)
      count += 1
    end

    logger.info "Processed #{count} people out of #{person_ids.length}"
    count  
  end
end
