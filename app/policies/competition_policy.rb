class CompetitionPolicy <  ApplicationPolicy

  def index?
    true
  end

  def show?
    true 
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

end
