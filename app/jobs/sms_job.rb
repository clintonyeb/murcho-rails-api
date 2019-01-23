class SmsJob < ApplicationJob
  queue_as :default

  def perform(church_id, person_ids, message)
    people = Person.where("church_id = ? AND id IN (?) AND phone_number IS NOT NULL", church_id, person_ids).select(:id, :phone_number) 

    count = 0
    people.each do |person|
      SMSService.send_sms(person[:phone_number], message)
      Action.create({
        action_type: :sms,
        recipient: person[:id],
        status: :success
      })
      count += 1
    end

    logger.info "Processed #{count} people out of #{person_ids.length}"
    count  
  end
end
