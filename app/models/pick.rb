class Pick < ApplicationRecord

  belongs_to :draft
  has_one :user
  has_one :player 

end
