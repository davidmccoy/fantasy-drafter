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
            Below are the players that are still available to draft. Currently, these are restricted to players that are (or have been) on a Pro Tour team in the Pro Tour Team Series.
          </p>
          <p>
            The "Points" column represents the average number of Match Points a player has earned per Pro Tour since the Team Series started. The "PT" column lists the number of Pro Tours each player has attended since the start of the Team Series.
          </p>
          <p>
            You can sort each column by clicking on it. You can also add secondary  sorting by choosing the main column you'd like sort by, then holding the SHIFT key and selecting the column you'd like to use as a secondary sort.
          </p>
          <p>
            Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
          </p>
          <p onClick={this.toggleInstructions}>
            <em>(Hide)</em>
          </p>
        </div>
      </div>
    );
  }
}

export default DraftInstructions;
