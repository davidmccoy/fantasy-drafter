import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import AvailablePlayersTable from "./available_players_table";
import Bracket from "./bracket";
import DraftInstructions from "./draft_instructions";
import DraftViewerRightPanel from "./draft_viewer_right_panel";
import SubmitMessage from "./submit_message";

class DraftViewer extends React.Component {
  constructor() {
    super();
    this.state = {
      data: [],
      loading: true,
      myStars: [],
      completed: false
    };

    this.fetchData = this.fetchData.bind(this);
    this.fetchPlayers = this.fetchPlayers.bind(this);
    this.fetchTeams = this.fetchTeams.bind(this);
    this.componentDidMount = this.componentDidMount.bind(this);
    this.updateTableData = this.updateTableData.bind(this);
    this.starPlayer = this.starPlayer.bind(this);
    this.pickPlayer = this.pickPlayer.bind(this);
    this.removePlayer = this.removePlayer.bind(this);
    this.pickMatch = this.pickMatch.bind(this);
    this.pickBracketMatch = this.pickBracketMatch.bind(this);
  }

  componentDidMount() {
    this.setState({
      currentPick: this.props.currentPick,
      currentPickId: this.props.currentPickId
    })
    this.fetchData();
    if (this.props.draftType === 'snake') {
      this.setupSubscription();
    }
  }

  updateTableData() {
    this.fetchData();
  }

  fetchData() {
    this.fetchPlayers();
    this.fetchTeams();
    this.fetchStars();
  }

  fetchPlayers() {
    this.setState({ loading: true })
    $.ajax({
      url: `/api/drafts/${this.props.draftId}/available_players`,
      dataType: 'json',
      success: function(data){
        this.setState({
          data: data.players,
          loading: false
        })
      }.bind(this)
    });
  }

  fetchTeams() {
    $.ajax({
      url: `/api/drafts/${this.props.draftId}/all_teams`,
      dataType: 'json',
      success: function(data){
        this.setState({
          myTeam: data.my_team,
          otherTeams: data.teams
        })
      }.bind(this)
    });
  }

  fetchStars() {
    $.ajax({
      url: `/api/drafts/${this.props.draftId}/stars`,
      dataType: 'json',
      success: function(data){
        this.setState({
          myStars: data.stars
        })
      }.bind(this)
    });
  }

  starPlayer(url, method) {
    $.ajax({
      url: url,
      method: method,
      dataType: 'json',
      success: function(data){
        if (this.state.myStars.some(item => data.star.id === item.id) === false) {
          let currentState = this.state.myStars;
          currentState.push(data.star);
          this.setState({
            myStars: currentState
          })
        } else {
          this.setState({
            myStars: this.state.myStars.filter(e => e.id !== data.star.id)
          })
        }
      }.bind(this)
    });
  }

  pickPlayer(url) {
    let pickUrl = this.props.draftType === 'snake' ?
      url.replace('pick-number', this.state.currentPickId) :
      (this.props.draftType === 'pick_x' ?
        url.replace('pick-number', 'pick_x') + '&my_picks=' + this.props.myPicks.toString() :
        url.replace('pick-number', 'special') + '&my_picks=' + this.props.myPicks.toString()
      );

    $.ajax({
      url: pickUrl,
      method: 'PUT',
      dataType: 'json',
      success: function(data){
        if (this.props.draftType !== 'snake') {
          this.setState({
            myStars: this.state.myStars.filter(e => e.player_id !== data.response.player_id),
            data: this.state.data.filter(e => e.player_id !== data.response.player_id),
            completed: data.response.completed
          })
          this.fetchTeams();
        }
      }.bind(this)
    });
  }

  pickMatch(event) {
    let matchId = event.target.parentElement.id;
    let winnerId = event.target.value;
    let matches = this.state.myTeam.players.map(function(event) {
      if (event.id === parseInt(matchId)) {
        return {
          arcanis_event_id: event.arcanis_event_id,
          arcanis_id: event.arcanis_id,
          arcanis_player_a_id: event.arcanis_player_a_id,
          arcanis_player_b_id: event.arcanis_player_b_id,
          competition_id: event.competition_id,
          id: event.id,
          player_a_id: event.player_a_id,
          player_b_id: event.player_b_id,
          result: event.result,
          winner_id: winnerId == '' ? null : winnerId
        }
      } else {
        return {
          arcanis_event_id: event.arcanis_event_id,
          arcanis_id: event.arcanis_id,
          arcanis_player_a_id: event.arcanis_player_a_id,
          arcanis_player_b_id: event.arcanis_player_b_id,
          competition_id: event.competition_id,
          id: event.id,
          player_a_id: event.player_a_id,
          player_b_id: event.player_b_id,
          result: event.result,
          winner_id: event.winner_id
        }
      }
    })

    this.setState({
      myTeam: {
        players: matches
      }
    });
  }

  pickBracketMatch(matchId, winnerId, winnerName, bracketSection) {
    let nextBracketMatchPlayerA = this.state.myTeam.players.filter(e => (e.player_a_previous_match_id === matchId) && (e.bracket_section === bracketSection))[0]
    let nextBracketMatchPlayerB = this.state.myTeam.players.filter(e => (e.player_b_previous_match_id === matchId) && (e.bracket_section === bracketSection))[0]

    let losersNextLoserBracketMatch = null
    let nextBracketMatchPlayerAAlreadyHasWinner = nextBracketMatchPlayerA ? (nextBracketMatchPlayerA.winner_id ? true : false) : false
    if (nextBracketMatchPlayerAAlreadyHasWinner && bracketSection === 'winners') {
      losersNextLoserBracketMatch = this.state.myTeam.players.filter(e => (e.player_a_previous_match_id === nextBracketMatchPlayerA.id) && (e.bracket_section === 'losers'))[0]
    }

    let nextBracketMatchPlayerBAlreadyHasWinner = nextBracketMatchPlayerB ? (nextBracketMatchPlayerB.winner_id ? true : false) : false
    if (nextBracketMatchPlayerBAlreadyHasWinner && bracketSection === 'winners') {
      losersNextLoserBracketMatch = this.state.myTeam.players.filter(e => (e.player_a_previous_match_id === nextBracketMatchPlayerB.id) && (e.bracket_section === 'losers'))[0]
    }

    let nextLosersBracketMatchPlayerA = this.state.myTeam.players.filter(e => (e.player_a_previous_match_id === matchId) && (e.bracket_section === (bracketSection === 'winners' ? 'losers' : 'winners')))[0]
    let nextLosersBracketMatchPlayerB = this.state.myTeam.players.filter(e => (e.player_b_previous_match_id === matchId) && (e.bracket_section === (bracketSection === 'winners' ? 'losers' : 'winners')))[0]

    let pickedMatch = this.state.myTeam.players.filter(e => (e.id === matchId) && (e.bracket_section === bracketSection))[0]
    let pickedMatchWinnerId = pickedMatch.winner_id
    let previouslyPickedMatchIds = []

    if (pickedMatchWinnerId !== null) {
      previouslyPickedMatchIds = this.state.myTeam.players.filter(e => (((e.player_a_id === pickedMatch.winner_id)) || (e.player_b_id === pickedMatch.winner_id)) && (e.round > pickedMatch.round + 1)).map(e => e.id)
    }

    let pickedMatchLoserId = pickedMatch.winner_id === pickedMatch.player_a_id ? pickedMatch.player_b_id : pickedMatch.player_a_id
    let previouslyPickedLoserMatchIds = []

    if (pickedMatchLoserId !== null) {
      previouslyPickedLoserMatchIds = this.state.myTeam.players.filter(e => (((e.player_a_id === pickedMatchLoserId)) || (e.player_b_id === pickedMatchLoserId)) && (e.round > pickedMatch.round + 1)).map(e => e.id)
    }

    let matches = this.state.myTeam.players.map(function(match) {
      if (match.id === parseInt(matchId)) {
        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_a_image_url: match.player_a_image_url,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          player_b_image_url: match.player_b_image_url,
          round: match.round,
          winner_id: winnerId == '' ? null : winnerId
        }
      } else if (nextBracketMatchPlayerA && match.id === nextBracketMatchPlayerA.id) {
        let pickedMatchWinnerSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_seed : pickedMatch.player_b_seed
        let pickedMatchWinnerImageUrl = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_image_url : pickedMatch.player_b_image_url

        let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id

        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: winnerId,
          player_a_name: winnerName,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: pickedMatchWinnerSeed,
          player_a_image_url: pickedMatchWinnerImageUrl,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          player_b_image_url: match.player_b_image_url,
          round: match.round,
          winner_id: matchWinnerId
        }
      } else if (nextBracketMatchPlayerB && match.id === nextBracketMatchPlayerB.id) {
        let pickedMatchWinnerSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_seed : pickedMatch.player_b_seed
        let pickedMatchWinnerImageUrl = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_image_url : pickedMatch.player_b_image_url

        let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_a_image_url: match.player_a_image_url,
          player_b_id: winnerId,
          player_b_name: winnerName,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: pickedMatchWinnerSeed,
          player_b_image_url: pickedMatchWinnerImageUrl,
          round: match.round,
          winner_id: matchWinnerId
        }
      } else if (nextLosersBracketMatchPlayerA && match.id === nextLosersBracketMatchPlayerA.id) {
        let pickedMatchLoserSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_seed : pickedMatch.player_a_seed
        let pickedMatchLoserImageUrl = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_image_url : pickedMatch.player_a_image_url
        let pickedMatchLoserName = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_name : pickedMatch.player_a_name
        let pickedMatchLoserId = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_id : pickedMatch.player_a_id
        let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: pickedMatchLoserId,
          player_a_name: pickedMatchLoserName,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: pickedMatchLoserSeed,
          player_a_image_url: pickedMatchLoserImageUrl,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          player_b_image_url: match.player_b_image_url,
          round: match.round,
          winner_id: matchWinnerId
        }
      } else if (nextLosersBracketMatchPlayerB && match.id === nextLosersBracketMatchPlayerB.id) {
        let pickedMatchLoserSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_seed : pickedMatch.player_a_seed
        let pickedMatchLoserImageUrl = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_image_url : pickedMatch.player_a_image_url
        let pickedMatchLoserName = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_name : pickedMatch.player_a_name
        let pickedMatchLoserId = winnerId === pickedMatch.player_a_id ? pickedMatch.player_b_id : pickedMatch.player_a_id
        let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_a_image_url: match.player_a_image_url,
          player_b_id: pickedMatchLoserId,
          player_b_name: pickedMatchLoserName,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: pickedMatchLoserSeed,
          player_b_image_url: pickedMatchLoserImageUrl,
          round: match.round,
          winner_id: matchWinnerId
        }
      } else if (losersNextLoserBracketMatch && match.id === losersNextLoserBracketMatch.id) {
        let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
        let pickedMatchLoserSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_seed : pickedMatch.player_b_seed
        let pickedMatchLoserImageUrl = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_image_url : pickedMatch.player_b_image_url
        let pickedMatchLoserName = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_name : pickedMatch.player_b_name
        let pickedMatchLoserId = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_id : pickedMatch.player_b_id

        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: pickedMatchLoserId,
          player_a_name: pickedMatchLoserName,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: pickedMatchLoserSeed,
          player_a_image_url: pickedMatchLoserImageUrl,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          player_b_image_url: match.player_b_image_url,
          round: match.round,
          winner_id: matchWinnerId
        }

      } else if (previouslyPickedMatchIds.includes(match.id)) {
        if (pickedMatchWinnerId == match.player_a_id) {
          let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
          return {
            bracket_position: match.bracket_position,
            bracket_section: match.bracket_section,
            competition_id: match.competition_id,
            group: match.group,
            id: match.id,
            player_a_id: null,
            player_a_name: null,
            player_a_previous_match_id: match.player_a_previous_match_id,
            player_a_seed: null,
            player_a_image_url: null,
            player_b_id: match.player_b_id,
            player_b_name: match.player_b_name,
            player_b_previous_match_id: match.player_b_previous_match_id,
            player_b_seed: match.player_b_seed,
            player_b_image_url: match.player_b_image_url,
            round: match.round,
            winner_id: matchWinnerId
          }
        } else if (pickedMatchWinnerId == match.player_b_id) {
          let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
          return {
            bracket_position: match.bracket_position,
            bracket_section: match.bracket_section,
            competition_id: match.competition_id,
            group: match.group,
            id: match.id,
            player_a_id: match.player_a_id,
            player_a_name: match.player_a_name,
            player_a_previous_match_id: match.player_a_previous_match_id,
            player_a_seed: match.player_a_seed,
            player_a_image_url: match.player_a_image_url,
            player_b_id: null,
            player_b_name: null,
            player_b_previous_match_id: match.player_b_previous_match_id,
            player_b_seed: null,
            player_b_image_url: null,
            round: match.round,
            winner_id: matchWinnerId
          }
        }
      } else if (previouslyPickedLoserMatchIds.includes(match.id)) {
        if (pickedMatchLoserId == match.player_a_id) {
          let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
          return {
            bracket_position: match.bracket_position,
            bracket_section: match.bracket_section,
            competition_id: match.competition_id,
            group: match.group,
            id: match.id,
            player_a_id: null,
            player_a_name: null,
            player_a_previous_match_id: match.player_a_previous_match_id,
            player_a_seed: null,
            player_a_image_url: null,
            player_b_id: match.player_b_id,
            player_b_name: match.player_b_name,
            player_b_previous_match_id: match.player_b_previous_match_id,
            player_b_seed: match.player_b_seed,
            player_b_image_url: match.player_b_image_url,
            round: match.round,
            winner_id: matchWinnerId
          }
        } else if (pickedMatchLoserId == match.player_b_id) {
          let matchWinnerId = pickedMatchWinnerId === match.winner_id ? null : match.winner_id
          return {
            bracket_position: match.bracket_position,
            bracket_section: match.bracket_section,
            competition_id: match.competition_id,
            group: match.group,
            id: match.id,
            player_a_id: match.player_a_id,
            player_a_name: match.player_a_name,
            player_a_previous_match_id: match.player_a_previous_match_id,
            player_a_seed: match.player_a_seed,
            player_a_image_url: match.player_a_image_url,
            player_b_id: null,
            player_b_name: null,
            player_b_previous_match_id: match.player_b_previous_match_id,
            player_b_seed: null,
            player_b_image_url: null,
            round: match.round,
            winner_id: matchWinnerId
          }
        }
      } else {
        return {
          bracket_position: match.bracket_position,
          bracket_section: match.bracket_section,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_a_image_url: match.player_a_image_url,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          player_b_image_url: match.player_b_image_url,
          round: match.round,
          winner_id: match.winner_id
        }
      }
    })

    this.setState({
      myTeam: {
        players: matches
      }
    });
  }

  removePlayer(url) {
    $.ajax({
      url: url,
      method: 'PUT',
      dataType: 'json',
      success: function(data){
        if (this.props.draftType !== 'snake') {
          this.setState({
            myStars: (data.response.removed_player_star !== undefined && data.response.removed_player_star !== null) && !this.state.myStars.some(item => data.response.removed_player_star.player_id === item.player_id) ? [...this.state.myStars, data.response.removed_player_star] : this.state.myStars,
            data: [...this.state.data, data.response.removed_player]
          })
          this.fetchTeams();
        }
      }.bind(this)
    });
  }

  footerVisible() {
    return $(window).scrollTop() + $(window).height() > $(document).height() - $('footer').outerHeight()
  }

  setupSubscription(){
    const thisDraftID = this.props.draftId
    App.comments = App.cable.subscriptions.create(
      {
        channel: "DraftsChannel",
        draft: thisDraftID
      },
      {
        connected: function () {
          setTimeout(() => this.perform('subscribed',
                                        { draft: thisDraftID }), 1000 );
        },
        received: function (data) {
          if (data.completed === false) {
            this.setState({
              currentPick: data.next_pick_number,
              currentPickId: data.next_pick_id,
              myStars: (data.removed_player_star !== undefined && data.removed_player_star !== null) && !this.state.myStars.some(item => data.removed_player_star.player_id === item.player_id) ? [...this.state.myStars, data.removed_player_star] : this.state.myStars.filter(e => e.player_id !== data.player_id),
              data: data.removed_player !== undefined && !this.state.data.some(item => data.removed_player.player_id === item.player_id) ? [...this.state.data, data.removed_player] : this.state.data.filter(e => e.player_id !== data.player_id)
            })
            this.fetchTeams();
          }
        }.bind(this)
      }
    );
  }

  render() {
    return (
      <div id="something" className="row">
        { this.props.draftType !== 'bracket' &&
          <div id="players" className="col-md-6">
            <DraftInstructions
              draftType={this.props.draftType}
              pickType={this.props.pickType}
            />
            <AvailablePlayersTable
              data={this.state.data}
              loading={this.state.loading}
              handleStar={this.starPlayer}
              currentPick={this.state.currentPick}
              handlePick={this.pickPlayer}
              handleMatchPick={this.pickMatch}
              myPicks={this.props.myPicks}
              myStars={this.state.myStars}
              myTeam={this.state.myTeam}
              draftType={this.props.draftType}
              pickType={this.props.pickType}
            />
          </div>
        }
        { this.props.draftType !== 'bracket' &&
          <div id="left-tabbed-panel" className="col-md-6">
            <DraftViewerRightPanel
              otherTeams={this.state.otherTeams}
              myTeam={this.state.myTeam}
              myStars={this.state.myStars}
              currentPick={this.state.currentPick}
              myPicks={this.props.myPicks}
              handleStar={this.starPlayer}
              handlePick={this.pickPlayer}
              handleRemovePlayer={this.removePlayer}
              draftId={this.props.draftId}
              draftType={this.props.draftType}
              pickType={this.props.pickType}
              competitionName={this.props.competitionName}
              allPlayers={this.state.data}
            />
          </div>
        }
        { (this.props.draftType === 'bracket') && (this.props.competitionName == 'Spark Madness') &&
          <div id="left-tabbed-panel" className="col-md-12">
            <div id="bracket-instructions" className="row">
              <div className="col-md">
                <div className="bracket-instruction">
                  1. Click on the Planeswalkers to fill out your bracket.
                </div>
              </div>
              <div className="col-md">
                <div className="bracket-instruction">
                  2. To make changes, just click on the Planeswalker you want to win instead.
                </div>
              </div>
              <div className="col-md">
                <div className="bracket-instruction">
                  3. Submit your bracket after you have filled it out!
                </div>
              </div>
            </div>
            <Bracket
              myTeam={this.state.myTeam}
              myPicks={this.props.myPicks}
              handlePick={this.pickPlayer}
              handleRemovePlayer={this.removePlayer}
              draftId={this.props.draftId}
              draftType={this.props.draftType}
              pickType={this.props.pickType}
              competitionName={this.props.competitionName}
              handlePick={this.pickBracketMatch}
            />
          </div>
        }
        { (this.props.draftType === 'bracket') && (this.props.competitionName == 'Mythic Invitational') &&
          <div id="left-tabbed-panel" className="col-md-12">
            <div id="bracket-instructions" className="row">
              <div className="col-md">
                <div className="bracket-instruction">
                  1. Click on the players to fill out your bracket.
                </div>
              </div>
              <div className="col-md">
                <div className="bracket-instruction">
                  2. To make changes, just click on the player you want to win instead.
                </div>
              </div>
              <div className="col-md">
                <div className="bracket-instruction">
                  3. The losers of each match in the Winner's bracket will appear in the Loser's bracket for you to choose again.
                </div>
              </div>
              <div className="col-md">
                <div className="bracket-instruction">
                  4. Submit your bracket after you have filled it out!
                </div>
              </div>
            </div>
            <Bracket
              myTeam={this.state.myTeam}
              myPicks={this.props.myPicks}
              handlePick={this.pickPlayer}
              handleRemovePlayer={this.removePlayer}
              draftId={this.props.draftId}
              draftType={this.props.draftType}
              pickType={this.props.pickType}
              competitionName={this.props.competitionName}
              handlePick={this.pickBracketMatch}
            />
          </div>
        }
        { this.props.draftType !== 'snake' && this.props.draftType !== 'pick_em' && this.props.draftType !== 'bracket' &&
          <div id="submit-message" className={(this.state.myTeam !== undefined && (this.state.myTeam.players.filter(e => e.name !== null).length !== this.props.myPicks.length)) ?  "submit-message submit-message-absolute" : (this.footerVisible() ? "submit-message submit-message-absolute alert-ready-to-submit" : "submit-message submit-message-absolute alert-ready-to-submit alert-fixed") }>
            <SubmitMessage
              myTeam={this.state.myTeam}
              myPicks={this.props.myPicks}
              draftSubmitLink={this.props.draftSubmitLink}
              pickType={this.props.pickType}
            />
          </div>
        }
        { this.props.draftType === 'pick_em' &&
          <div id="submit-message" className={(this.state.myTeam !== undefined && (this.state.myTeam.players.filter(e => e.winner_id !== null).length !== this.props.myPicks.length)) ?  "submit-message submit-message-absolute" : (this.footerVisible() ? "submit-message submit-message-absolute alert-ready-to-submit" : "submit-message submit-message-absolute alert-ready-to-submit alert-fixed") }>
            <SubmitMessage
              myTeam={this.state.myTeam}
              myPicks={this.props.myPicks}
              draftSubmitLink={this.props.draftSubmitLink}
              pickType={this.props.pickType}
              draftType={this.props.draftType}
            />
          </div>
        }
        { this.props.draftType === 'bracket' &&
          <div id="submit-message" className={(this.state.myTeam !== undefined && (this.state.myTeam.players.filter(e => e.winner_id !== null).length !== this.props.myPicks.length)) ?  "submit-message submit-message-absolute" : (this.footerVisible() ? "submit-message submit-message-absolute alert-ready-to-submit" : "submit-message submit-message-absolute alert-ready-to-submit alert-fixed") }>
            <SubmitMessage
              myTeam={this.state.myTeam}
              myPicks={this.props.myPicks}
              draftSubmitLink={this.props.draftSubmitLink}
              pickType={this.props.pickType}
              draftType={this.props.draftType}
            />
          </div>
        }
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('draft-details-container');
  const draftId = node.getAttribute('data');
  const teamId = node.getAttribute('data-team');
  const currentPick = parseInt(node.getAttribute('data-current-pick'));
  const currentPickId = node.getAttribute('data-current-pick-id');
  const myPicks = JSON.parse(node.getAttribute('data-your-picks'));
  const draftType = node.getAttribute('data-draft-type');
  const pickType = node.getAttribute('data-pick-type');
  const draftSubmitLink = node.getAttribute('data-submit-link');
  const competitionName = node.getAttribute('data-competition-name');
  const container = document.createElement('div');
  container.id = 'draft-details-container';

  ReactDOM.render(
    <DraftViewer
      draftId={draftId}
      teamId={teamId}
      currentPick={currentPick}
      currentPickId={currentPickId}
      myPicks={myPicks}
      draftType={draftType}
      pickType={pickType}
      draftSubmitLink={draftSubmitLink}
      competitionName={competitionName}
    />,
    document.getElementById('draft-details-container').appendChild(container),
  )
})
