import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';
import starGold from '../../assets/images/star-gold.svg';
import minus from '../../assets/images/minus-circle.svg';

class DraftInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      rounds: "",
      competition_name: ""
    }
  }

  componentDidMount() {
    $.ajax({
      url: `/api/drafts/${this.props.draftId}`,
      dataType: 'json',
      success: function(data){
        this.setState({
          rounds: data.draft.rounds,
          competition_name: data.draft.competition_name,
          competition_date: new Date(data.draft.competition_date).toDateString()
        })
      }.bind(this)
    });
  }

  render() {
    return (
      <div>
        <div>
          <h4>
            Draft Info
          </h4>
          <p>
            <strong>Draft Rounds:</strong> {this.state.rounds}
          </p>
          <p>
            <strong>Competition:</strong> {this.state.competition_name}
          </p>
          <p>
            <strong>Competition Date:</strong> {this.state.competition_date}
          </p>
        </div>
        <div>
          <h4>How It Works</h4>
          <h5>Drafting</h5>
          <p>
            During the draft, the players that are still available to draft are in listed in the "Available Players" table. Currently, these are restricted to players that are (or have been) on a Pro Tour team in the Pro Tour Team Series.
          </p>
          <p>
            The "Points" column represents the average number of Match Points a player has earned per Pro Tour since the Team Series started. The "PT" column lists the number of Pro Tours each player has attended since the start of the Team Series.
          </p>
          <p>
            You can sort each column by clicking on it. You can also add secondary sorting by choosing the main column you'd like sort by, then holding the SHIFT key and selecting the column you'd like to use as a secondary sort.
          </p>
          <p>
            Click the <button className="btn btn-sm star-link"><img src={starGold} className="star-gold-image"/><img src={star} className="star-image" /></button> to save a list of your favorite players to pick when it's your turn. Click the <button className="btn btn-sm btn-success pick-link"><img src={plus} /></button> to draft a player and add them to your team.
          </p>
          <h5>Scoring</h5>
          <p>
            Once you've drafted your team, your players will earn 3 points for every match win, 1 point for every draw, and 0 points for every loss. Players that make the Top 8 of this event will receive 3 bonus points, plus 3 more points for every match they win in the Top 8. The team with the most points wins the league.
          </p>
        </div>
      </div>
    );
  }
}

export default DraftInfo;
