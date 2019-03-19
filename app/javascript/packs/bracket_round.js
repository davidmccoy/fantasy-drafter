import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketPlayer from './bracket_player'
import BracketSpacer from './bracket_spacer'

class BracketRound extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className={`round round-${this.props.roundNumber} ${this.props.bracketSide}`}>
        { this.props.matches.map((match, key) =>
          <React.Fragment key={key}>
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerName={match.player_a_name}
              playerId={match.player_a_id}
              playerSeed={match.player_a_seed}
              position={'top'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
            />
            <BracketSpacer isGameSpacer={true} />
            <BracketPlayer
              playerName={match.player_b_name}
              playerId={match.player_b_id}
              playerSeed={match.player_b_seed}
              position={'bottom'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
            />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
        )}
      </div>
    )
  }
}

export default BracketRound;
