import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketPlayerInfo from './bracket_player_info'

class BracketPlayer extends React.Component {
  constructor(props) {
    super(props);

    this.onPick = this.onPick.bind(this);
  }

  onPick(e, matchId, winnerId, winnerName) {
    e.preventDefault();
    this.props.handlePick(matchId, winnerId, winnerName);
  }

  render() {
    return (
        <div
          className={
            `game game-${this.props.position}
            ${this.props.winnerId === this.props.playerId ? 'winner' : null}
            ${this.props.playerId === null ? 'blank' : null}`
          }
          onClick={(e) => {this.onPick(e, this.props.matchId, this.props.playerId, this.props.playerName)}}
        >
          {this.props.playerSeed ? `(${this.props.playerSeed})` : null} {this.props.playerName ? this.props.playerName : 'Winner' } <span></span>
          { this.props.playerId && this.props.roundNumber == 1 &&
            <img src={this.props.playerImageUrl} />
          }
        </div>
    )
  }
}

export default BracketPlayer;
