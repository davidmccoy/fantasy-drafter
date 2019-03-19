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

  pickBracketMatch(matchId, winnerId, winnerName) {
    let nextBracketMatchPlayerA = this.state.myTeam.players.filter(e => e.player_a_previous_match_id === matchId)[0]
    let nextBracketMatchPlayerB = this.state.myTeam.players.filter(e => e.player_b_previous_match_id === matchId)[0]
    let pickedMatch = this.state.myTeam.players.filter(e => e.id === matchId)[0]

    let matches = this.state.myTeam.players.map(function(match) {
      if (match.id === parseInt(matchId)) {
        return {
          bracket_position: match.bracket_position,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          round: match.round,
          winner_id: winnerId == '' ? null : winnerId
        }
      } else if (nextBracketMatchPlayerA && match.id === nextBracketMatchPlayerA.id) {
        let pickedMatchWinnerSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_seed : pickedMatch.player_b_seed
        return {
          bracket_position: match.bracket_position,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: winnerId,
          player_a_name: winnerName,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: pickedMatchWinnerSeed,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
          round: match.round,
          winner_id: match.winner_id
        }
      } else if (nextBracketMatchPlayerB && match.id === nextBracketMatchPlayerB.id) {
        let pickedMatchWinnerSeed = winnerId === pickedMatch.player_a_id ? pickedMatch.player_a_seed : pickedMatch.player_b_seed
        return {
          bracket_position: match.bracket_position,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_b_id: winnerId,
          player_b_name: winnerName,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: pickedMatchWinnerSeed,
          round: match.round,
          winner_id: match.winner_id
        }
      } else {
        return {
          bracket_position: match.bracket_position,
          competition_id: match.competition_id,
          group: match.group,
          id: match.id,
          player_a_id: match.player_a_id,
          player_a_name: match.player_a_name,
          player_a_previous_match_id: match.player_a_previous_match_id,
          player_a_seed: match.player_a_seed,
          player_b_id: match.player_b_id,
          player_b_name: match.player_b_name,
          player_b_previous_match_id: match.player_b_previous_match_id,
          player_b_seed: match.player_b_seed,
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
            />
          </div>
        }
        { this.props.draftType === 'bracket' &&
          <div id="left-tabbed-panel" className="col-md-12">
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
