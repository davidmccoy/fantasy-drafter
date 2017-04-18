class Pick < ApplicationRecord

  belongs_to :draft
  belongs_to :team
  belongs_to :player
  has_one :user, through: :team

end
