import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketPlayer from './bracket_player'
import BracketSpacer from './bracket_spacer'

class InvitationalWinnersBracketTopTwo extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let topWinnerName = null;
    let bottomWinnerName = null;
    if (this.props.previousMatches && this.props.previousMatches.length && (this.props.previousMatches[0].winner_id === this.props.previousMatches[0].player_a_id)) {
      topWinnerName = this.props.previousMatches[0].player_a_name
    } else if (this.props.previousMatches && (this.props.previousMatches[0].winner_id === this.props.previousMatches[0].player_b_id)) {
      topWinnerName = this.props.previousMatches[0].player_b_name
    }
    if (this.props.previousMatches && this.props.previousMatches.length && (this.props.previousMatches[1].winner_id === this.props.previousMatches[1].player_a_id)) {
      bottomWinnerName = this.props.previousMatches[1].player_a_name
    } else if (this.props.previousMatches && (this.props.previousMatches[1].winner_id === this.props.previousMatches[1].player_b_id)) {
      bottomWinnerName = this.props.previousMatches[1].player_b_name
    }
    return (
      <div className={`round round-${this.props.roundNumber} ${this.props.bracketSide}`}>
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerId={this.props.previousMatches ? this.props.previousMatches[0].winner_id : null}
              playerName={topWinnerName}
              position={'top'}
              handlePick={this.props.handlePick}
              winnerId={this.props.previousMatches ? this.props.previousMatches[0].winner_id : null}
              playerSeed={
                this.props.seeded && this.props.seeded === 'false' ? null :
                (this.props.previousMatches ? (this.props.previousMatches[0].player_a_id === this.props.previousMatches[0].winner_id ? this.props.previousMatches[0].player_a_seed : this.props.previousMatches[0].player_b_seed) : null)
              }
              matchId={this.props.nextMatch ? this.props.nextMatch.id : null}
              handlePick={this.props.handlePick}
            />
            <BracketSpacer isGameSpacer={false} />
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerId={this.props.previousMatches ? this.props.previousMatches[1].winner_id : null}
              playerName={bottomWinnerName}
              position={'top'}
              handlePick={this.props.handlePick}
              winnerId={this.props.previousMatches ? this.props.previousMatches[1].winner_id : null}
              playerSeed={
                this.props.seeded && this.props.seeded === 'false' ? null :
                (this.props.previousMatches ? (this.props.previousMatches[1].player_a_id === this.props.previousMatches[1].winner_id ? this.props.previousMatches[1].player_a_seed : this.props.previousMatches[1].player_b_seed) : null)
              }
              matchId={this.props.nextMatch ? this.props.nextMatch.id : null}
              handlePick={this.props.handlePick}
            />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
      </div>
    )
  }
}

export default InvitationalWinnersBracketTopTwo;
