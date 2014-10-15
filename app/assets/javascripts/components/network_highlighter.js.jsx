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
      var table = document.getElementsByClassName("board_table")[0];
      var winners = table.querySelectorAll("td.winner");
      //Erase previous highlighted networks
      for (var i=0; i < winners.length; i++) {
        var square = winners[i];
        square.className = square.className.replace(/\bwinner\b/, '');

      }
      //Erase all lines
      var lines = table.querySelectorAll("div.line");
      for (var i=0; i < lines.length; i++) {
        lines[i].parentNode.removeChild(lines[i]);
      }
      for (var i=0; i < network.length; i++) {
        var coordinate = network[i];
        var square = table.getElementsByClassName("board_square" + coordinate)[0];
        if ( i < network.length - 1) {
          var line = createLine(table, coordinate, network[i+1]);
        }
        square.className+= " winner";
      }
      return false;
    }.bind(this);
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
        <div className="network_links">
          <p>Black: {black_links}</p>
          <p>White: {white_links}</p>
        </div>
      </div>
    );
  }
});
