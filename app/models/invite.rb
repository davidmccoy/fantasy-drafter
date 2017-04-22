class Invite < ApplicationRecord

  has_secure_token

  belongs_to :inviting_user, class_name: "User", foreign_key: "inviting_user_id"
  belongs_to :invited_user, class_name: "User", foreign_key: "invited_user_id"
  belongs_to :league

  after_create :send_invite

  def expired?
    Time.now > (self.created_at + 7.days)
  end

  private

  def send_invite
    InviteMailer.new_user(self).deliver_later
  end

end
