import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketRound from "./bracket_round";
import BracketDivisionWinner from "./bracket_division_winner";
import BracketWinner from "./bracket_winner";
import InvitationalWinnersBracketTopTwo from "./invitational_winners_bracket_top_two"

class Bracket extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div id="brackets">
        { this.props.competitionName && this.props.competitionName === 'Spark Madness' &&
          <React.Fragment>
          <div className="bracket">
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == '1'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == '1'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == '1'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match =>(match.round === 4) && (match.group == '1'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'true'}
            />
            <BracketDivisionWinner
              roundNumber={5}
              previousMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '1'))[0]}
              nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'true'}
            />
            <BracketWinner
              match={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              seeded={'true'}
            />
            <BracketDivisionWinner
              roundNumber={5}
              previousMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '2'))[0]}
              nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '2'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == '2'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match =>(match.round === 2) && (match.group == '2'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'true'}
            />
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == '2'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'true'}
            />
          </div>
          </React.Fragment>
        }
        { this.props.competitionName && this.props.competitionName == 'Mythic Invitational' &&
          <React.Fragment>
          <div className="col">
            <h1>Group A</h1>
            <h3>Winner's Bracket <span style={{float: 'right'}}>Loser's Bracket</span></h3>
          </div>
          <div className="bracket winners">
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == 'A') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'A') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'A') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <InvitationalWinnersBracketTopTwo
              roundNumber={4}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'A') && (match.bracket_section === 'winners'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <div className={'round'}>
              <strong>Top 4 advance to Saturday</strong>
            </div>

            <InvitationalWinnersBracketTopTwo
              roundNumber={6}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'A') && (match.bracket_section === 'losers'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={5}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'A') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == 'A') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'A') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'A') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
          </div>

          <div className="col">
            <h1>Group B</h1>
            <h3>Winner's Bracket <span style={{float: 'right'}}>Loser's Bracket</span></h3>
          </div>
          <div className="bracket winners">
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == 'B') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'B') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'B') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <InvitationalWinnersBracketTopTwo
              roundNumber={4}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'B') && (match.bracket_section === 'winners'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <div className={'round'}>
              <strong>Top 4 advance to Saturday</strong>
            </div>

            <InvitationalWinnersBracketTopTwo
              roundNumber={6}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'B') && (match.bracket_section === 'losers'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={5}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'B') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == 'B') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'B') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'B') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
          </div>

          <div className="col">
            <h1>Group C</h1>
            <h3>Winner's Bracket <span style={{float: 'right'}}>Loser's Bracket</span></h3>
          </div>
          <div className="bracket winners">
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == 'C') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'C') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'C') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <InvitationalWinnersBracketTopTwo
              roundNumber={4}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'C') && (match.bracket_section === 'winners'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <div className={'round'}>
              <strong>Top 4 advance to Saturday</strong>
            </div>

            <InvitationalWinnersBracketTopTwo
              roundNumber={6}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'C') && (match.bracket_section === 'losers'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={5}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'C') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == 'C') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'C') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'C') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
          </div>

          <div className="col">
            <h1>Group D</h1>
            <h3>Winner's Bracket <span style={{float: 'right'}}>Loser's Bracket</span></h3>
          </div>
          <div className="bracket winners">
            <BracketRound
              roundNumber={1}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == 'D') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'D') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'D') && (match.bracket_section === 'winners'))}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <InvitationalWinnersBracketTopTwo
              roundNumber={4}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'D') && (match.bracket_section === 'winners'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'left'}
              seeded={'false'}
              bracketSection={'winners'}
            />
            <div className={'round'}>
              <strong>Top 4 advance to Saturday</strong>
            </div>

            <InvitationalWinnersBracketTopTwo
              roundNumber={6}
              previousMatches={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'D') && (match.bracket_section === 'losers'))}
              // nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={5}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 5) && (match.group == 'D') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={4}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == 'D') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={3}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == 'D') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
            <BracketRound
              roundNumber={2}
              matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == 'D') && (match.bracket_section === 'losers'))}
              handlePick={this.props.handlePick}
              bracketSide={'right'}
              seeded={'false'}
              bracketSection={'losers'}
            />
          </div>
          </React.Fragment>
        }
      </div>
    )
  }
}

export default Bracket;
