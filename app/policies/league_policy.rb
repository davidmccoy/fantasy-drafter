class LeaguePolicy <  ApplicationPolicy
  def index?
    true
  end

  def new?
    admin?
  end

  def create?
    admin?
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
end
