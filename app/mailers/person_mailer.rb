class PersonMailer < ApplicationMailer
  def send_mail
    items_str = "'email'"

    people = Person.not_trashed.find_by_sql(["
      SELECT *
      FROM crosstab($$SELECT schema_items.person_id as id, name, schema_items.data 
                    FROM section_schemas 
                    LEFT JOIN schema_items 
                    ON schema_items.section_schema_id=section_schemas.id
                    WHERE person_id IN (?)
                    AND name = #{items_str}
                    ORDER BY 1, 2$$) AS subs (\"id\" bigint, \"email\" varchar);", params[:person_ids]
    ])
  
    count = 0
  
    people.each do |person|
      next if person[:'email'].nil?
      @message = params[:message]
      mail(to: person['email'], subject: params[:subject])
      count += 1
    end

    logger.info "Processed #{count} people out of #{params[:person_ids].length}"
    count 

  end
end
