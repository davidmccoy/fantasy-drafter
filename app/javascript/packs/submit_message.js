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
            <div>Add more {this.props.pickType}s before you submit your team!<button className="btn btn-dark" disabled>SUBMIT</button></div>
        }
        { (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.name !== null).length === this.props.myPicks.length)) &&
            <div>
              Your team is complete! Submit your roster to enter the tournament!
              <form action={this.props.draftSubmitLink} method="post" acceptCharset="UTF-8">
                <input name="utf8" type="hidden" value="✓" />
                <input type="submit" value="SUBMIT" className="btn btn-success" />
                <input type="hidden" name="authenticity_token" value={$('meta[name=csrf-token]').attr("content")} />
              </form>
            </div>

        }
      </div>
    );
  }
}

export default SubmitMessage;
