import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

class SubmitMessage extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div>
        { (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.name !== null).length !== this.props.myPicks.length)) &&
            <div>Add more players before you submit your team!<button className="btn btn-dark" disabled>SUBMIT</button></div>
        }
        { (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.name !== null).length === this.props.myPicks.length)) &&
            <div>Your team is complete! Submit your roster to enter the tournament!<button className="btn btn-success">SUBMIT</button></div>
        }
      </div>
    );
  }
}

export default SubmitMessage;
