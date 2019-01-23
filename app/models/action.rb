class Action < ApplicationRecord
  enum action_type: [:email, :sms]
  enum recipients_type: [:people]
  enum status: [:success, :failed]
end
