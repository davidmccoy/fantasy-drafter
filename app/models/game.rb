class Game < ApplicationRecord

  has_many :competitions
  has_many :results

  enum category: [:Unknown, :TCG]

  before_save { self.slug = slug.downcase if slug}

  def to_param
    slug
  end

end
