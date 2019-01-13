class Pick < ApplicationRecord
  belongs_to :draft
  belongs_to :team
  belongs_to :pickable, polymorphic: true, optional: true
  has_one :user, through: :team
  belongs_to :winner, class_name: 'Player', foreign_key: 'winner_id', optional: true

  # To allow users to delete their account while we maintain their stats
  def user
    puts self.id
    user = User.find_by_id(self.team.user)

    if user
      return user
    else
      return User.new(name: "Deleted User")
    end
  end
end
