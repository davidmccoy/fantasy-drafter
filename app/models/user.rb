class User < ApplicationRecord

  has_many :tournaments, through: :tournament_users
  belongs_to :tournament, primary_key: "user_id", class_name: "User"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  protected

  def confirmation_required?
   false
  end

end
