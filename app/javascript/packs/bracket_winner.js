import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketPlayer from './bracket_player'
import BracketSpacer from './bracket_spacer'

class BracketWinner extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let winnerName = null;
    if (this.props.match && (this.props.match.winner_id === this.props.match.player_a_id)) {
      winnerName = this.props.match.player_a_name
    } else if (this.props.match && (this.props.match.winner_id === this.props.match.player_b_id)) {
      winnerName = this.props.match.player_b_name
    }
    return (
      <div className={"round bracket-winner"}>
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerId={this.props.match ? this.props.match.winner_id : null}
              playerName={winnerName}
              position={'top'}
              handlePick={this.props.handlePick}
              winnerId={this.props.match ? this.props.match.winner_id : null}
            />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
      </div>
    )
  }
}

export default BracketWinner;
