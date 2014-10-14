/** @jsx React.DOM */

var NetworkHighlighter = React.createClass({
  getInitialState: function() {
    return {
      black_network: this.props.network["black"],
      white_network: this.props.network["white"]
    }
  },
  onElementClick: function(color, index) {
    var network;
    if (color == "black") {
      network = this.state.black_network[index];
    } else {
      network = this.state.white_network[index];
    }
    return function() {
      var winners = document.querySelectorAll("td.winner");
      //Erase previous highlighted networks
      for (var i=0; i < winners.length; i++) {
        var square = winners[i];
        square.className = square.className.replace(/\bwinner\b/, '');

      }
      //Erase all lines
      var lines = document.querySelectorAll("div.line");
      for (var i=0; i < lines.length; i++) {
        lines[i].parentNode.removeChild(lines[i]);
      }
      for (var i=0; i < network.length; i++) {
        var coordinate = network[i];
        var table = document.getElementsByClassName("board_table")[0];
        var square = table.getElementsByClassName("board_square" + coordinate)[0];
        if ( i < network.length - 1) {
          var line = this.createLine(table, coordinate, network[i+1]);
          square.appendChild(line);
        }
        square.className+= " winner";
      }
      return false;
    }.bind(this);
  },
  createLine: function(table, point1, point2) {
    console.log(point1, point2);
    var square1 = table.getElementsByClassName("board_square" + point1)[0];
    var square2 = table.getElementsByClassName("board_square" + point2)[0];
    var x1 = square1.offsetLeft
    var y1 = square1.offsetTop
    var x2 = square2.offsetLeft
    var y2 = square2.offsetTop
    //Calculate length and angle of line so it renders correctly
    var length = Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
    var angle  = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
    var transform = 'rotate('+angle+'deg)';

    var line = document.createElement("div");
    line.className = "line"

    //Set CSS properties of line
    line.style.width = length + "px";
    line.style.transform = transform;
    return line;
  },
  render: function() {
    var black_links = [],
        white_links = []
    for (var i=0; i<this.state.black_network.length; i++) {
      var a = React.DOM.a;
      black_links.push(<a
                         onClick = {this.onElementClick("black", i)}
                         key = {"black" + (i)}
                         href = "#"
                       >{i + 1}</a>);
    }
    for (var i=0; i<this.state.white_network.length; i++) {
      var a = React.DOM.a;
      white_links.push(<a
                         onClick = {this.onElementClick}
                         key = {"white" + (i)}
                         href = "#"
                       >{i + 1}</a>);
    }
    return (
      <div className="network_highlighter">
        <h2 className="sub_title">Network</h2>
        <div className="network_links">
          <p>Black: {black_links}</p>
          <p>White: {white_links}</p>
        </div>
      </div>
    );
  }
});
