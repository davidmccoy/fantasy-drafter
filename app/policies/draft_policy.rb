class DraftPolicy <  ApplicationPolicy

  def show?
    (user.leagues.include? record.league) || admin?
  end

  def update?
    user == record.league.admin || admin?
  end

  def start?
    update?
  end

  def submit?
    if record.league.draft_type == 'pick_x' || record.league.draft_type == 'pick_em'
      true
    elsif record.league.draft_type == 'special'
      true
    else
      index?
    end
  end

end
