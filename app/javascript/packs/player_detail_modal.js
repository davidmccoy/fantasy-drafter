import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import { Modal } from 'react-bootstrap';
import { Button } from 'react-bootstrap';
const ReactMarkdown = require('react-markdown')

class PlayerDetailModal extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <Modal
        {...this.props}
        bsSize="large"
        dialogClassName="modal-dialog-centered"
        aria-labelledby="contained-modal-title-lg"
        >
          <Modal.Header closeButton>
            <Modal.Title> {(this.props.player === undefined || this.props.player === null) ? "Your favorite player" : this.props.player.name}</Modal.Title>
          </Modal.Header>
          <Modal.Body>
            <ReactMarkdown
              source={(this.props.player === undefined || this.props.player === null) ? "Loading player..." : (this.props.player.bio === null? "This player currently has not biographical information." : this.props.player.bio)}
            />
          </Modal.Body>
          <Modal.Footer>
            <Button className="btn btn-dark" onClick={this.props.onHide}>Close</Button>
          </Modal.Footer>
        </Modal>
    );
  }
}

export default PlayerDetailModal;
