class Api::DraftsController < ApplicationController
  before_action :set_draft

  def available_players
    if !@draft.completed
      if @draft.league.pick_type == 'player'
        if @draft.league.draft_type == 'snake'
          @available_players = @draft.league.leagueable.players.where.not(
            id: @draft.picks.pluck(:pickable_id)
          )

          @current_pick = @draft.picks
          .where(pickable_id: nil)
          .sort_by{ |pick| pick.number }.first
        elsif @draft.league.draft_type == 'pick_em'
          @available_players = @draft.league.leagueable.matches.where.not(
            id: current_user.team(@draft.league).matches.where.not(winner_id: nil).pluck(:id)
          )
          # @current_pick = @draft.picks
          # .where(pickable_type: 'Player', pickable_id: nil)
          # .sort_by{ |pick| pick.number }.first
        else
          @available_players = @draft.league.leagueable.players.where.not(
            id: current_user.team(@draft.league).players.pluck(:id)
          )

          @current_pick = @draft.picks
          .where(pickable_type: 'Player', pickable_id: nil)
          .sort_by{ |pick| pick.number }.first
        end
      elsif @draft.league.pick_type == 'card'
        if @draft.league.draft_type == 'snake'
          @available_players = @draft.league.leagueable.cards.where.not(
            id: @draft.picks.pluck(:pickable_id)
          )

          @current_pick = @draft.picks
          .where(pickable_id: nil)
          .sort_by{ |pick| pick.number }.first
        else
          @available_players = @draft.league.leagueable.cards.where.not(
            id: current_user.team(@draft.league).cards.pluck(:id)
          )

          @current_pick = @draft.picks
          .where(pickable_type: 'Card', pickable_id: nil)
          .sort_by{ |pick| pick.number }.first
        end
      end
    else
      @available_players = nil
      @current_pick = nil
    end
  end

  def available_cards
    if !@draft.completed
    else
      @available_cards = nil
      @current_pick = nil
    end
  end

  def all_teams
    current_team = @draft.league.teams.find_by_id(current_user.team(@draft.league))

    if @draft.league.draft_type == 'snake'
      current_team_players =
      current_team.picks.order(:number).map { |pick|
        {
          pick_number: pick.number,
          player_id: pick.pickable&.id,
          player_type: pick.pickable&.class&.name,
          name: pick.pickable&.name,
          elo: pick.pickable_type == 'Player' ? pick.pickable&.elo : nil,
          points: pick.pickable_type == 'Player' ? pick.pickable&.points: nil,
          xrank: pick.pickable_type == 'Player' ? pick.pickable&.power_ranking : pick.pickable&.xrank(pick.draft.league.leagueable),
          percent_of_decks: pick.pickable_type == 'Card' ? pick.pickable&.percent_of_decks(pick.draft.league.leagueable) : nil,
          number_of_copies: pick.pickable_type == 'Card' ? pick.pickable&.number_of_copies(pick.draft.league.leagueable) : nil
        }
      }
    elsif @draft.league.draft_type == 'pick_x'
      if @draft.league.pick_type == 'player'
        current_team_players = current_team.players.order(:power_ranking).map { |player|
          {
            name: player.name,
            player_id: player.id,
            player_type: 'Player',
            elo: player.elo,
            points: player.points,
            power_ranking: player.power_ranking,
            delete_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/remove_player?pick_id=#{@draft.picks.find_by(pickable_type: 'Player', pickable_id: player.id, team_id: current_team.id).id}&pickable_id=nil"
          }
        }
      elsif @draft.league.pick_type == 'card'
        current_team_players = current_team.cards.sort { |a,b| a.xrank(@draft.league.leagueable) <=> b.xrank(@draft.league.leagueable) }
          .map { |card|
          {
            name: card.name,
            player_id: card.id,
            player_type: 'Card',
            xrank: card.xrank(@draft.league.leagueable),
            percent_of_decks: card.percent_of_decks(@draft.league.leagueable),
            number_of_copies: card.number_of_copies(@draft.league.leagueable),
            delete_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/remove_player?pick_id=#{@draft.picks.find_by(pickable_type: 'Card', pickable_id: card.id, team_id: current_team.id).id}&pickable_id=nil"
          }
        }
      end

      Pick.where(team_id: current_team.id, pickable_id: [nil, 0]).count.times do
        current_team_players << { name: nil, delete_link: nil }
      end
    elsif @draft.league.draft_type == 'special'
      current_team_players = current_team.players.order(:power_ranking).map { |player| {name: player.name, player_id: player.id, player_type: player&.player_type&.capitalize, elo: player.elo, power_ranking: player.power_ranking, delete_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/remove_player?pick_id=#{@draft.picks.find_by(player_id: player.id, team_id: current_team.id).id}&pickable_id=nil" } }

      Pick.where(team_id: current_team.id, player_id: [nil, 0]).count.times do
        current_team_players << { name: nil, delete_link: nil }
      end
    elsif @draft.league.draft_type == 'pick_em'
      current_team_players = current_team.matches
    end


    @my_team = {
      user_id: current_user.id,
      team_id: current_team.id,
      name: current_team.name,
      players: current_team_players
    }

    @teams = []
    @draft.league.teams.where.not(id: current_user.team(@draft.league)).each do |team|
      players = []
      team.players.each do |player|
        players << {
          id: player.id,
          name: player.name
        }
      end
      @teams << {
        user_id: team.user.id,
        team_id: team.id,
        name: team.name,
        players: players
      }
    end
  end

  def show
  end

  private

  def set_draft
    @draft = Draft.find_by_id(params[:draft_id]) || Draft.find_by_id(params[:id])
  end
end
