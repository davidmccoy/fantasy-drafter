import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import TeamList from './team_list';

class DraftViewerLeftPanel extends React.Component {
  constructor(props) {
    super(props);
  }

  toggleInstructions() {
    $('.available-players-instructions').toggle()
  }

  render() {
    return (
      <div>
        <ul className="nav nav-tabs" id="myTab" role="tablist">
          <li className="nav-item">
            <a className="nav-link active" id="my-team-tab" data-toggle="tab" href="#my-team" role="tab" aria-controls="my-team" aria-selected="true">My Team</a>
          </li>
          <li className="nav-item">
            <a className="nav-link" id="league-tab" data-toggle="tab" href="#league" role="tab" aria-controls="league" aria-selected="false">Other Teams</a>
          </li>
        </ul>
        <div className="tab-content" id="myTabContent">
          <div className="tab-pane fade show active" id="my-team" role="tabpanel" aria-labelledby="my-team-tab">
            <TeamList team={this.props.myTeam} />
          </div>
          <div className="tab-pane fade" id="league" role="tabpanel" aria-labelledby="league-tab">
            { this.props.otherTeams !== undefined  &&
              this.props.otherTeams.map((team) =>
              <TeamList team={team} key={team.name}/>
              )
            }
          </div>
        </div>
      </div>
    );
  }
}

export default DraftViewerLeftPanel;
