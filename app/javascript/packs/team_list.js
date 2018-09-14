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
          { this.props.team !== undefined  &&
            <div>
              <h4>{this.props.team.name}</h4>
              <ul>
                {players}
              </ul>
            </div>
          }
        </div>
      );
    } else {
      return (
        <div>
          { this.props.team !== undefined &&
            <div id="react-stared-player-table">
              <h4>My Team</h4>
              <p>Draft {this.props.myPicks !== undefined ? this.props.myPicks.length : 6} players to form your team.</p>
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
                // defaultSorted={[
                //   {
                //     id: "name",
                //     desc: false
                //   }
                // ]}
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
