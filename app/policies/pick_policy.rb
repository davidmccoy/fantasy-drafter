class PickPolicy <  ApplicationPolicy

  def update?
    user == record.user || user == record.draft.league.admin || admin?
  end

  def remove_player?
    update?
  end

end
