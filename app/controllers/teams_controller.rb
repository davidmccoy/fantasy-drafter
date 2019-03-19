class TeamsController < ApplicationController
  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_team
  before_action :authorize_team

  def show
    if @league.pick_type == 'player'
      @players = @team.players
      @player_type = 'Player'
      @picks = @team.picks
    elsif @league.pick_type == 'card'
      @players = @team.cards
      @player_type = 'Card'
      @picks = @team.picks
    end

    if @league.draft_type == 'bracket'
      finals = @competition.matches.where(group: "finals").first
      @winner = Pick.find_by(draft_id: @league.draft.id, team_id: @team.id, pickable_id: finals.id, pickable_type: 'Match')
      @matches = @team.matches.sort_by {|match| [match.group, match.round, match.bracket_position] }
    end
  end

  def edit
  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Successfully updated team."
      redirect_to game_competition_league_team_path(@team.league.leagueable.game, @team.league.leagueable, @team.league, @team) and return
    else
      flash[:alert] = @team.errors.messages
      redirect_to edit_game_competition_league_team_path(@team.league.leagueable.game, @team.league.leagueable, @team.league, @team) and return
    end
  end

  private

  def team_params
    params.require(:team).permit(:name, :supporting)
  end
end
