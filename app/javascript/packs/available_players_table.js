import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';

class AvailablePlayersTable extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div id="react-player-table">
        <ReactTable
          columns={[
            {
              columns: [
                {
                  Header: "Star",
                  accessor: "star_link",
                  maxWidth: 52,
                  Cell: row => (
                    <a
                      href={row.value}
                      className="btn btn-sm star-link"
                      data-remote="true"
                      rel="nofollow"
                      data-method="patch"
                      onClick={this.updateTableData}
                      style={{display: row.value === undefined ? "none" : null}}
                    ><img src={star} /></a>
                  )
                },
                {
                  Header: "Points",
                  accessor: "points_per_result",
                  maxWidth: 60,
                  Cell: row => (
                    <div>
                      {row.value}
                    </div>
                  )
                },
                {
                  Header: "PTs",
                  accessor: "results",
                  maxWidth: 40
                },
                {
                  Header: "Name",
                  accessor: "name"
                },
                {
                  Header: "Pick",
                  accessor: "pick_link",
                  maxWidth: 52,
                  Cell: row => (
                    <a
                      href={row.value}
                      className="btn btn-sm btn-success pick-link"
                      data-remote="true"
                      rel="nofollow"
                      data-method="patch"
                      onClick={this.updateTableData}
                      style={{display: row.value === undefined ? "none" : null}}
                    ><img src={plus} /></a>
                  )
                }
              ]
            }
          ]}
          defaultSorted={[
            {
              id: "points_per_result",
              desc: true
            }
          ]}
          data={this.props.data}
          loading={this.props.loading}
          defaultPageSize={15}
          className="-striped -highlight"
        />
      </div>
    );
  }
}

export default AvailablePlayersTable;
