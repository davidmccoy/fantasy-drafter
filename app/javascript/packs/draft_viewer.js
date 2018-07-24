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
      teams: []
    };

    this.fetchData = this.fetchData.bind(this);
    this.fetchPlayers = this.fetchPlayers.bind(this);
    this.fetchTeams = this.fetchTeams.bind(this);
    this.componentDidMount = this.componentDidMount.bind(this);
    this.updateTableData = this.updateTableData.bind(this);
  }

  componentDidMount() {
    this.fetchData();
    this.setupSubscription();
  }

  updateTableData() {
    this.fetchData();
  }

  fetchData() {
    this.fetchPlayers();
    this.fetchTeams();
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
            this.fetchData();
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
          />
        </div>
        <div id="left-tabbed-panel" className="col-md-6">
          <DraftViewerLeftPanel
            otherTeams={this.state.otherTeams}
            myTeam={this.state.myTeam}
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
  const container = document.createElement('div');
  container.id = 'draft-details-container';

  ReactDOM.render(
    <DraftViewer draftId={draftId} teamId={teamId} />,
    document.getElementById('draft-details-container').appendChild(container),
  )
})
