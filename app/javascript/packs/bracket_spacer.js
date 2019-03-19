import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

class BracketSpacer extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className={this.props.isGameSpacer ? "game game-spacer" : "spacer"}>&nbsp;</div>
    )
  }
}

export default BracketSpacer;
