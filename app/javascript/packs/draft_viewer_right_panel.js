import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import TeamList from './team_list';
import StarList from './star_list';
import DraftInfo from './draft_info'

class DraftViewerRightPanel extends React.Component {
  constructor(props) {
    super(props);
  }

  toggleInstructions() {
    $('.available-players-instructions').toggle()
  }

  render() {
    return (
      <div>
        { this.props.draftType !== 'pick_em' &&
          <ul className="nav nav-tabs" id="myTab" role="tablist">
            <li className="nav-item">
              <a className="nav-link active" id="my-team-tab" data-toggle="tab" href="#my-team" role="tab" aria-controls="my-team" aria-selected="true">My Team</a>
            </li>
            { this.props.draftType === 'snake' &&
              <li className="nav-item">
                <a className="nav-link" id="other_teams-tab" data-toggle="tab" href="#other_teams" role="tab" aria-controls="other_teams" aria-selected="false">Other Teams</a>
              </li>
            }
            <li className="nav-item">
              <a className="nav-link" id="league-tab" data-toggle="tab" href="#league" role="tab" aria-controls="league" aria-selected="false">Draft Info</a>
            </li>
          </ul>
        }
        { this.props.draftType !== 'pick_em' &&
          <div className="tab-content" id="myTabContent">
            <div className="tab-pane fade show active" id="my-team" role="tabpanel" aria-labelledby="my-team-tab">
              <TeamList
                team={this.props.myTeam}
                currentPick={this.props.currentPick}
                myPicks={this.props.myPicks}
                draftType={this.props.draftType}
                handleRemovePlayer={this.props.handleRemovePlayer}
                pickType={this.props.pickType}
              />
              <StarList
                data={this.props.myStars}
                currentPick={this.props.currentPick}
                myPicks={this.props.myPicks}
                myTeam={this.props.myTeam}
                handlePick={this.props.handlePick}
                handleStar={this.props.handleStar}
                draftType={this.props.draftType}
                pickType={this.props.pickType}
                allPlayers={this.props.allPlayers}
              />
            </div>
            { this.props.draftType === 'snake' &&
              <div className="tab-pane fade" id="other_teams" role="tabpanel" aria-labelledby="other_teams-tab">
                { this.props.otherTeams !== undefined  &&
                  this.props.otherTeams.map((team) =>
                  <TeamList
                    team={team}
                    key={team.name}
                    pickType={this.props.pickType}
                  />
                )
              }
            </div>
            }
            <div className="tab-pane fade" id="league" role="tabpanel" aria-labelledby="league-tab">
              <DraftInfo
                draftId={this.props.draftId}
                draftType={this.props.draftType}
                pickType={this.props.pickType}
              />
            </div>
          </div>
        }
        { this.props.draftType === 'pick_em' &&
          <div>
            <h3>Pick 'Em Information</h3>
            <p>
              Welcome to your pick 'em tournament for <strong>{this.props.competitionName}!</strong>
            </p>
            <p>
              Pick 'Em is a quick way to enter a 1KL fantasy league. Rather than drafting individual players or cards, you pick the winner for each match in {this.props.competitionName}.
            </p>
            <p>
              Once you've picked your winners, you will receive 3 point for every match you picked correctly and 1 point for a tie. The player receives the most points from picking matches correctly wins the tournament. (Ties are broken in favor of the player who submitted their picks first.)
            </p>
          </div>
        }
      </div>
    );
  }
}

export default DraftViewerRightPanel;
