/** @jsx React.DOM */
var PlayerList = React.createClass({
  getInitialState: function() {
    return {
      players: this.props.players,
      this_player: this.props.this_player
    };
  },
  clickPlayer: function(event) {
    event.preventDefault()
    $.ajax({
      url: "/startgame.json", 
      dataType: 'json',
      type: 'POST',
      data: {"other_id": $(event.target).data("id"), 
             "this_id":  this.props.this_player
      }, 
      success: function(data) {
        React.renderComponent(
          <Board type="online" id={data.game_id} color="white" />,
          document.getElementById("board")
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("/", status, err.toString()) 
      }.bind(this)
    });
  },
  render: function() {
    var players = this.state.players;

    var player_nodes = this.state.players.map(function(player) {
      return <li key={player}>Player {player}
               <a href="#" data-id={player} onClick={this.clickPlayer}>Play</a></li>;
    }.bind(this));
    return (
      <ul>{player_nodes}</ul>
    );
  }
});
