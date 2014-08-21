/** @jsx React.DOM */

var Board = React.createClass({
  render: function() {
    return (
      <table className="board_table">
        <BoardRow />
        <BoardRow />
        <BoardRow />
        <BoardRow />
        <BoardRow />
        <BoardRow />
        <BoardRow />
        <BoardRow />
      </table>
    );
  }
});

var BoardRow = React.createClass({
  render: function() {
    return (
      <tr className="board_row">
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
        <BoardSquares />
      </tr>
    );
  }
});

var BoardSquares = React.createClass({
  render: function() {
    return (
      <td class="board_square"></td>
    );
  }
});

React.renderComponent(
  <Board />,
  document.getElementById('board')
);
