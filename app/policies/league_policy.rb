class LeaguePolicy <  ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def show?
    record.public || (user.leagues.include? record) || admin?
  end

  def edit?
    user == record.admin || admin?
  end

  def update?
    edit?
  end

  def join?
    record.public
  end

  def group_invite?
    edit?
  end
end
