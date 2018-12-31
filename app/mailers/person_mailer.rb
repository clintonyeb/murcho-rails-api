class PersonMailer < ApplicationMailer
  def send_mail
    people = Person.where("church_id = ? AND id IN (?) AND email IS NOT NULL", params[:church_id], params[:person_ids]).select(:id, :email) 
  
    count = 0
    people.each do |person|
      @message = params[:message]
      mail(to: person[:email], subject: params[:subject])
      Action.create({
        type: :email,
        recipient: person[:id],
        status: :success
      })
      count += 1
    end

    logger.info "Processed #{count} people out of #{params[:person_ids].length}"
    count 

  end
end
