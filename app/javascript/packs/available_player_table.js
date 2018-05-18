import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import ReactTable from "react-table";
import "react-table/react-table.css";

import plus from '../../assets/images/plus.svg';

class AvailablePlayerTable extends React.Component {
  constructor() {
    super();
    this.state = {
      data: []
    };

    this.fetchData = this.fetchData.bind(this);
    this.componentDidMount = this.componentDidMount.bind(this);
    this.updateTableData = this.updateTableData.bind(this);
  }

  componentDidMount() {
    this.fetchData();
  }

  updateTableData() {
    this.fetchData();
  }

  fetchData() {
    this.setState({ loading: true })
    $.ajax({
      url: `/api/drafts/${this.props.draftId}/available_players`,
      dataType: 'json',
      success: function(data){
        this.setState({
          data: data.players,
          loading: false
        })
      }.bind(this)
    });
  }

  render() {
    return (
      <div>
        <ReactTable
          columns={[
            {
              columns: [
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
          data={this.state.data}
          loading={this.state.loading}
          defaultPageSize={15}
          className="-striped -highlight"
        />
      </div>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('react-player-table')
  const draftId = node.getAttribute('data')

  ReactDOM.render(
    <AvailablePlayerTable draftId={draftId} />,
    document.getElementById('react-player-table').appendChild(document.createElement('div')),
  )
})
