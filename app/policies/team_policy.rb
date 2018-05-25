class TeamPolicy <  ApplicationPolicy

  def show?
    (user.leagues.include? record.league) || admin?
  end

  def edit?
    user == record.user || user == record.league.admin || admin?
  end

  def update?
    edit?
  end

end
