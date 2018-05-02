import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

import ReactTable from "react-table";
import "react-table/react-table.css";

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      data: [
        {
          firstName: "Someone",
          lastName: "Else",
          age: 101,
          visits: 1,
          status: "single"
        },
        {
          firstName: "Someone",
          lastName: "Else",
          age: 100,
          visits: 1,
          status: "single"
        },
        {
          firstName: "Someone",
          lastName: "Else",
          age: 100,
          visits: 1,
          status: "single"
        },
        {
          firstName: "Someone",
          lastName: "Else",
          age: 100,
          visits: 1,
          status: "single"
        }
      ]
    };
  }
  render() {
    const { data } = this.state;
    return (
      <div>
        <ReactTable
          data={data}
          columns={[
            {
              Header: "Name",
              columns: [
                {
                  Header: "First Name",
                  accessor: "firstName"
                },
                {
                  Header: "Last Name",
                  id: "lastName",
                  accessor: d => d.lastName
                }
              ]
            },
            {
              Header: "Info",
              columns: [
                {
                  Header: "Age",
                  accessor: "age"
                },
                {
                  Header: "Status",
                  accessor: "status"
                }
              ]
            },
            {
              Header: 'Stats',
              columns: [
                {
                  Header: "Visits",
                  accessor: "visits"
                }
              ]
            }
          ]}
          defaultPageSize={10}
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
    <App draftId={draftId} />,
    document.getElementById('react-player-table').appendChild(document.createElement('div')),
  )
})
