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
      console.log(network);
      var winners = document.querySelectorAll("td.winner");
      for (var i=0; i < winners.length; i++) {
        console.log(winners.length);
        var square = winners[i];
        square.className = square.className.replace(/\bwinner\b/, '');

      }
      for (var i=0; i < network.length; i++) {
        var coordinate = network[i];
        var table = document.getElementsByClassName("board_table")[0];
        var square = table.getElementsByClassName("board_square" + coordinate)[0];
        square.className+= " winner";
      }
      return false;
    }
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
