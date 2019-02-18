class LeagueUser < ApplicationRecord
  belongs_to :league
  belongs_to :user
  has_one :team, dependent: :destroy
  has_one :purchase, as: :purchasable

  validates_uniqueness_of :user_id, scope: :league_id

  # To allow users to delete their account while we maintain their stats
  def user
    user = User.find_by_id(self.user_id)
    if user
      return user
    else
      return User.new(name: "Deleted User")
    end
  end
end
