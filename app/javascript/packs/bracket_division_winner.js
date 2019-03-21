import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketPlayer from './bracket_player'
import BracketSpacer from './bracket_spacer'

class BracketDivisionWinner extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let winnerName = null;
    if (this.props.previousMatch && (this.props.previousMatch.winner_id === this.props.previousMatch.player_a_id)) {
      winnerName = this.props.previousMatch.player_a_name
    } else if (this.props.previousMatch && (this.props.previousMatch.winner_id === this.props.previousMatch.player_b_id)) {
      winnerName = this.props.previousMatch.player_b_name
    }
    return (
      <div className={`round round-${this.props.round} ${this.props.bracketSide}`}>
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerId={this.props.previousMatch ? this.props.previousMatch.winner_id : null}
              playerName={winnerName}
              position={'top'}
              handlePick={this.props.handlePick}
              winnerId={null}
              playerSeed={this.props.previousMatch ? (this.props.previousMatch.player_a_id === this.props.previousMatch.winner_id ? this.props.previousMatch.player_a_seed : this.props.previousMatch.player_b_seed) : null}
              matchId={this.props.nextMatch ? this.props.nextMatch.id : null}
              handlePick={this.props.handlePick}
            />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
      </div>
    )
  }
}

export default BracketDivisionWinner;
