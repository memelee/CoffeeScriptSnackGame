// Generated by CoffeeScript 1.3.3
(function() {
  var COL, LEN, ROW, Rect, SPD, Snack, rect, startGame;

  ROW = 30;

  COL = 40;

  SPD = 500;

  LEN = 5;

  rect = null;

  window.onload = function() {
    return startGame();
  };

  startGame = function() {
    rect = new Rect(ROW, COL, LEN);
    rect.init();
    return document.onkeydown = function(e) {
      e = e || event;
      switch (e.keyCode) {
        case 37:
          return rect.changeDir(4);
        case 38:
          return rect.changeDir(1);
        case 39:
          return rect.changeDir(2);
        case 40:
          return rect.changeDir(3);
      }
    };
  };

  Snack = (function() {

    function Snack(len) {
      var i, _i, _ref;
      this.len = len;
      this.dir = 2;
      this.list = [];
      for (i = _i = 1, _ref = this.len; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        this.list.push({
          x: 1,
          y: i
        });
      }
    }

    Snack.prototype.next = function() {
      var point;
      point = this.list[this.list.length - 1];
      switch (this.dir) {
        case 1:
          return {
            x: point.x - 1,
            y: point.y
          };
        case 2:
          return {
            x: point.x,
            y: point.y + 1
          };
        case 3:
          return {
            x: point.x + 1,
            y: point.y
          };
        case 4:
          return {
            x: point.x,
            y: point.y - 1
          };
      }
    };

    Snack.prototype.changeDir = function(dir) {
      if (Math.abs(this.dir - dir) !== 2) {
        return this.dir = dir;
      }
    };

    return Snack;

  })();

  Rect = (function() {

    function Rect(row, col, len) {
      var i, j, _i, _j, _ref, _ref1;
      this.row = row;
      this.col = col;
      this.snack = new Snack(len);
      this.map = [];
      for (i = _i = 0, _ref = this.row + 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.map[i] = [];
        for (j = _j = 0, _ref1 = this.col + 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
          this.map[i][j] = 0;
        }
      }
    }

    Rect.prototype.update = function() {
      var nextSpeed;
      if (this.step()) {
        return;
      }
      nextSpeed = SPD - this.snack.len;
      return timer = window.setTimeout(function(){rect.update()}, nextSpeed);
    };

    Rect.prototype.changeDir = function(dir) {
      if (this.snack.dir === dir) {
        return this.step();
      } else {
        return this.snack.changeDir(dir);
      }
    };

    Rect.prototype.init = function() {
      var container, i, j, node, point, _i, _j, _k, _l, _len, _m, _ref, _ref1, _ref2, _ref3, _ref4;
      _ref = this.snack.list;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        this.map[point.x][point.y] = 1;
      }
      for (i = _j = 0, _ref1 = this.col + 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
        this.map[0][i] = this.map[this.row + 1][i] = 100;
      }
      for (i = _k = 1, _ref2 = this.row; 1 <= _ref2 ? _k <= _ref2 : _k >= _ref2; i = 1 <= _ref2 ? ++_k : --_k) {
        this.map[i][0] = this.map[i][this.col + 1] = 100;
      }
      container = document.createElement("div");
      container.className = "container";
      this.list = [];
      for (i = _l = 0, _ref3 = this.row + 1; 0 <= _ref3 ? _l <= _ref3 : _l >= _ref3; i = 0 <= _ref3 ? ++_l : --_l) {
        this.list[i] = [];
        for (j = _m = 0, _ref4 = this.col + 1; 0 <= _ref4 ? _m <= _ref4 : _m >= _ref4; j = 0 <= _ref4 ? ++_m : --_m) {
          node = document.createElement("div");
          node.className = "node-" + this.map[i][j];
          node.id = i + "-" + j;
          node.style.left = (j - 1) * 16 + "px";
          node.style.top = (i - 1) * 16 + "px";
          container.appendChild(node);
          this.list[i][j] = node;
        }
      }
      document.body.appendChild(container);
      this.showFood();
      return window.setTimeout(function(){rect.update()}, SPD);
    };

    Rect.prototype.step = function() {
      var nextMap, nextPoint, prePoint;
      nextPoint = this.snack.next();
      nextMap = this.map[nextPoint.x][nextPoint.y];
      switch (nextMap) {
        case 0:
          prePoint = this.snack.list.shift();
          this.map[prePoint.x][prePoint.y] = 0;
          this.list[prePoint.x][prePoint.y].className = "node-0";
          break;
        case 1:
        case 100:
          alert("Score: " + this.snack.len);
          startGame();
          return 1;
        case 10:
          this.snack.len += 1;
          this.showFood();
      }
      this.snack.list.push(nextPoint);
      this.map[nextPoint.x][nextPoint.y] = 1;
      this.list[nextPoint.x][nextPoint.y].className = "node-1";
      return 0;
    };

    Rect.prototype.showFood = function() {
      var foodX, foodY;
      foodX = Math.round(Math.random() * this.row);
      foodY = Math.round(Math.random() * this.col);
      while (this.map[foodX][foodY]) {
        foodX = Math.round(Math.random() * this.row);
        foodY = Math.round(Math.random() * this.col);
      }
      this.map[foodX][foodY] = 10;
      return this.list[foodX][foodY].className = "node-10";
    };

    return Rect;

  })();

}).call(this);
