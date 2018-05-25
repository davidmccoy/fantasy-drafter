class PlayerPolicy <  ApplicationPolicy
  
  def new?
    admin?
  end

  def import?
    admin?
  end

end
