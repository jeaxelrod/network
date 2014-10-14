var createLine = function(table, point1, point2) {
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
}; 
