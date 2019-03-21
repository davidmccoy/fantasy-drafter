import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

class BracketPlayerInfo extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <span
        className={'info'}
        onClick={(e) => {
          e.preventDefault()
          e.stopPropagation()
        }}
      >
        ?
      </span>
    )
  }
}

export default BracketPlayerInfo;
