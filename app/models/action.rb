class Action < ApplicationRecord
  enum type: [:email, :sms]
  enum recipients_type: [:people]
  enum status: [:success, :failed]
end
