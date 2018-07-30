import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

class TeamList extends React.Component {
  constructor(props) {
    super(props);
  }


  render() {
    let players = null;
    if (this.props.team !== undefined) {
      players = this.props.team.players.map(function(player) {
        return <li key={player.name}>
          {player.name}
        </li>
      })
    }
    return (
      <div>
        { this.props.team !== undefined  &&
          <div>
            <h4>{this.props.team.name}</h4>
            <ul>
                {players}
            </ul>
          </div>
        }
      </div>
    );
  }
}

export default TeamList;
