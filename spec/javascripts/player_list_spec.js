var ReactTestUtils;
describe('PlayerList', function() {
  var board_div = document.createElement("div");

  beforeEach(function() {
    TestUtils = React.addons.TestUtils;
    player_list = PlayerList({players:[1,2], this_player: 3});
    container = document.createElement("div");
    container.id = "player_list"
    instance = React.renderComponent(player_list, container);
  });
  afterEach(function() {
    window.clearInterval(instance.state.poll_timer_id);
    window.clearInterval(instance.state.update_timer_id);
  });

  it("Displays the players properly", function() {
    var list = TestUtils.scryRenderedDOMComponentsWithTag(instance, "li");
    expect(list[0].getDOMNode().textContent).toMatch(/Player 1/);
    expect(list[1].getDOMNode().textContent).toMatch(/Player 2/);
  });

  it("Initializes its state correctly", function() {
    expect(instance.state.players[0]).toBe(1);
    expect(instance.state.players[1]).toBe(2);
    expect(instance.state.this_player).toBe(3);
    expect(instance.state.game_requested).toBe(false);
  });

  it("Should pollServer with correct AJAX request and not render board", function() {
    spyOn($, "ajax").and.callFake(function(options) {
      options.success();
    });
    spyOn(React, "renderComponent");
    instance.pollServer();
    expect($.ajax.calls.mostRecent().args[0].url).toEqual("/pending_player/update.json");
    expect(React.renderComponent).not.toHaveBeenCalled();
    expect(instance.state.game_requested).toBe(false);
  });

  it("Should render a Board after poll to server returns a game has been requested", function() {
    spyOn($, "ajax").and.callFake(function(options) {
      options.success({game_id: 1});
    });
    spyOn(React, "renderComponent");
    instance.pollServer();
    expect($.ajax.calls.mostRecent().args[0].url).toEqual("/pending_player/update.json");
    expect(React.renderComponent).toHaveBeenCalled();
    expect(instance.state.game_requested).toBe(true);
  });

  it("Should correctly update the players list", function() {
    spyOn($, "ajax").and.callFake(function(options) {
      options.success({players: [1,2, 4]});
    });

    instance.updatePlayers();

    expect($.ajax.calls.mostRecent().args[0].url).toEqual("/pending_player/active.json");
    expect(instance.state.players[0]).toBe(1);
    expect(instance.state.players[1]).toBe(2);
    expect(instance.state.players[2]).toBe(4);
  });

  it("Start game when you press play", function() {
    spyOn($, "ajax").and.callFake(function(options) {
      options.success({game_id: 1});
    });
    spyOn(React, "renderComponent");
    
    var play = TestUtils.scryRenderedDOMComponentsWithTag(instance, "a");
    TestUtils.Simulate.click(play[0].getDOMNode());
    
    expect($.ajax.calls.mostRecent().args[0].url).toEqual("/pending_player/request_game.json");
    expect(React.renderComponent).toHaveBeenCalled();
    expect(instance.state.game_requested).toBe(true);
  });
});
