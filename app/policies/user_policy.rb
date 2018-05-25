class UserPolicy <  ApplicationPolicy

  def show?
    user == record || admin?
  end

  def leagues?
    show?
  end

end
