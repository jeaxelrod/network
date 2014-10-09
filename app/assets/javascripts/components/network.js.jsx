/** @jsx React.DOM */
var Board = React.createClass({
  getInitialState: function() {
    return {
      chips: {"white": [], "black": []},
      networks: {"white": {"incomplete": [], "complete": []} , 
                 "black": {"incomplete": [], "complete": []}},
      player: this.props.player, //Color of player 
      turn: this.props.turn || "white", //color of current turn
      pendingStepMove: null,
      stepMoveTime: false,
      winner: ""
    };
  },
  componentDidMount: function() {
    if (this.props.type == "online") {
      setInterval(this.updateGame, 3000);
    }
  },
  boardClick: function(point) {
    var current_square = this.refs[point];
    if (this.state.winner == "") {
      if (this.props.type != "online" || this.state.turn == this.state.player) {
        if (current_square.props.type != "inactive") {
          if (this.state.stepMoveTime) {
            if (this.state.pendingStepMove) {
              this.finishStepMove(point);
            } else {
              this.startStepMove(point);
            }
          } else {
            if (this.validMove(point)) {
              this.addChip(point);
            }
          }
        }
      }
    }
  },
  addChip: function(point) {
    var chips = this.state.chips;
    var stepMoveTime = false;
    chips[this.state.turn].push(point);
    if (chips.black.length >= 10) {
      var stepMoveTime = true;
    }
    this.setAvailableNetworks(chips);
    this.setState({chips: chips, stepMoveTime: stepMoveTime});
  },
  validMove: function(point) {
    var current_square= this.refs[point];
    var num_white_chips = this.state.num_chips_chips;
    var num_black_chips = this.state.num_black_chips;
    if (current_square.props.type == "") {
      if (this.state.turn == "white") {
        var excluded_points = [10, 20, 30, 40, 50, 60, 17, 27, 37, 47, 57, 67];
        if (excluded_points.indexOf(point) > -1) {
          return false;
        }
      } else if (this.state.turn == "black") {
        var excluded_points = [1, 2, 3, 4, 5, 6, 71, 73, 74, 75, 76];
        if (excluded_points.indexOf(point) > -1) {
          return false;
        }
      }
      var connected_chips = this.getConnectedChips(point);
      switch (connected_chips.length) { 
        case 0:
          return true;
        case 1:
          var second_connected_chips = this.getConnectedChips(connected_chips[0]);
          return (second_connected_chips.length == 0);
        default:
          return false;
      }
    }
    return false;
  },
  getConnectedChips: function(point) {
    var connected_chips = [];
    var turn = this.state.turn;
    var chips = this.state.chips[turn]
    var x = Math.floor(point/10);;
    var y =  point % 10;
    for (var k=0; k< chips.length; k++) {
      var chip = chips[k];
      var chip_x = Math.floor(chip/10); 
      var chip_y = chip % 10; 
      if (this.state.pendingStepMove) {
        var choosen_point = this.state.pendingStepMove; 
        if (choosen_point == chip) {
          continue;
        }
      }
      if ((chip_x != x || chip_y != y)) { 
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
  startStepMove: function(point) {
    var square = this.refs[point];
    if ( square &&
        (this.state.turn == "black" && square.props.type.match(/black/) ||
         this.state.turn == "white" &&  square.props.type.match(/white/))) {
      this.setState({pendingStepMove: point});
    }
  },
  finishStepMove: function(point) {
    var prev_point = this.state.pendingStepMove; 
    var chips = this.state.chips;
    var colored_chips = chips[this.state.turn]
    if (prev_point == point) {
      //Cancel step move
      this.setState({pendingStepMove: null});
    } else {
      //Handle a step move
      if (this.validMove(point)) {
        for (var k=0; k< colored_chips.length; k++) {
          var chip = colored_chips[k];
          if (prev_point == chip) {
            colored_chips[k] = point;
            this.setAvailableNetworks(chips);
            this.setState({chips: chips, pendingStepMove: null});
            return;
          }
        }
      }
    }
  },
  setAvailableNetworks: function(chips) {
    var data = {'id': this.props.id, 'chips': chips, 'color': this.state.turn}
    $.ajax({
      url: "/placeChip.json",
      dataType: 'json',
      type: 'POST',
      data: data,
      success: function(data) {
        var networks = data.networks;
        var chips = data.chips;
        var winner = this.setWinner(networks);
        var stepMoveTime = false;
        if (chips.black && chips.black.length >= 10) {
          stepMoveTime = true;
        }
        this.setState({networks: networks, winner: winner, chips: chips, turn: data.color, stepMoveTime: stepMoveTime});
      }.bind(this),
      error: function(xhr, status, err) {
      }.bind(this)
    });
  },
  updateGame: function() {
    var chips = this.state.chips;
    $.ajax({
      url: "/network/update.json",
      dataType: 'json',
      type: 'POST',
      data: {'id': this.props.id },
      success: function(data) {
        var updated_chips = data.chips;
        if (!updated_chips.black.equals(this.state.chips.black) || 
            !updated_chips.white.equals(this.state.chips.white)) {
          var turn = this.state.turn == "white" ? "black" : "white";
          var networks = data.networks;
          var winner = this.setWinner(networks);
          var stepMoveTime = false;
          if (updated_chips.black.length >= 10) {
            stepMoveTime = true;
          }
          this.setState({chips: updated_chips, networks: networks, turn: turn, stepMoveTime: stepMoveTime, winner: winner});
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("/network/update.json", status, err.toString());
      }
    });
  },
  setWinner: function(networks) {
    if (networks && networks["white"] && networks["black"]) {
      if (networks["white"]["complete"].length > 0) {
        return "white";
      } else if (networks["black"]["complete"].length > 0) {
        return "black";
      }
      return "";
    }
  },
  render: function() {
    var board_rows = [];
    var white = this.state.chips.white;
    var black = this.state.chips.black;
    for (var j=0; j<8; j++) {
      var row = [];
      var tr = React.DOM.tr;
      for (var i=0; i<8; i++) {
        var extraClasses = " ";
        var point = (i * 10) + j;
        var type = "";
        if ((j == 0 || j == 7) && (i == 0 || i == 7)) {
          type = "inactive";
        } else if (white.indexOf(point) >= 0) {
          type = "white";
        } else if (black.indexOf(point) >= 0) {
          type = "black";
        } 

        if (point == this.state.pendingStepMove) {
          type = "pending_" + type;
        }

        if (this.state.winner == "white") {
          if (this.state.networks.white.complete[0].indexOf(point) >= 0) {
            extraClasses += " winner";
          }
        } else if (this.state.winner == "black") {
          if (this.state.networks.black.complete[0].indexOf(point) >= 0) {
            extraClasses += " winner";
          }
        }
        if (j == 0 || j == 7) {
          if ( i != 0 && i != 7) {
            extraClasses += " black_goal"
          }
        } else {
          if ( i == 0 || i == 7) {
            extraClasses += " white_goal"
          }
        }
        row.push(<BoardSquare
                    coordinate = {point}
                    type = {type}
                    onClick = {this.boardClick}
                    ref = {point}
                    key = {point}
                    extraClasses={extraClasses}
                  />);
      }
      var classString = "row" + j;
      board_rows.push(<tr key={j} className={classString}>{row}</tr>);
    }
    return (
      <div>
        <BoardHeader  
          turn = {this.state.turn} 
          player = {this.state.player}
          typeOfGame = {this.props.type}
          winner= {this.state.winner}
          chips = {this.state.chips}
        />
        <table className="board_table">
          {board_rows}
        </table>
      </div>
    );
  }
});

var BoardSquare = React.createClass({
  onClick: function() {
    this.props.onClick(this.props.coordinate);
  },
  render: function() {
    var chip;
    var classes = "board_square" + " " + this.props.coordinate + " " + 
                  this.props.type + this.props.extraClasses;
    if (!this.props.inactive) {
      if (this.props.type == "white" || this.props.type == "pending_white") {
        chip = <Chip color= "white" coordinate={this.props.coordinate} />
      } else if (this.props.type == "black" || this.props.type == "pending_black") {
        chip = <Chip color="black" coordinate={this.props.coordinate} />
      }
    }
    return (
      <td onClick={this.onClick} className={classes} >
        {chip}
      </td>
    );
  }
});

var Chip = React.createClass({
  render: function() {
    return (
      <div className={this.props.color + " chip " + this.props.coordinate} ></div>
    );
  }
});

var BoardHeader = React.createClass({
  render: function() {
    var title, currentTurn, chipsColor;
    var chips = this.props.chips;
    var winner_display = "";
    switch (this.props.typeOfGame) {
    case "local":
      title = "Local Network";
      currentTurn = this.props.turn.capitalize();
      chipsColor = this.props.turn;
      if (this.props.winner != "") {
        winner_display = this.props.winner.capitalize() + " wins!";
      }
      break;
    case "online":
      title = "Multiplayer Network";
      chipsColor = this.props.player;
      if (this.props.turn === this.props.player) {
        currentTurn = "Your's"
      } else {
        currentTurn = "Their's";
      }
      if (this.props.winner != "") {
        if (this.props.winner == this.props.player) {
          winner_display = "You win!";
        } else {
          winner_display = "You lose";
        }
      }
      break;
    case "computer":
      title = "Computer Network";
      chipsColor = this.props.player;
      if (this.props.turn === this.props.player) {
        currentTurn = "Your's";
      } else {
        currentTurn = "Computer's";
      }
      if (this.props.winner != "") {
        if (this.props.winner == this.props.player) {
          winner_display = "You win!";
        } else {
          winner_display = "You lose";
        }
      }
      break;
    }
    var chipsLength = 10 - chips[chipsColor].length;
    var table_rows = [];
    for (var j=0; j<2; j++) {
      var each_row = [];
      for (var i=0; i<5; i++) {
        if (chipsLength > 0) {
          each_row.push(<td key ={i*10 + j}><Chip color={chipsColor} coordinate ="" /></td>);
          chipsLength--;
        } else {
          each_row.push(<td />);
        }
      }
      table_rows.push(<tr key={j}>{each_row}</tr>);
    }

    return ( 
      <div className="board_header">
        <h1>{winner_display}</h1>
        <h2 className="sub-title">Turn: <span className={this.props.turn + "_turn"}>{currentTurn}</span></h2>
        <div className="current_chips">
          <h2>Chips:</h2>
          <table>{table_rows}</table> 
        </div>
      </div>
    );
  }
});
