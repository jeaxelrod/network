/** @jsx React.DOM */
var Board = React.createClass({
  getInitialState: function() {
    return {
      chips: [],
      networks: {"white": {"incomplete": [], "complete": []} , 
                 "black": {"incomplete": [], "complete": []}},
      color: 'white',
      num_black_chips: 0,
      num_white_chips: 0,
      pendingStepMove: false,
      winner: ""
    };
  },
  setAvailableNetworks: function(chips) {
    $.ajax({
      url: "/placeChip.json",
      dataType: 'json',
      type: 'POST',
      data: {"chips": chips},
      success: function(data) {
        var winner = this.setWinner(data);
        this.setState({networks: data, winner: winner});
      }.bind(this),
      error: function(xhr, status, err) {
      }.bind(this)
    });
  },
  setWinner: function(networks) {
    if (networks["white"]["complete"].length > 0) {
      return "white";
    } else if (networks["black"]["complete"].length > 0) {
      return "black";
    }
    return "";
  },
  handleChipPlacement: function(point) {
    var chips = this.state.chips;
    var color = this.state.color;
    var num_white_chips = this.state.num_white_chips;
    var num_black_chips = this.state.num_black_chips;
    var new_color;
    if (color == "white") {
      var excluded_points = ["10", "20", "30", "40", "50", "60", 
                             "17", "27", "37", "47", "57", "67"]
      if (this.state.num_white_chips >= 10 || excluded_points.indexOf(point) > -1) {
        return;
      }
      num_white_chips++;
      new_color = "black";
    } else if (color == "black") {
      var excluded_points = ["01", "02", "03", "04", "05", "06", 
                             "71", "72", "73", "74", "75", "76"] 
      if (this.state.num_black_chips >= 10 || excluded_points.indexOf(point) > -1) {
        return;
      }
      num_black_chips++;
      new_color = "white";
    }
    chips.push({ color: this.state.color, point: point });
    this.setAvailableNetworks(chips);
    this.setState({chips: chips, 
                   color: new_color,
                   num_black_chips: num_black_chips, 
                   num_white_chips: num_white_chips});
  },
  startStepMove: function(point) {
    var chip = document.getElementsByClassName(point + " chip")[0];
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
    var prev_y = prev_point[1];
    var new_x = point[0];
    var new_y = point[1];
    var chips = this.state.chips;
    var new_color;
    if (this.state.color == "white") {
      new_color = "black";
    } else  {
      new_color = "white";
    }
    for (var k=0; k< chips.length; k++) {
      var chip = chips[k];
      if (prev_point == chip.point) {
        chip.point = point;
        this.setAvailableNetworks(chips);
        this.setState({chips: chips, color: new_color, pendingStepMove: false});
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
  getConnectedChips: function(point) {
    var connected_chips = [];
    for (var k=0; k<this.state.chips.length; k++) {
      var chip = this.state.chips[k];
      var chip_x = parseInt(chip.point[0]);
      var chip_y = parseInt(chip.point[1]);
      var x = parseInt(point[0]);
      var y = parseInt(point[1]);
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
        var active_square;
        if (this.state.winner != "") {
          inactive_square = true;
        } else {
          inactive_square = false;
        }
        var color = "";
        if ((j == 0 || j == 7) && (i == 0 || i == 7)) {
          inactive_square = true;
        }
        for (var k=0; k<this.state.chips.length; k++) {
          var chip = this.state.chips[k];
          if (chip.point[0] == i && chip.point[1] == j) {
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
        <BoardHeader  
          color = {this.state.color} 
          networks={this.state.networks}
          winner= {this.state.winner}
        />
        <table className="board_table">
          {board_rows}
        </table>
      </div>
    );
  }
});

var BoardHeader = React.createClass({
  render: function() {
    var networks = this.props.networks
    var white_incomplete = networks["white"]["incomplete"];
    var black_incomplete = networks["black"]["incomplete"];
    var white_incomplete_display = "";
    for (var i=0; i < white_incomplete.length; i++) {
      var network = white_incomplete[i];
      white_incomplete_display += "[ "
      for (var m=0; m < network.length; m++) {
        point = network[m];
        white_incomplete_display += point + ", "
      }
      white_incomplete_display += "] ,"
    }
    var black_incomplete_display = "";
    for (var i=0; i < black_incomplete.length; i++) {
      var network = black_incomplete[i];
      black_incomplete_display += "[ "
      for (var m=0; m < network.length; m++) {
        point = network[m];
        black_incomplete_display += point + ", "
      }
      black_incomplete_display += "] ,"
    }
    var white_complete = networks["white"]["complete"];
    var white_complete_display = "";
    for (var i=0; i < white_complete.length; i++) {
      var network = white_complete[i];
      white_complete_display += "[ "
      for (var m=0; m < network.length; m++) {
        point = network[m];
        white_complete_display += point + ", "
      }
      white_complete_display += "] ,"
    }
    var black_complete = networks["black"]["complete"];
    var black_complete_display = "";
    for (var i=0; i < black_complete.length; i++) {
      var network = black_complete[i];
      black_complete_display += "[ "
      for (var m=0; m < network.length; m++) {
        point = network[m];
        black_complete_display += point + ", "
      }
      black_complete_display += "] ,"
    }
    var winner_display = this.props.winner;
    if (winner_display != "") {
      winner_display += " wins!";
    }
    return ( 
      <div className="board_header">
        <h1 className="title">Network</h1>
        <h1>{winner_display}</h1>
        <h2 className="sub-title">{this.props.color}'s turn</h2>
        <h2 className="white-networks">White incomplete: {white_incomplete_display}</h2>
        <h2 className="black-networks">Black incomplete: {black_incomplete_display}</h2>
        <h2 className="black-networks">White complete: {white_complete_display}</h2>
        <h2 className="black-networks">Black complete: {black_complete_display}</h2>
      </div>
    );
  }
});

var BoardSquare = React.createClass({
  onClick: function() {
    if (this.props.pendingStepMove && !this.props.inactive) {
      if (this.props.chip == "" && this.notConnectedChip()) {
        this.props.onEmptySquareStepMove(this.props.coordinate);
      } else if (this.props.chip != "") {
        this.props.onSquareStepMove(this.props.coordinate);
      }
    } else if (!this.props.inactive) {
       if (this.props.chip == "" && this.notConnectedChip()) {
        this.props.onEmptySquare(this.props.coordinate);
      } else if (this.props.chip != "") {
        this.props.onSquareWithChip(this.props.coordinate);
      }     
    }
  },
  notConnectedChip: function() {
    var point = this.props.coordinate;
    var connected_chips = this.props.getConnectedChips(point);
    if (connected_chips.length >= 2) {
      return false;
    }
    for (var k=0; k<connected_chips.length; k++) {
      var chip = connected_chips[k];
      var second_connected_chips = this.props.getConnectedChips(chip.point);
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


