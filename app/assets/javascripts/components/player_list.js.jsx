/** @jsx React.DOM */
var PlayerList = React.createClass({
  getInitialState: function() {
    return {
      players: this.props.players,
      this_player: this.props.this_player,
      game_requested: false
    };
  },
  componentDidMount: function() {
    setInterval(this.pollServer, 1000);
    setInterval(this.updatePlayers, 8000);
  },
  pollServer: function() {
    console.log("pollSever");
    $.ajax({
      url: "/pending_player/update.json",
      dataType: 'json',
      type: 'POST',
      data: {"id": this.props.this_player},
      success: function(data) {
        console.log("success");
        if ( data != null && data.game_id != null) {
          console.log("component_rendered");
          var other_player = data.other_id
          this.setState({game_requested: true});
          React.renderComponent(
            <Board type="online" id={data.game_id} color="black" />,
            document.getElementById("board")
          );
        }
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("/pending_player/update.json", status, err.toString());
      }
    });
  },
  updatePlayers: function() {
    $.ajax({
      url: "/pending_player/active.json",
      dataType: 'json',
      type: 'GET',
      success: function(data) {
        var players = data.players;
        this.setState({players: players});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("/pending_player/active.json", status, err.toString());
      }
    });
  },
  clickPlayer: function(event) {
    console.log(event);
    event.preventDefault()
    $.ajax({
      url: "/pending_player/request_game.json", 
      dataType: 'json',
      type: 'POST',
      data: {"other_id": $(event.target).data("id"), 
             "this_id":  this.props.this_player
      }, 
      success: function(data) {
        this.setState({game_requested: true});
        React.renderComponent(
          <Board type="online" id={data.game_id} color="white" />,
          document.getElementById("board")
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error("/startgame.json", status, err.toString()) 
      }
    });
  },
  render: function() {
    var players = this.state.players;
    if (!this.state.game_requested) {
      var player_nodes = this.state.players.map(function(player) {
        return <li key={player}>Player {player}
                 <a href="#" data-id={player} onClick={this.clickPlayer}>Play</a></li>;
      }.bind(this));
    }
    return (
      <ul>{player_nodes}</ul>
    );
  }
});
