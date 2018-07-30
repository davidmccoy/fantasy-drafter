import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import AvailablePlayersTable from "./available_players_table";
import DraftInstructions from "./draft_instructions";
import DraftViewerLeftPanel from "./draft_viewer_left_panel";

class DraftViewer extends React.Component {
  constructor() {
    super();
    this.state = {
      data: [],
      loading: true,
      myStars: []
    };

    this.fetchData = this.fetchData.bind(this);
    this.fetchPlayers = this.fetchPlayers.bind(this);
    this.fetchTeams = this.fetchTeams.bind(this);
    this.componentDidMount = this.componentDidMount.bind(this);
    this.updateTableData = this.updateTableData.bind(this);
    this.starPlayer = this.starPlayer.bind(this);
    this.pickPlayer = this.pickPlayer.bind(this);
  }

  componentDidMount() {
    this.setState({
      currentPick: this.props.currentPick,
      currentPickId: this.props.currentPickId
    })
    this.fetchData();
    this.setupSubscription();
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
    let pickUrl = url.replace('pick-number', this.state.currentPickId)
    $.ajax({
      url: pickUrl,
      method: 'PUT',
      dataType: 'json',
      success: function(data){

      }.bind(this)
    });
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
              myStars: this.state.myStars.filter(e => e.player_id !== data.player_id),
              data: this.state.data.filter(e => e.player_id !== data.player_id)
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
        <div id="players" className="col-md-6">
          <DraftInstructions />
          <AvailablePlayersTable
            data={this.state.data}
            loading={this.state.loading}
            handleStar={this.starPlayer}
            myPicks={this.props.myPicks}
            myStars={this.state.myStars}
          />
        </div>
        <div id="left-tabbed-panel" className="col-md-6">
          <DraftViewerLeftPanel
            otherTeams={this.state.otherTeams}
            myTeam={this.state.myTeam}
            myStars={this.state.myStars}
            currentPick={this.state.currentPick}
            myPicks={this.props.myPicks}
            handleStar={this.starPlayer}
            handlePick={this.pickPlayer}
            draftId={this.props.draftId}
          />
        </div>
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
  const container = document.createElement('div');
  container.id = 'draft-details-container';

  ReactDOM.render(
    <DraftViewer
      draftId={draftId}
      teamId={teamId}
      currentPick={currentPick}
      currentPickId={currentPickId}
      myPicks={myPicks}
    />,
    document.getElementById('draft-details-container').appendChild(container),
  )
})
