/** @jsx React.DOM */
var PlayerList = React.createClass({
  getInitialState: function() {
    return {
      players: this.props.players,
      this_player: this.props.this_player,
      game_requested: false,
      poll_timer_id: setInterval(this.pollServer, 1000),
      update_timer_id: setInterval(this.updatePlayers, 8000) 
    };
  },
  pollServer: function() {
    $.ajax({
      url: "/pending_player/update.json",
      dataType: 'json',
      type: 'POST',
      data: {"id": this.props.this_player},
      success: function(data) {
        if ( data != null && data.game_id != null) {
          var other_player = data.other_id
          this.setState({game_requested: true});
          clearInterval(this.state.poll_timer_id);
          clearInterval(this.state.update_timer_id);
          React.renderComponent(
            <Board type="online" id={data.game_id} player="black" />,
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
          <Board type="online" id={data.game_id} player="white" />,
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
    console.log(player_nodes);
    if (player_nodes.length == 0) {
      player_nodes.push(<li key={0}>No one online</li>)
    }
    return (
      <ul className="player_list">{player_nodes}</ul>
    );
  }
});
