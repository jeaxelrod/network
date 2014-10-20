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
      instance.placeChip({chips: {white: [3, 33, 11, 27], black: [10, 30, 44]}});

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
      instance.placeChip({chips: {white: [3, 33, 11, 27], black: [10, 30, 44]}});

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

  describe("Multiplayer Board", function() {
    var board;
    beforeEach(function() {
      board = Board({type: "online", id: 1, player: "white"});
      board2 = Board({type: "online", id: 1, player: "black"});
      instance = TestUtils.renderIntoDocument(board);
      instance2 = TestUtils.renderIntoDocument(board2);
    });

    it("should add chip correctly", function() {
      instance.boardClick(11);

      expect(instance.state.chips.white).toEqual([11]);
    });
    it("should update the other board correctly", function() {
      //Stimulate the effect of an ajax call
      // TODO better way to stimulate this effect without manually calling it
      spyOn(instance2, "updateGame").and.callFake(function() {
        this.setState({chips: {white: [11], black:[]}, turn: "black"});
      });
      instance.boardClick(11);
      instance2.updateGame();

      expect(instance2.state.chips.white).toEqual([11]);
      expect(instance2.updateGame).toHaveBeenCalled();
    });
    it("let other player place a chip", function() {
      spyOn(instance2, "updateGame").and.callFake(function() {
        this.setState({chips: {white: [11], black:[]}, turn: "black"});
      });
      spyOn(instance, "updateGame").and.callFake(function() {
        this.setState({chips: {white: [11], black:[12]}, turn: "white"});
      });
      instance.boardClick(11);
      instance2.updateGame();
      instance2.boardClick(12);
      instance.updateGame();

      expect(instance2.state.chips.white).toEqual([11]);
      expect(instance.state.chips.white).toEqual([11]);
      expect(instance2.state.chips.black).toEqual([12]);
      expect(instance.state.chips.black).toEqual([12]);
      expect(instance2.updateGame).toHaveBeenCalled();
      expect(instance.updateGame).toHaveBeenCalled();
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
      instance.placeChip({chips: {white: [3, 33, 11, 27], black: [10, 30, 44]}});

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
});
  
