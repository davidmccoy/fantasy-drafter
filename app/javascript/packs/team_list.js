import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

import PlayerDetailModal from './player_detail_modal';

import minus from '../../assets/images/minus-circle.svg';

class TeamList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      player: {}
    }
    this.onRemovePlayer = this.onRemovePlayer.bind(this);
    this.changeModalPlayer = this.changeModalPlayer.bind(this);
    this.hideModal = this.hideModal.bind(this);
  }

  onRemovePlayer(e, url) {
    e.preventDefault();
    this.props.handleRemovePlayer(url, 'PUT');
  }

  changeModalPlayer(e, playerId) {
    let modalUrl = this.props.pickType === 'player' ?
     `/api/players/${playerId}` : `/api/cards/${playerId}`

    $.ajax({
      url: modalUrl,
      dataType: 'json',
      success: function(data){
        this.setState({
          player: data.player,
          showModal: true
        })
      }.bind(this)
    });
  }

  hideModal() {
    this.setState({
      showModal: false
    })
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

    if (this.props.draftType === 'snake') {
      if (this.props.pickType === 'player') {
        return (
          <div>
            { this.props.team !== undefined &&
              <div id="react-stared-player-table">
                <h4>{this.props.team.name}</h4>
                <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} {this.props.pickType}s for your roster then submit your team below.</p>
                <ReactTable
                  columns={[
                    {
                      columns: [
                        {
                          Header: "Pick",
                          accessor: "pick_number",
                          maxWidth: 50,
                          filterable: false,
                          Cell: (row) => {
                            return <div>#{row.value}</div>;
                          }
                        },
                        {
                          Header: "Points",
                          accessor: "points",
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
                        }
                      ]
                    }
                  ]}
                  defaultSorted={[
                    {
                      id: "pick_number",
                      desc: false,
                      nulls: 'last'
                    }
                  ]}
                  data={this.props.team.players}
                  loading={this.props.loading}
                  showPagination={false}
                  defaultPageSize={this.props.myPicks !== undefined ? (this.props.myPicks.length > 0 ? this.props.myPicks.length : 1) : 6}
                  showPageSizeOptions={false}
                  key={this.props.team.players.length}
                  className="-striped -highlight"
                />
              </div>
            }
            <PlayerDetailModal
              player={this.state.player}
              show={this.state.showModal}
              onHide={this.hideModal}
              pickType={this.props.pickType}
            />
          </div>
        );
      } else if (this.props.pickType === 'card') {
        return (
          <div>
            { this.props.team !== undefined &&
              <div id="react-stared-player-table">
                <h4>{this.props.team.name}</h4>
                <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} {this.props.pickType}s for your roster then submit your team below.</p>
                <ReactTable
                  columns={[
                    {
                      columns: [
                        {
                          Header: "Pick",
                          accessor: "pick_number",
                          maxWidth: 50,
                          filterable: false,
                          Cell: (row) => {
                            return <div>#{row.value}</div>;
                          }
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
                              {row.value !== undefined || row.value !== null ? `${row.value}%` : null}
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
                        }
                      ]
                    }
                  ]}
                  defaultSorted={[
                    {
                      id: "xrank",
                      desc: false,
                      nulls: 'last'
                    }
                  ]}
                  data={this.props.team.players}
                  loading={this.props.loading}
                  showPagination={false}
                  defaultPageSize={this.props.myPicks !== undefined ? (this.props.myPicks.length > 0 ? this.props.myPicks.length : 1) : 6}
                  showPageSizeOptions={false}
                  key={this.props.team.players.length}
                  className="-striped -highlight"
                />
              </div>
            }
            <PlayerDetailModal
              player={this.state.player}
              show={this.state.showModal}
              onHide={this.hideModal}
              pickType={this.props.pickType}
            />
          </div>
        );
      }
    } else if (this.props.draftType === 'special') {
      return (
        <div>
          { this.props.team !== undefined &&
            <div id="react-my-team-table">
              <h4>{this.props.team.name}</h4>
              <p>Choose 4 players (each player can be drafted once per format) and two Battle Decks for your roster then submit your team below.</p>
              <h5>Players</h5>
              <ReactTable
                columns={[
                  {
                    columns: [
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
                        Header: "",
                        accessor: "delete_link",
                        maxWidth: 54,
                        sortable: false,
                        Cell: row => (
                          <button
                            // href={row.value}
                            className="btn btn-sm remove-player-link"
                            // data-remote="true"
                            rel="nofollow"
                            onClick={(e) => {this.onRemovePlayer(e, row.value)}}
                            style={{display: row.value === undefined || row.value === null ? "none" : null}}
                          ><img src={minus} className="minus-image" /></button>
                        )
                      }
                    ]
                  }
                ]}
                defaultSorted={[
                  {
                    id: "pick_number",
                    desc: false,
                    nulls: 'last'
                  }
                ]}
                data={this.props.team.players.filter(e => e.player_type === "Player")}
                loading={this.props.loading}
                showPagination={false}
                defaultPageSize={4}
                showPageSizeOptions={false}
                key="players"
                className="-striped -highlight"
              />
              <h5>Battle Decks</h5>
              <ReactTable
                columns={[
                  {
                    columns: [
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
                        Header: "",
                        accessor: "delete_link",
                        maxWidth: 54,
                        sortable: false,
                        Cell: row => (
                          <button
                            // href={row.value}
                            className="btn btn-sm remove-player-link"
                            // data-remote="true"
                            rel="nofollow"
                            onClick={(e) => {this.onRemovePlayer(e, row.value)}}
                            style={{display: row.value === undefined || row.value === null ? "none" : null}}
                          ><img src={minus} className="minus-image" /></button>
                        )
                      }
                    ]
                  }
                ]}
                defaultSorted={[
                  {
                    id: "pick_number",
                    desc: false,
                    nulls: 'last'
                  }
                ]}
                data={this.props.team.players.filter(e => e.player_type === "Deck")}
                loading={this.props.loading}
                showPagination={false}
                defaultPageSize={2}
                showPageSizeOptions={false}
                key="decks"
                className="-striped -highlight"
              />
            </div>
          }
          <PlayerDetailModal
            player={this.state.player}
            show={this.state.showModal}
            onHide={this.hideModal}
            pickType={this.props.pickType}
          />
        </div>
      );
    } else {
      if (this.props.pickType === 'player') {
        return (
          <div>
            { this.props.team !== undefined &&
              <div id="react-stared-player-table">
                <h4>{this.props.team.name}</h4>
                <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} {this.props.pickType}s your roster then submit your team below.</p>
                <ReactTable
                  columns={[
                    {
                      columns: [
                        {
                          Header: "",
                          id: "row",
                          maxWidth: 50,
                          filterable: false,
                          Cell: (row) => {
                            return <div>{row.index+1}.</div>;
                          }
                        },
                        {
                          Header: "Points",
                          accessor: "points",
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
                          Header: "",
                          accessor: "delete_link",
                          maxWidth: 54,
                          sortable: false,
                          Cell: row => (
                            <button
                              // href={row.value}
                              className="btn btn-sm remove-player-link"
                              // data-remote="true"
                              rel="nofollow"
                              onClick={(e) => {this.onRemovePlayer(e, row.value)}}
                              style={{display: row.value === undefined || row.value === null ? "none" : null}}
                            ><img src={minus} className="minus-image" /></button>
                          )
                        }
                      ]
                    }
                  ]}
                  defaultSorted={[
                    {
                      id: "power_ranking",
                      desc: false,
                      nulls: 'last'
                    }
                  ]}
                  data={this.props.team.players}
                  loading={this.props.loading}
                  showPagination={false}
                  defaultPageSize={this.props.myPicks !== undefined ? (this.props.myPicks.length > 0 ? this.props.myPicks.length : 1) : 6}
                  showPageSizeOptions={false}
                  key={this.props.team.players.length}
                  className="-striped -highlight"
                />
              </div>
            }
            <PlayerDetailModal
              player={this.state.player}
              show={this.state.showModal}
              onHide={this.hideModal}
              pickType={this.props.pickType}
            />
          </div>
        )
      } else if (this.props.pickType === 'card') {
        return (
          <div>
            { this.props.team !== undefined &&
              <div id="react-stared-player-table">
                <h4>{this.props.team.name}</h4>
                <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} {this.props.pickType}s your roster then submit your team below.</p>
                <ReactTable
                  columns={[
                    {
                      columns: [
                        {
                          Header: "",
                          id: "row",
                          maxWidth: 50,
                          sortable: false,
                          filterable: false,
                          Cell: (row) => {
                            return <div>{row.index+1}.</div>;
                          }
                        },
                        {
                          Header: "xRank",
                          accessor: "xrank",
                          maxWidth: 50,
                          sortable: false,
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
                          sortable: false,
                          filterable: false,
                          maxWidth: 55,
                          Cell: row => (
                            <div>
                              {row.value !== undefined ? `${row.value}%` : null}
                            </div>
                          )
                        },
                        {
                          Header: "Copies",
                          accessor: "number_of_copies",
                          sortable: false,
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
                          Header: "",
                          accessor: "delete_link",
                          maxWidth: 54,
                          sortable: false,
                          Cell: row => (
                            <button
                              // href={row.value}
                              className="btn btn-sm remove-player-link"
                              // data-remote="true"
                              rel="nofollow"
                              onClick={(e) => {this.onRemovePlayer(e, row.value)}}
                              style={{display: row.value === undefined || row.value === null ? "none" : null}}
                            ><img src={minus} className="minus-image" /></button>
                          )
                        }
                      ]
                    }
                  ]}
                  data={this.props.team.players}
                  loading={this.props.loading}
                  showPagination={false}
                  defaultPageSize={this.props.myPicks !== undefined ? (this.props.myPicks.length > 0 ? this.props.myPicks.length : 1) : 6}
                  showPageSizeOptions={false}
                  key={this.props.team.players.length}
                  className="-striped -highlight"
                />
              </div>
            }
            <PlayerDetailModal
              player={this.state.player}
              show={this.state.showModal}
              onHide={this.hideModal}
              pickType={this.props.pickType}
            />
          </div>
        )
      }
    }
  }
}

export default TeamList;
