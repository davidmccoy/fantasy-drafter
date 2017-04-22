class Invite < ApplicationRecord

  has_secure_token

  has_one :inviting_user, class_name: "User", foreign_key: "inviting_user_id"
  has_one :invited_user, class_name: "User", foreign_key: "invited_user_id"
  belongs_to :league

  def expired?
    Time.now > (self.created_at + 7.days)
  end

end
