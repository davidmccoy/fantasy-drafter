class Invite < ApplicationRecord
  has_secure_token

  belongs_to :league

  before_save { self.email = email.downcase if email}
  after_create :send_invite

  def expired?
    Time.now > (self.created_at + 1.day)
  end

  private

  def send_invite
    InviteMailer.new_user(self).deliver_now unless self.for_group
  end
end
