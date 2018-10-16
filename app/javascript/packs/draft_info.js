import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';
import starGold from '../../assets/images/star-gold.svg';
import minus from '../../assets/images/minus-circle.svg';

class DraftInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rounds: "",
      competition_name: ""
    }
  }

  componentDidMount() {
    $.ajax({
      url: `/api/drafts/${this.props.draftId}`,
      dataType: 'json',
      success: function(data){
        this.setState({
          rounds: data.draft.rounds,
          competition_name: data.draft.competition_name,
          competition_date: new Date(data.draft.competition_date).toDateString()
        })
      }.bind(this)
    });
  }

  render() {
    if (this.props.draftType === 'special') {
      return (
        <div>
          <div>
            <h4>
              Draft Info
            </h4>
            { this.props.draftType === 'snake' &&
              <p>
                <strong>Draft Rounds:</strong> {this.state.rounds}
              </p>
            }
            { this.props.draftType !== 'snake' &&
              <p>
                <strong>Players Per Team:</strong> {this.state.rounds}
              </p>
            }
            <p>
              <strong>Competition:</strong> {this.state.competition_name}
            </p>
            <p>
              <strong>Competition Date:</strong> {this.state.competition_date}
            </p>
          </div>
          <div>
            <h4>How It Works</h4>
            <h5>Drafting</h5>
            <p>
              During the draft, the players that are still available to draft are in listed in the "Available Players" table.
            </p>
            <p>
              Each player can be drafted one time per format. The Chalice has three formats: Guilds of Ravnica draft, Battle Decks, and Block Party.
            </p>
            <p>
              You must draft 4 players and 2 Battle Decks to form a team.
            </p>
            <p>
              You can sort each column by clicking on it. You can also add secondary sorting by choosing the main column you'd like sort by, then holding the SHIFT key and selecting the column you'd like to use as a secondary sort.
            </p>
            <p>
              Click on a player's name to view more information about them.
            </p>
            <p>
              Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
            </p>
            <h5>Scoring</h5>
            <p>
              Once you've drafted your team, your players and decks will earn 3 points for every match win, 1 point for every draw, and 0 points for every loss. The team with the most points wins the league.
            </p>
          </div>
        </div>
      );
    } else {
      return (
        <div>
          <div>
            <h4>
              Draft Info
            </h4>
            { this.props.draftType === 'snake' &&
            <p>
              <strong>Draft Rounds:</strong> {this.state.rounds}
            </p>
          }
          { this.props.draftType !== 'snake' &&
          <p>
            <strong>Players Per Team:</strong> {this.state.rounds}
          </p>
        }
        <p>
          <strong>Competition:</strong> {this.state.competition_name}
        </p>
        <p>
          <strong>Competition Date:</strong> {this.state.competition_date}
        </p>
      </div>
      <div>
        <h4>How It Works</h4>
        <h5>Drafting</h5>
        <p>
          During the draft, the players that are still available to draft are in listed in the "Available Players" table.
        </p>
        <p>
          The "Points" column is the player's total Pro Points earned during the past four Cycles (usually the last 10-12 months.)
        </p>
        <p>
          The "ELO" column lists the player's ELO rating, which is a scoring system where every player starts with a rating of 1500. After each match, the winning player takes points from the losing player. The amount of points at stake is determined by the difference in the players' ratings.
        </p>
        <p>
          You can sort each column by clicking on it. You can also add secondary sorting by choosing the main column you'd like sort by, then holding the SHIFT key and selecting the column you'd like to use as a secondary sort.
        </p>
        <p>
          Click on a player's name to view more information about them.
        </p>
        <p>
          Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
        </p>
        <h5>Scoring</h5>
        <p>
          Once you've drafted your team, your players will earn 3 points for every match win, 1 point for every draw, and 0 points for every loss. Players that make the Top 8 of this event will receive 3 bonus points, plus 3 more points for every match they win in the Top 4. The team with the most points wins the league.
        </p>
      </div>
    </div>
  );
    }
  }
}

export default DraftInfo;
