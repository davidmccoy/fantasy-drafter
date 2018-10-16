class CompetitionPlayerPolicy <  ApplicationPolicy

  def index?
    true
  end

  def new?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def import?
    admin?
  end

end
