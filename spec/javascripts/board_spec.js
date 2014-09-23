var ReactTestUtils;
describe('Network', function() {
  var TestUtils, instance;
  var container = document.createElement("div");
  container.id = "board"
  var TestUtils = React.addons.TestUtils;

  afterEach(function() {
    if (instance && instance.isMounted()) {
      React.unmountComponentAtNode(document.getElementById("board"));
    }
  });
  describe('Local Board', function() {
    var board;

    beforeEach(function() {
      board = Board({type: "local", id: 1, player: "white"});
      instance = TestUtils.renderIntoDocument(board);
    });

    it("should render correctly", function() {

      expect(instance.state.chips.white).toEqual([]);
      expect(instance.state.chips.black).toEqual([]);
      expect(instance.state.networks.white).toBeDefined();
      expect(instance.state.networks.black).toBeDefined();
      expect(instance.state.turn).toBe("white");

    });

    it("should handle chip placement", function() {
      instance.boardClick(11);

      expect(instance.state.chips.white).toEqual([11]);
    });

    it("should not place white chip on black area", function() {
      instance.boardClick(10);

      expect(instance.state.chips.white).toEqual([]);
    });

    it("should ask server for list of networks", function() {
      spyOn($, "ajax").and.callFake(function(options) {
        var chips = {black: [10, 30, 44], white: [3, 33, 11, 27]};
        var networks = {white: { incomplete: [3, 33, 11], complete: []}, 
                        black: { incomplete: [], complete: [] }};
        options.success(({chips: chips, 
                        networks: networks,
                        color: "black"}));
      }); 
      instance.setAvailableNetworks({chips: {white: [3, 33, 11, 27], black: [10, 30, 44]}});

      expect($.ajax.calls.mostRecent().args[0].url).toEqual("/placeChip.json");
      expect(instance.state.networks.white.incomplete).toEqual([3, 33, 11]);
      expect(instance.state.turn).toBe("black");
    });

    it("should perform a step move", function() {
      instance.boardClick(11);
      instance.setState({stepMoveTime: true});
      instance.boardClick(11);
      instance.boardClick(12);
      
      expect(instance.state.chips.white).toEqual([12]);
    });
  });

  describe("Computer Board", function() {
    var board;
    beforeEach(function() {
      board = Board({type: "local", id: 1, player: "white"});
      instance = TestUtils.renderIntoDocument(board);
    });
  });

  describe("Multiplayer Board", function() {
    var board;
    beforeEach(function() {
      board = Board({type: "online", id: 1, player: "white"});
      instance = TestUtils.renderIntoDocument(board);
    });
  });
});
  
