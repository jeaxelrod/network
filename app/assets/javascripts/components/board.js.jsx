/** @jsx React.DOM */
var WHITE = 1;
var BLACK = 2;
var Board = React.createClass({
  getInitialState: function() {
    return {
      points: [],
    };
  },

  handleChipPlacement: function(color, point) {
    points = this.state.points;
    points.push([color, point]);
    this.setState({points: points});
  },
  render: function() {
    var board_rows = [];
    for (var i=0; i<8; i++) {
      var points = []; 
      for (var k=0; k<this.state.points.length; k++) {
        var point = this.state.points[k];
        if (point[1][0] == i) {
          points.push([point[0], point[1][1]]);
        }
      }
      board_rows.push(<BoardRow 
                        row_id={i}
                        points={points}
                        onUserClick = {this.handleChipPlacement}
                      />);

    }
    return (
      <table className="board_table">
        {board_rows}
      </table>
    );
  }
});

var BoardRow = React.createClass({
  render: function() {
    var squares = [];
    for (var i=0; i<8; i++) {
      var inactive_square = false;
      var state = "";

      if (this.props.row_id == 0 || this.props.row_id == 7) {
        if (i == 0 || i == 7) {
          inactive_square = true;
        }
      }

      for (var k=0; k<this.props.points.length; k++) {
        var point = this.props.points[k];
        if (point[1] == i) {
          if (point[0] == BLACK) {
            state = "white";
          } else {
            state = "black";
          }
        }
      }
      squares.push(<BoardSquare 
                      id={this.props.row_id.toString() + i}
                      state = {state}
                      inactive = {inactive_square}
                      onUserClick = {this.props.onUserClick}
                   />)
    }
    return (
      <tr className="board_row">
        {squares}
      </tr>
    );
  }
});

var BoardSquare = React.createClass({
  onClick: function() {
    this.props.onUserClick(WHITE, this.props.id);
  },
  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'board_square': true,
      'inactive': this.props.inactive
    });
    var chip;
    if (!this.props.inactive) {
      if (this.props.state == "white") {
        chip = <Chip color= "white" point={this.props.id} />
      } else if (this.props.state == "black") {
        chip = <Chip color="black" point={this.props.id} />
      }
    }
    return (
      <td onClick={this.onClick} className={classes} id={this.props.id} >
        {chip}
      </td>
    );
  }
});

var Chip = React.createClass({
  render: function() {
    return (
      <div className={this.props.color + " chip " + this.props.point} ></div>
    );
  }
});

React.renderComponent(
  <Board />,
  document.getElementById('board')
);
