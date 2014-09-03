/** @jsx React.DOM */
var Board = React.createClass({
  getInitialState: function() {
    return {
      chips: [],
      color: 'black',
      num_black_chips: 0,
      num_white_chips: 0,
      pendingStepMove: false
    };
  },

  handleChipPlacement: function(point) {
    var chips = this.state.chips;
    var color = this.state.color;
    var num_white_chips = this.state.num_white_chips;
    var num_black_chips = this.state.num_black_chips;
    if (color == "white") {
      var excluded_points = ["10", "20", "30", "40", "50", "60", 
                             "17", "27", "37", "47", "57", "67"]
      if (this.state.num_white_chips >= 10 || excluded_points.indexOf(point) > -1) {
        return;
      }
      num_white_chips++;
    } else if (color == "black") {
      var excluded_points = ["01", "02", "03", "04", "05", "06", 
                             "71", "72", "73", "74", "75", "76"] 
      if (this.state.num_black_chips >= 10 || excluded_points.indexOf(point) > -1) {
        return;
      }
      num_black_chips++;
    }
    chips.push({ color: this.state.color, x_cord: point[0], y_cord: point[1] });
    this.setState({chips: chips, 
                   num_black_chips: num_black_chips, 
                   num_white_chips: num_white_chips});
  },
  startStepMove: function(point) {
    var chip = document.getElementsByClassName(point + " chip")[0];
    console.log(chip);
    if ((this.state.color == "black" && this.state.num_black_chips == 10 && chip.className.contains("black")) ||
        (this.state.color == "white" && this.state.num_white_chips == 10 && chip.className.contains("white"))) {
      this.setState({pendingStepMove: true});
      this.refs[point].getDOMNode().className += " step_move";
    }
  },
  finishStepMove: function(point) {
    var prev_square = document.getElementsByClassName("step_move")[0];
    var prev_chip = prev_square.children[0];
    var prev_point = prev_square.className.match(/\d\d/)[0];
    this.refs[prev_point].getDOMNode().className = "board_square " + prev_point;
    var prev_x = prev_point[0];
    var prev_y = prev_point[1];
    var new_x = point[0];
    var new_y = point[1];
    var chips = this.state.chips;
    for (var k=0; k< chips.length; k++) {
      var chip = chips[k];
      if (prev_x == chip.x_cord && prev_y == chip.y_cord) {
        chip.x_cord = new_x;
        chip.y_cord = new_y;
        this.setState({chips: chips, pendingStepMove: false});
        return;
      }
    }
  },
  cancelStepMove: function(point) {
    var current_square = this.refs[point].getDOMNode();
    if (current_square.className.contains("step_move")) {
      current_square.className = "board_square " + point;
      this.setState({pendingStepMove: false});
    }
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
      if (this.state.pendingStepMove) {
        var choosen_chip = document.getElementsByClassName("step_move")[0]; 
        var choosen_point = choosen_chip.className.match(/\d\d/)[0];
        var choosen_x = choosen_point[0];
        var choosen_y = choosen_point[1];
        if (choosen_x == chip_x && choosen_y == chip_y) {
          continue;
        }
      }
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
                    coordinate = {i.toString() + j}
                    ref = {i.toString() + j}
                    key = {i.toString() + j}
                    chip = {color}
                    inactive = {inactive_square}
                    onEmptySquare = {this.handleChipPlacement}
                    onSquareWithChip = {this.startStepMove}
                    onEmptySquareStepMove = {this.finishStepMove}
                    onSquareStepMove = {this.cancelStepMove}
                    getConnectedChips = {this.getConnectedChips}
                    pendingStepMove = {this.state.pendingStepMove}
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
    if (this.props.pendingStepMove) {
      if (this.props.chip == "" && this.notConnectedChip()) {
        this.props.onEmptySquareStepMove(this.props.coordinate);
      } else if (this.props.chip != "") {
        this.props.onSquareStepMove(this.props.coordinate);
      }
    } else {
       if (this.props.chip == "" && this.notConnectedChip()) {
        this.props.onEmptySquare(this.props.coordinate);
      } else if (this.props.chip != "") {
        this.props.onSquareWithChip(this.props.coordinate);
      }     
    }
  },
  notConnectedChip: function() {
    var point = this.props.coordinate;
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
        chip = <Chip color= "white" point={this.props.coordinate} />
      } else if (this.props.chip == "black") {
        chip = <Chip color="black" point={this.props.coordinate} />
      }
    }
    return (
      <td onClick={this.onClick} className={classes + " " + this.props.coordinate} >
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
