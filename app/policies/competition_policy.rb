class CompetitionPolicy <  ApplicationPolicy

  def index?
    true
  end

  def new?
    admin?
  end

end
