class CompetitionPolicy <  ApplicationPolicy

  def index?
    true
  end

  def new?
    admin?
  end

  def create?
    admin?
  end 

end
