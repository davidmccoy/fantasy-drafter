json.draft do
  json.rounds @draft.league.num_draft_rounds
  json.competition_name @draft.league.leagueable.name
  json.competition_date @draft.league.leagueable.date
end
