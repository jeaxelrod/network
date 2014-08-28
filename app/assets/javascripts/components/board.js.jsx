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
                        id={i}
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
      var state = "";
      for (var k=0; k<this.props.points.length; k++) {
        var point = this.props.points[k];
        if (point[1] == i) {
          if (point[0] == WHITE) {
            state = "white";
          } else {
            state = "black";
          }
        }
      }
      squares.push(<BoardSquare 
                      id={this.props.id.toString() + i}
                      state = {state}
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
      'white': this.props.state == "white",
      'black': this.props.state == "black"
    });
    console.log(classes);
    return (
      <td onClick={this.onClick} className={classes} id={this.props.id} ></td>
    );
  }
});

React.renderComponent(
  <Board />,
  document.getElementById('board')
);
