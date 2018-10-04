import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

import minus from '../../assets/images/minus-circle.svg';

class TeamList extends React.Component {
  constructor(props) {
    super(props);
    this.onRemovePlayer = this.onRemovePlayer.bind(this);
  }

  onRemovePlayer(e, url) {
    e.preventDefault();
    this.props.handleRemovePlayer(url, 'PUT');
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
      return (
        <div>
          { this.props.team !== undefined &&
            <div id="react-stared-player-table">
              <h4>{this.props.team.name}</h4>
              <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} players your roster then submit your team below.</p>
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
                        sortable: false
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
        </div>
      );
    } else {
      return (
        <div>
          { this.props.team !== undefined &&
            <div id="react-stared-player-table">
              <h4>{this.props.team.name}</h4>
              <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} players your roster then submit your team below.</p>
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
                        sortable: false
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
        </div>
      )
    }
  }
}

export default TeamList;
