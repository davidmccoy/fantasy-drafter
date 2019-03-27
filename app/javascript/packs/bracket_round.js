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
      <div className={`round round-${this.props.roundNumber} ${this.props.bracketSide} ${this.props.bracketSection}`}>
        { (this.props.bracketSection && this.props.bracketSection === 'losers') && (this.props.roundNumber && this.props.roundNumber === 2) &&
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
        }
        { this.props.matches.map((match, key) =>
          <React.Fragment key={key}>
            <BracketSpacer isGameSpacer={false} />
            <BracketPlayer
              playerName={match.player_a_name}
              playerBio={match.player_a_bio}
              playerImageUrl={match.player_a_image_url}
              playerId={match.player_a_id}
              playerSeed={this.props.seeded && this.props.seeded === 'true' ? match.player_a_seed : null}
              position={'top'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
              roundNumber={this.props.roundNumber}
              bracketSection={this.props.bracketSection}
            />
            <BracketSpacer isGameSpacer={true} />
            <BracketPlayer
              playerName={match.player_b_name}
              playerBio={match.player_b_bio}
              playerImageUrl={match.player_b_image_url}
              playerId={match.player_b_id}
              playerSeed={this.props.seeded && this.props.seeded === 'true' ? match.player_b_seed : null}
              position={'bottom'}
              winnerId={match.winner_id}
              matchId={match.id}
              handlePick={this.props.handlePick}
              roundNumber={this.props.roundNumber}
              bracketSection={this.props.bracketSection}
            />
            <BracketSpacer isGameSpacer={false} />
            { (this.props.bracketSection && this.props.bracketSection === 'losers') && (this.props.roundNumber && this.props.roundNumber === 5) &&
              <React.Fragment>
                <BracketSpacer isGameSpacer={false} />
                <BracketSpacer isGameSpacer={false} />
              </React.Fragment>
            }
          </React.Fragment>
        )}
        { (this.props.bracketSection && this.props.bracketSection === 'losers') && (this.props.roundNumber && this.props.roundNumber === 3) &&
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
        }
        { (this.props.bracketSection && this.props.bracketSection === 'losers') && (this.props.roundNumber && this.props.roundNumber === 5) &&
          <React.Fragment>
            <BracketSpacer isGameSpacer={false} />
            <BracketSpacer isGameSpacer={false} />
          </React.Fragment>
        }
      </div>
    )
  }
}

export default BracketRound;
