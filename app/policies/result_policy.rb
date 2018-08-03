class ResultPolicy <  ApplicationPolicy

  def index?
    true
  end

  def new?
    admin?
  end

  def import?
    admin?
  end

  def team_import?
    import?
  end 

end
