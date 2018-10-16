import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';
import starGold from '../../assets/images/star-gold.svg';
import minus from '../../assets/images/minus-circle.svg';

class DraftInstructions extends React.Component {
  constructor(props) {
    super(props);
  }

  toggleInstructions() {
    $('.available-players-instructions').toggle()
  }

  render() {
    if (this.props.draftType === 'special') {
      return (
        <div>
          <div className="available-players-title">
            <h4>
              Available Players
            </h4>
            <button
              onClick={this.toggleInstructions}
              className="btn btn-sm btn-primary"
              >
                ?
              </button>
            </div>
            <div className="available-players-instructions">
              <p>
                Below are the players and Battle Decks that are still available to draft.
              </p>
              <p>
                Each player can be drafted one time per format. The Chalice has three formats: Guilds of Ravnica draft, Battle Decks, and Block Party.
              </p>
              <p>
                You must draft 4 players and 2 Battle Decks to form a team.
              </p>
              <p>
                Click on a player's name to view more information about them.
              </p>
              <p>
                Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
              </p>
              <p onClick={this.toggleInstructions} className="hide-available-players-instructions btn btn-sm btn-dark">
                Hide
              </p>
            </div>
          </div>
        );
    } else {
      return (
        <div>
          <div className="available-players-title">
            <h4>
              Available Players
            </h4>
            <button
              onClick={this.toggleInstructions}
              className="btn btn-sm btn-primary"
              >
                ?
              </button>
            </div>
            <div className="available-players-instructions">
              <p>
                Below are the players that are still available to draft.
              </p>
              <p>
                The "Points" column is the player's total Pro Points earned during the past four Cycles (usually the last 10-12 months.)
              </p>
              <p>
                The "ELO" column lists the player's ELO rating, which is a scoring system where every player starts with a rating of 1500. After each match, the winning player takes points from the losing player. The amount of points at stake is determined by the difference in the players' ratings.
              </p>
              <p>
                You can sort each column by clicking on it. You can also add secondary  sorting by choosing the main column you'd like sort by, then holding the SHIFT key and selecting the column you'd like to use as a secondary sort.
              </p>
              <p>
                Click on a player's name to view more information about them.
              </p>
              <p>
                Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
              </p>
              <p onClick={this.toggleInstructions} className="hide-available-players-instructions btn btn-sm btn-dark">
                Hide
              </p>
            </div>
          </div>
        );
    }
  }
}

export default DraftInstructions;
