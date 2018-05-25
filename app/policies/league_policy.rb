class LeaguePolicy <  ApplicationPolicy

  def new?
    true
  end

  def create?
    new?
  end

  def show?
    (user.leagues.include? record) || admin?
  end

end
