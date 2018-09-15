class PicksController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_draft
  before_action :set_pick
  before_action :authorize_pick, except: [:pick_x]

  def update
    if @pick.user == current_user || current_user == @pick.draft.league.admin
      return false if params[:player_id] == 0 || params[:player_id] == "undefined"
      return false if @pick.player_id
      if @pick.update(pick_params)
        # Set the response protocol
        protocol = Rails.env.production? ? "https" : "http"

        # End draft it the last pick was made
        if @pick.number == @pick.draft.picks.count
          @pick.draft.update(active: false, completed: true)
          # Email everyone to let them know the draft is over
          DraftMailer.draft_finished(@draft).deliver_now
          # Send the appropriate info over ActionCable
          ActionCable.server.broadcast "draft_#{@pick.draft.id}",
            team_id: nil,
            user_name: nil,
            player_id: nil,
            player_name: nil,
            number: nil,
            next_pick_user_name: nil,
            next_pick_team_id: nil,
            next_pick_id: nil,
            next_pick_url: nil,
            next_pick_number: nil,
            pick_order: nil,
            completed: true
        else
          # Find the next pick
          next_pick = Pick.find_by(draft_id: @pick.draft.id, number: @pick.number + 1)
          # Construct the next pick url
          next_pick_url = Rails.application.routes.url_helpers.game_competition_league_draft_pick_url(game_slug: next_pick.draft.league.leagueable.game.slug, competition_slug: next_pick.draft.league.leagueable.slug, league_id: next_pick.draft.league.id, draft_id: next_pick.draft.id, id: next_pick.id, protocol: protocol)
          # Find the next 16 picks
          pick_order = Pick.order(:number).where(draft_id: @pick.draft).limit(16).offset(next_pick.number - 1).pluck(:team_id)
          # Email the person with the next pick
          PickMailer.next_pick(next_pick).deliver_now
          # Send the appropriate info over ActionCable
          ActionCable.server.broadcast "draft_#{@pick.draft.id}",
            team_id: @pick.team_id,
            user_name: @pick.user.name,
            player_id: @pick.player_id,
            player_name: @pick.player.name,
            number: @pick.number,
            next_pick_user_name: next_pick.user.name,
            next_pick_team_id: next_pick.team_id,
            next_pick_id: next_pick.id,
            next_pick_url: next_pick_url,
            next_pick_number: next_pick.number,
            pick_order: pick_order,
            completed: false
          head :ok
        end


        # flash[:notice] = "Successfully drafted #{@pick.player.name}."
      else
        # flash[:alert] = "Pick failed."
      end
    else
      # flash[:alert] = "It's not your pick."
    end
    # redirect_to game_competition_league_draft_path(@pick.draft.league.leagueable.game, @pick.draft.league.leagueable, @pick.draft.league, @pick.draft)
  end

  def pick_x
    # TODO: why are picks being assigned player_id: 0 ?
    picks = Pick.where(id: pick_params[:my_picks].split(','), player_id: [nil, 0], team_id: current_user.team(@league).id)
    pick = picks.first

    if pick.update(player_id: pick_params[:player_id])
      protocol = Rails.env.production? ? "https" : "http"

      @response = {
        team_id: pick.team_id,
        user_name: pick.user.name,
        player_id: pick.player_id,
        player_name: pick.player.name,
        completed: false
      }
    else

    end
  end

  def remove_player
    if @pick.user == current_user || current_user == @pick.draft.league.admin
      player = @pick.player
      star = Star.find_by(draft_id: @draft.id, team_id: current_user.team(@league).id, player_id: player.id)
      if star
        player_star = {
          star_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/stars/#{star.id}",
          id: star.id,
          name: star.player.name,
          player_id: star.player.id,
          pick_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?player_id=#{star.player.id}"
        }
      else
        player_star = nil
      end
      player_info = {
        star_link: game_competition_league_draft_stars_path(
                   @draft.league.leagueable.game,
                   @draft.league.leagueable,
                   @draft.league,
                   @draft,
                   player_id: player.id,
                   protocol: "https"
                 ),
        player_id: player.id,
        points_per_result: player.points_per_result,
        results: player.results.count,
        name: player.name,
        pick_link: ("/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?player_id=#{player.id}")
      }
      if @pick.update(pick_params)
        @response = {
          team_id: @pick.team_id,
          user_name: @pick.user.name,
          pick_id: @pick.id,
          removed_player: player_info,
          removed_player_star: player_star,
          completed: false
        }
      end
    end
  end

  private

  def pick_params
    params.permit(:player_id, :my_picks)
  end

end
