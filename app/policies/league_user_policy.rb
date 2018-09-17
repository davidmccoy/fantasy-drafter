class LeagueUserPolicy <  ApplicationPolicy

  def index?
    user == record.league.admin || admin?
  end

  def create?
    if record.league.public
      true
    else
      index?
    end
  end

  def destroy?
    index?
  end

  def resend_invite?
    index?
  end

  def confirm?
    user == record.user || user == record.league.admin || admin?
  end

  def update?
    confirm?
  end

  def destroy?
    confirm?
  end

end
