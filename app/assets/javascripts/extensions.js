String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

Array.prototype.equals = function(array) {
  if (!array) {
    return false;
  }
  if (this.length != array.length) {
    return false;
  }
  for(var i=0; i<this.length; i++) {
    if (this[i] instanceof Array && array[i] instanceof Array) {
      if (!this[i].equals(array[i])) {
        return false;
      }
    } else if (this[i] != array[i]) {
      return false;
    }
  }
  return true;
}
