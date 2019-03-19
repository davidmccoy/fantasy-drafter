import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import BracketRound from "./bracket_round";
import BracketDivisionWinner from "./bracket_division_winner";
import BracketWinner from "./bracket_winner";

class Bracket extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div id="bracket">
        <BracketRound
          roundNumber={1}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == '1'))}
          handlePick={this.props.handlePick}
          bracketSide={'left'}
        />
        <BracketRound
          roundNumber={2}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 2) && (match.group == '1'))}
          handlePick={this.props.handlePick}
          bracketSide={'left'}
        />
        <BracketRound
          roundNumber={3}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == '1'))}
          handlePick={this.props.handlePick}
          bracketSide={'left'}
        />
        <BracketRound
          roundNumber={4}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match =>(match.round === 4) && (match.group == '1'))}
          handlePick={this.props.handlePick}
          bracketSide={'left'}
        />
        <BracketDivisionWinner
          roundNumber={5}
          previousMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '1'))[0]}
          nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
          handlePick={this.props.handlePick}
          bracketSide={'left'}
        />
        <BracketWinner
          match={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
          handlePick={this.props.handlePick}
        />
        <BracketDivisionWinner
          roundNumber={5}
          previousMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '2'))[0]}
          nextMatch={this.props.myTeam === undefined ? null : this.props.myTeam.players.filter(match => match.round === 5)[0]}
          handlePick={this.props.handlePick}
          bracketSide={'right'}
        />
        <BracketRound
          roundNumber={4}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 4) && (match.group == '2'))}
          handlePick={this.props.handlePick}
          bracketSide={'right'}
        />
        <BracketRound
          roundNumber={3}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 3) && (match.group == '2'))}
          handlePick={this.props.handlePick}
          bracketSide={'right'}
        />
        <BracketRound
          roundNumber={2}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match =>(match.round === 2) && (match.group == '2'))}
          handlePick={this.props.handlePick}
          bracketSide={'right'}
        />
        <BracketRound
          roundNumber={1}
          matches={this.props.myTeam === undefined ? [] : this.props.myTeam.players.filter(match => (match.round === 1) && (match.group == '2'))}
          handlePick={this.props.handlePick}
          bracketSide={'right'}
        />
      </div>
    )
  }
}

export default Bracket;
