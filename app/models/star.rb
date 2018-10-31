class Star < ApplicationRecord

  belongs_to :draft
  belongs_to :team
  belongs_to :starrable, polymorphic: true
  has_one :user, through: :team

end
