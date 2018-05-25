class DraftPolicy <  ApplicationPolicy

  def show?
    (user.leagues.include? record.league) || admin?
  end

  def update?
    user == record.league.admin || admin?
  end

  def start?
    update?
  end

end
