import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';

import ReactTable from "react-table";
import "react-table/react-table.css";

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

  render() {
    return (
      <div id="react-stared-player-table">
        <h4>Starred Players</h4>
        <ReactTable
          columns={[
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
          ]}
          defaultSorted={[
            {
              id: "power_ranking",
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
      </div>
    );
  }
}

export default StarList;
