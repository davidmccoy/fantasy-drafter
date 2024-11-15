import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

import PlayerDetailModal from './player_detail_modal';

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';
import minus from '../../assets/images/minus-circle.svg';

class StarList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      numStars: 5
    }
    this.onStar = this.onStar.bind(this);
    this.displayPickLink = this.displayPickLink.bind(this);
    this.onPick = this.onPick.bind(this);
    this.changeModalPlayer = this.changeModalPlayer.bind(this);
    this.hideModal = this.hideModal.bind(this);
  }

  componentWillReceiveProps() {
    this.forceUpdate()
  }

  onStar(e, url) {
    e.preventDefault();
    this.props.handleStar(url, 'DELETE');
  }

  onPick(e, url) {
    e.preventDefault();
    this.props.handlePick(url);
  }

  displayPickLink() {
    if (this.props.draftType === 'snake') {
      return this.props.myPicks.some(item => this.props.currentPick === item)
    } else if (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.name !== null).length === this.props.myPicks.length)) {
      return false
    } else {
      return true
    }
  }

  displaySpecialPickLink(playerType) {
    if (playerType === "Player") {
      if (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.player_type === "Player").length === 4)) {
        return false
      } else {
        return true
      }
    } else if (playerType === "Deck") {
      if (this.props.myTeam !== undefined && (this.props.myTeam.players.filter(e => e.player_type === "Deck").length === 2)) {
        return false
      } else {
        return true
      }
    }
  }

  changeModalPlayer(e, playerId) {
    let player = this.props.allPlayers.filter( e => e.player_id === playerId)[0]
    this.setState({
      player: player,
      showModal: true
    })
  }

  hideModal() {
    this.setState({
      showModal: false
    })
  }

  render() {
    let columns = []
    if (this.props.draftType == 'pick_em') {
      return (
        <div>

        </div>
      )
    } else if (this.props.draftType !== 'special') {
      if (this.props.pickType === 'player') {
        columns = [
          {
            columns: [
              {
                Header: "Star",
                accessor: "star_link",
                maxWidth: 54,
                sortable: false,
                Cell: row => (
                  <button
                    // href={row.value}
                    className="btn btn-sm star-link remove-star already-starred"
                    // data-remote="true"
                    rel="nofollow"
                    onClick={(e) => {this.onStar(e, row.value)}}
                    style={{display: row.value === undefined ? "none" : null}}
                  ><img src={star} className="star-image" /><img src={minus} className="minus-image" /></button>
                )
              },
              {
                Header: "Group",
                accessor: "group",
                maxWidth: 50,
                sortable: false,
                sortMethod: (a, b) => {
                  if(a === null){
                    return 1;
                  }
                  else if(b === null){
                    return -1;
                  }
                  else if(a === b){
                    return 0;
                  }
                  return a > b ? 1 : -1;
                }
              },
              {
                Header: "ELO",
                accessor: "elo",
                sortable: false,
                maxWidth: 55
              },
              {
                Header: "Name",
                accessor: "name",
                sortable: false,
                Cell: row => (
                  <span
                    onClick={(e) => {this.changeModalPlayer(e, row.original.player_id)}}
                  >{row.value}</span>
                )
              },
              {
                Header: "Pick",
                accessor: "pick_link",
                maxWidth: 52,
                sortable: false,
                Cell: row => (
                  <button
                    // href={row.value}
                    className="btn btn-sm btn-success pick-link"
                    // data-remote="true"
                    rel="nofollow"
                    data-method="patch"
                    onClick={(e) => {this.onPick(e, row.value)}}
                    style={{display: this.displayPickLink() === false  ? "none" : null}}
                  ><img src={plus} /></button>
                )
              }
            ]
          }
        ]
      } else if (this.props.pickType === 'card') {
        columns = [
          {
            columns: [
              {
                Header: "Star",
                accessor: "star_link",
                maxWidth: 54,
                sortable: false,
                Cell: row => (
                  <button
                    // href={row.value}
                    className="btn btn-sm star-link remove-star already-starred"
                    // data-remote="true"
                    rel="nofollow"
                    onClick={(e) => {this.onStar(e, row.value)}}
                    style={{display: row.value === undefined ? "none" : null}}
                  ><img src={star} className="star-image" /><img src={minus} className="minus-image" /></button>
                )
              },
              {
                Header: "xRank",
                accessor: "xrank",
                maxWidth: 50,
                filterable: false,
                Cell: row => (
                  <div>
                    {row.value}
                  </div>
                )
              },
              {
                Header: "% Decks",
                accessor: "percent_of_decks",
                filterable: false,
                maxWidth: 55,
                Cell: row => (
                  <div>
                    {row.value}%
                  </div>
                )
              },
              {
                Header: "Copies",
                accessor: "number_of_copies",
                filterable: false,
                maxWidth: 55
              },
              {
                Header: "Name",
                accessor: "name",
                sortable: false,
                Cell: row => (
                  <span
                    onClick={(e) => {this.changeModalPlayer(e, row.original.player_id)}}
                  >{row.value}</span>
                )
              },
              {
                Header: "Pick",
                accessor: "pick_link",
                maxWidth: 52,
                sortable: false,
                Cell: row => (
                  <button
                    // href={row.value}
                    className="btn btn-sm btn-success pick-link"
                    // data-remote="true"
                    rel="nofollow"
                    data-method="patch"
                    onClick={(e) => {this.onPick(e, row.value)}}
                    style={{display: this.displayPickLink() === false  ? "none" : null}}
                  ><img src={plus} /></button>
                )
              }
            ]
          }
        ]
      }
    } else {
      columns = [
        {
          columns: [
            {
              Header: "Star",
              accessor: "star_link",
              maxWidth: 54,
              sortable: false,
              Cell: row => (
                <button
                  // href={row.value}
                  className="btn btn-sm star-link remove-star already-starred"
                  // data-remote="true"
                  rel="nofollow"
                  onClick={(e) => {this.onStar(e, row.value)}}
                  style={{display: row.value === undefined ? "none" : null}}
                ><img src={star} className="star-image" /><img src={minus} className="minus-image" /></button>
              )
            },
            {
              Header: "Type",
              accessor: "player_type",
              sortable: false,
              maxWidth: 55
            },
            {
              Header: "Name",
              accessor: "name",
              sortable: false,
              Cell: row => (
                <span
                  onClick={(e) => {this.changeModalPlayer(e, row.original.player_id)}}
                >{row.value}</span>
              )
            },
            {
              Header: "Pick",
              accessor: "pick_link",
              maxWidth: 52,
              sortable: false,
              Cell: row => (
                <button
                  // href={row.value}
                  className="btn btn-sm btn-success pick-link"
                  // data-remote="true"
                  rel="nofollow"
                  data-method="patch"
                  onClick={(e) => {this.onPick(e, row.value)}}
                  style={{display: this.displaySpecialPickLink(row.original.player_type) === false  ? "none" : null}}
                ><img src={plus} /></button>
              )
            }
          ]
        }
      ]
    }
    return (
      <div id="react-stared-player-table">
        <h4>Starred {this.props.pickType.substr(0,1).toUpperCase() + this.props.pickType.substr(1)}s</h4>
        <ReactTable
          columns={columns}
          defaultSorted={[
            {
              id: "xrank",
              desc: false,
              nulls: 'last'
            }
          ]}
          data={this.props.data}
          loading={this.props.loading}
          showPagination={false}
          defaultPageSize={this.props.data.length > 0 ? this.props.data.length : 1}
          showPageSizeOptions={false}
          key={this.props.data.length}
          className="-striped -highlight"
        />
        <PlayerDetailModal
          player={this.state.player}
          show={this.state.showModal}
          onHide={this.hideModal}
          pickType={this.props.pickType}
        />
      </div>
    );
  }
}

export default StarList;
