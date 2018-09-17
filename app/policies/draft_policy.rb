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

  def submit?
    if record.league.public
      true
    else
      index?
    end
  end

end
