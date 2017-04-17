class Pick < ApplicationRecord

  belongs_to :draft
  belongs_to :team
  belongs_to :player

end
