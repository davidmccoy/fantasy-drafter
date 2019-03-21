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
              playerBio={match.player_a_bio}
              playerImageUrl={match.player_a_image_url}
              playerId={match.player_a_id}
              playerSeed={match.player_a_seed}
              position={'top'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
              roundNumber={this.props.roundNumber}
            />
            <BracketSpacer isGameSpacer={true} />
            <BracketPlayer
              playerName={match.player_b_name}
              playerBio={match.player_b_bio}
              playerImageUrl={match.player_b_image_url}
              playerId={match.player_b_id}
              playerSeed={match.player_b_seed}
              position={'bottom'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
              roundNumber={this.props.roundNumber}
            />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
        )}
      </div>
    )
  }
}

export default BracketRound;
