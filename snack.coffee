ROW = 30
COL = 40
SPD = 500
LEN = 5

rect = null

window.onload = () ->
	SPD = prompt("Input Speed","500")
	startGame()

startGame = () ->
	rect = new Rect(ROW, COL, LEN)
	rect.init()

	document.onkeydown = (e) ->
		e = e || event
		switch e.keyCode
			when 37 then rect.changeDir(4)
			when 38 then rect.changeDir(1)
			when 39 then rect.changeDir(2)
			when 40 then rect.changeDir(3)

class Snack
	constructor: (@len) ->
		@dir = 2
		@list = []
		for i in [1..@len]
			@list.push({ x: 1, y: i	})

	current: () ->
		return @list[@list.length - 1]

	next: () ->
		point = @list[@list.length - 1]
		switch @dir
			when 1 then return { x: point.x - 1, y: point.y }
			when 2 then return { x: point.x, y: point.y + 1 }
			when 3 then return { x: point.x + 1, y: point.y }
			when 4 then return { x: point.x, y: point.y - 1 }

	changeDir: (dir) ->
		if Math.abs(@dir - dir) isnt 2
			@dir = dir

class Rect
	constructor: (@row, @col, len) ->
		@snack = new Snack(len)
		@map = []
		for i in [0..@row + 1]
			@map[i] = []
			for j in [0..@col + 1]
				@map[i][j] = 0

	update: () ->
		if this.step() then return

		# document.getElementById("score").innerHTML = @snack.len

		nextSpeed = SPD - @snack.len
		`timer = window.setTimeout(function(){rect.update()}, nextSpeed)`

	changeDir: (dir) ->
		if @snack.dir is dir
			this.step()
		else 
			@snack.changeDir(dir)

	init: () ->
		for point in @snack.list
			@map[point.x][point.y] = 1

		for i in [0..@col + 1]
			@map[0][i] = @map[@row + 1][i] = 100
		for i in [1..@row]
			@map[i][0] = @map[i][@col + 1] = 100
		
		container = document.createElement("div")
		container.className = "container"

		# score = document.createElement("div")
		# score.className = "score"
		# score.id = "score"
		# container.appendChild(score)

		@list = []

		for i in [0..@row + 1]
			@list[i] = []
			for j in [0..@col + 1]
				node = document.createElement("div")
				node.className = "node-" + @map[i][j]
				node.id = i + "-" + j
				node.style.left = (j - 1) * 16 + "px"
				node.style.top = (i - 1) * 16 + "px"
				container.appendChild(node)
				@list[i][j] = node

		curPoint = @snack.current()
		@list[curPoint.x][curPoint.y].className = "node-1-" + @snack.dir
		
		document.body.appendChild(container)
		this.showFood()
		`window.setTimeout(function(){rect.update()}, SPD)`

	step: () ->
		curPoint = @snack.current()
		nextPoint = @snack.next()
		nextMap = @map[nextPoint.x][nextPoint.y]

		switch nextMap
			when 0
				prePoint = @snack.list.shift()
				@map[prePoint.x][prePoint.y] = 0
				@list[prePoint.x][prePoint.y].className = "node-0" 
			when 1, 100
				alert "Score: " + @snack.len 
				startGame()
				return 1
			when 10
				@snack.len += 1
				this.showFood()			

		@snack.list.push(nextPoint)
		@map[nextPoint.x][nextPoint.y] = 1
		@list[nextPoint.x][nextPoint.y].className = "node-1-" + @snack.dir
		@list[curPoint.x][curPoint.y].className = "node-1"

		return 0

	showFood: () ->
		foodX = Math.round(Math.random() * @row)
		foodY = Math.round(Math.random() * @col)

		while @map[foodX][foodY] 
			foodX = Math.round(Math.random() * @row)
			foodY = Math.round(Math.random() * @col)

		@map[foodX][foodY] = 10
		@list[foodX][foodY].className = "node-10"
		