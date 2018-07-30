import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

import plus from '../../assets/images/plus.svg';
import star from '../../assets/images/star.svg';
import starGold from '../../assets/images/star-gold.svg';
import minus from '../../assets/images/minus-circle.svg';

class AvailablePlayersTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      search: ''
    }
    this.onStar = this.onStar.bind(this);
    this.getStarId = this.getStarId.bind(this);
    this.displayPickLink = this.displayPickLink.bind(this);
  }

  onStar(e, url, starId) {
    e.preventDefault();
    let method = null
    if ($(e.target).parent().hasClass('already-starred')) {
      method = 'DELETE'
    } else {
      method = 'POST'
    }

    if (starId) {
      url = url.split('?')[0] + "/" + starId
    }

    this.props.handleStar(url, method);
  }

  getStarId(playerId) {
    let star = this.props.myStars.find(
      function(element) { return element.player_id === playerId
      })

    if (star === undefined) {
      return null
    } else {
      return star.id
    }
  }

  displayPickLink() {
    return this.props.myPicks.some(item => this.props.currentPick === item)
  }

  render() {
    let data = this.props.data
		if (this.state.search !== '') {
			data = data.filter(row => {
				return String(row.name.toLowerCase()).includes(this.state.search.toLowerCase())
			})
		}
    return (
      <div id="react-player-table">
        <div className="form-group">
          <input
            className="form-control"
            placeholder="Search..."
            value={this.state.search}
            onChange={e => this.setState({search: e.target.value})}
          />
        </div>
        <ReactTable
          columns={[
            {
              columns: [
                {
                  Header: "Star",
                  accessor: "star_link",
                  maxWidth: 54,
                  sortable: false,
                  filterable: false,
                  Cell: row => (
                    <button
                      // href={row.value}
                      className={"btn btn-sm star-link" + (this.props.myStars.filter(e => e.player_id === row.original.player_id).length > 0 ? " already-starred" : "") }
                      // data-remote="true"
                      rel="nofollow"
                      onClick={(e) => {this.onStar(e, row.value, this.getStarId(row.original.player_id))}}
                      style={{display: row.value === undefined ? "none" : null}}
                    ><img src={star} className="star-image"/><img src={starGold} className="star-gold-image"/><img src={minus} className="minus-image"/></button>
                  )
                },
                {
                  Header: "Points",
                  accessor: "points_per_result",
                  maxWidth: 60,
                  filterable: false,
                  Cell: row => (
                    <div>
                      {row.value}
                    </div>
                  )
                },
                {
                  Header: "PTs",
                  accessor: "results",
                  filterable: false,
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
                  sortable: false,
                  filterable: false,
                  Cell: row => (
                    <a
                      href={row.value}
                      className="btn btn-sm btn-success pick-link"
                      data-remote="true"
                      rel="nofollow"
                      data-method="patch"
                      // onClick={this.updateTableData}
                      style={{display: this.displayPickLink() === false  ? "none" : null}}
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
          data={data}
          loading={this.props.loading}
          defaultPageSize={15}
          className="-striped -highlight"
        />
      </div>
    );
  }
}

export default AvailablePlayersTable;
