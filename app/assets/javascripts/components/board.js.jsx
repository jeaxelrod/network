/** @jsx React.DOM */
var Board = React.createClass({
  getInitialState: function() {
    return {
      chips: [],
      color: 'black'
    };
  },

  handleChipPlacement: function(point) {
    var chips = this.state.chips;
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
    chips.push({ color: this.state.color, x_cord: point[0], y_cord: point[1] });
    this.setState({chips: chips});
  },
  handleColorChange: function(event) {
    this.setState({color: event.target.value});
  },
  getConnectedChips: function(x_cord, y_cord) {
    var connected_chips = [];
    for (var k=0; k<this.state.chips.length; k++) {
      var chip = this.state.chips[k];
      var chip_x = parseInt(chip.x_cord);
      var chip_y = parseInt(chip.y_cord);
      var x = parseInt(x_cord);
      var y = parseInt(y_cord);
      if ((chip_x != x || chip_y != y) && this.state.color == chip.color) { 
        if   (chip_x == x || 
              chip_x == (x - 1) || 
              chip_x == (x + 1)) {
          if (chip_y == y ||
              chip_y == (y - 1) ||
              chip_y == (y + 1)) {
            connected_chips.push(chip);
          }
        }
      }
    }
    return connected_chips;
  },
  render: function() {
    var board_rows = [];
    for (var j=0; j<8; j++) {
      var row = [];
      var tr = React.DOM.tr;
      for (var i=0; i<8; i++) {
        var inactive_square = false;
        var color = "";
        if ((j == 0 || j == 7) && (i == 0 || i == 7)) {
          inactive_square = true;
        }
        for (var k=0; k<this.state.chips.length; k++) {
          var chip = this.state.chips[k];
          if (chip.x_cord == i && chip.y_cord == j) {
            color = chip.color;
          }
        }
        row.push(<BoardSquare
                    id = {i.toString() + j}
                    chip = {color}
                    inactive = {inactive_square}
                    onUserClick = {this.handleChipPlacement}
                    getConnectedChips = {this.getConnectedChips}
                  />);
      }
      var classString = "row" + j;
      board_rows.push(<tr className={classString}>{row}</tr>);
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

var BoardSquare = React.createClass({
  onClick: function() {
    if (this.props.chip == "" && this.notConnectedChip()) {
      this.props.onUserClick(this.props.id);
    }
  },
  notConnectedChip: function() {
    var point = this.props.id;
    var connected_chips = this.props.getConnectedChips(point[0], point[1]);
    if (connected_chips.length >= 2) {
      return false;
    }
    for (var k=0; k<connected_chips.length; k++) {
      var chip = connected_chips[k];
      var second_connected_chips = this.props.getConnectedChips(chip.x_cord, chip.y_cord);
      if (second_connected_chips.length > 0) {
        return false;
      }
    }
    return true;
  },
  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'board_square': true,
      'inactive': this.props.inactive,
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
      <td onClick={this.onClick} className={classes + " " + this.props.id} >
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
