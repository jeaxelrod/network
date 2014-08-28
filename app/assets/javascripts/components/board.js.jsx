/** @jsx React.DOM */
var Board = React.createClass({
  getInitialState: function() {
    return {
      points: [],
      color: 'black'
    };
  },

  handleChipPlacement: function(point) {
    points = this.state.points;
    var color = this.state.color;
    if (color == "white") {
      var excluded_points = ["10", "20", "30", "40", "50", "60", 
                             "17", "27", "37", "47", "57", "67"]
      if (excluded_points.indexOf(point) > -1) {
        return;
      }
    } else if (color == "black") {
      var excluded_points = ["01", "02", "03", "04", "05", "06", 
                             "71", "72", "73", "74", "75", "76"] 
      if (excluded_points.indexOf(point) > -1) {
        return;
      }
    }
    points.push([this.state.color, point]);
    this.setState({points: points});
  },
  handleColorChange: function(event) {
    this.setState({color: event.target.value});
  },
  render: function() {
    var board_rows = [];
    for (var i=0; i<8; i++) {
      var points = []; 
      for (var k=0; k<this.state.points.length; k++) {
        var point = this.state.points[k];
        if (point[1][1] == i) {
          points.push([point[0], point[1]]);
        }
      }
      board_rows.push(<BoardRow 
                        row_id={i}
                        points={points}
                        onUserClick = {this.handleChipPlacement}
                      />);

    }
    return (
      <div>
        <ControlForm  handleColorChange= {this.handleColorChange} />
        <table className="board_table">
          {board_rows}
        </table>
      </div>
    );
  }
});

var ControlForm = React.createClass({
  render: function() {
    return ( 
      <div onChange={this.props.handleColorChange}>
        <input type="radio" name="color" value="black" defaultChecked >Black</input>
        <input type="radio" name="color" value="white" >White</input>
      </div>
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
        if (point[1][0] == i) {
          if (point[0] == "white") {
            state = "white";
          } else {
            state = "black";
          }
        }
      }
      squares.push(<BoardSquare 
                      id={i + this.props.row_id.toString()}
                      chip = {state}
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
    this.props.onUserClick(this.props.id);
  },
  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'board_square': true,
      'inactive': this.props.inactive
    });
    var chip;
    if (!this.props.inactive) {
      if (this.props.chip == "white") {
        chip = <Chip color= "white" point={this.props.id} />
      } else if (this.props.chip == "black") {
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
