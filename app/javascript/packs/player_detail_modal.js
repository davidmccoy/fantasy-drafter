import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import { Modal } from 'react-bootstrap';
import { Button } from 'react-bootstrap';
import MplLogo from '../../assets/images/mpl-logo.png';
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
        // size="lg"
        // aria-labelledby="contained-modal-title-vcenter"
        // centered
        >
          <Modal.Header closeButton>
            <Modal.Title>
              {(this.props.player === undefined || this.props.player === null) ? "Your favorite player" : this.props.player.name}
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            { this.props.pickType === 'player' && (this.props.player && this.props.player.bio) &&
              <div className="row">
                <div className="modal-player-image-container col-md">
                  <img className="player-image" src={(this.props.player === undefined || this.props.player === null) ? "Loading..." : this.props.player.image_url} />
                  { (this.props.player && this.props.player.league === 'MPL') &&
                    <img className="mpl-logo" src={MplLogo} />
                  }
                </div>
                <div className="modal-player-bio-container col-md">
                  <ReactMarkdown
                    source={(this.props.player === undefined || this.props.player === null) ? "Loading player..." : (this.props.player.bio === null? "This player currently has not biographical information." : this.props.player.bio)}
                  />
                  <div>
                    <em><a href="https://www.mtgesports.com/">Image source</a> and <a href={this.props.player.bio_source}>bio source</a>.</em>
                  </div>
                </div>
              </div>
            }
            { this.props.pickType === 'player' && (this.props.player && !this.props.player.bio) &&
              <ReactMarkdown
                source={(this.props.player === undefined || this.props.player === null) ? "Loading player..." : (this.props.player.bio === null? "This player currently has not biographical information." : this.props.player.bio)}
              />
            }
            { this.props.pickType === 'card' &&
              <div className="modal-card-image-container">
                <img src={(this.props.player === undefined || this.props.player === null) ? "Loading..." : this.props.player.image_url} className="modal-card-image"/>
              </div>
            }
          </Modal.Body>
          <Modal.Footer>
            <Button className="btn btn-light" onClick={this.props.onHide}>Close</Button>
          </Modal.Footer>
        </Modal>
    );
  }
}

export default PlayerDetailModal;
