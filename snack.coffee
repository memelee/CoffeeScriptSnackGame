ROW = 30
COL = 40
SPD = 500
LEN = 5

window.onload = () ->
	rect = new Rect(ROW, COL, LEN)
	rect.init()
	`window.setInterval(function(){rect.update()}, SPD)`

	document.onkeydown = (e) ->
		e = e || event
		switch e.keyCode
			when 37 then rect.snack.changeDir(4)
			when 38 then rect.snack.changeDir(1)
			when 39 then rect.snack.changeDir(2)
			when 40 then rect.snack.changeDir(3)

class Snack
	constructor: (@len) ->
		@dir = 2
		@list = []
		for i in [1..@len]
			@list.push({ x: 1, y: i	})

	next: () ->
		point = @list[@list.length - 1]
		switch @dir
			when 1 then return { x: point.x - 1, y: point.y }
			when 2 then return { x: point.x, y: point.y + 1 }
			when 3 then return { x: point.x + 1, y: point.y }
			when 4 then return { x: point.x, y: point.y - 1 }

	changeDir: (@dir) ->

class Rect
	constructor: (@row, @col, len) ->
		@snack = new Snack(len)
		@map = []
		for i in [1..@row]
			@map[i] = []
			for j in [1..@col]
				@map[i][j] = 0

	update: () ->
		nextPoint = @snack.next()

		if @map[nextPoint.x][nextPoint.y] == 0
			prePoint = @snack.list.shift()
			@map[prePoint.x][prePoint.y] = 0
			@list[prePoint.x][prePoint.y].className = "node-0"
		else if @map[nextPoint.x][nextPoint.y] == 1
			alert "Failed"
		else if @map[nextPoint.x][nextPoint.y] == 10
			@snack.len += 1
			this.showFood()

		@snack.list.push(nextPoint)
		@map[nextPoint.x][nextPoint.y] = 1
		@list[nextPoint.x][nextPoint.y].className = "node-1"

	changeDir: (dir) ->
		snack.changeDir(dir)

	init: () ->
		for point in @snack.list
			@map[point.x][point.y] = 1

		container = document.createElement("div")
		container.className = "container"

		@list = []

		for i in [1..@row]
			@list[i] = []
			for j in [1..@col]
				node = document.createElement("div")
				node.className = "node-"+@map[i][j]
				node.id = i+"-"+j
				node.style.left = (j-1)*16+"px"
				node.style.top = (i-1)*16+"px"
				container.appendChild(node)
				@list[i][j] = node

		document.body.appendChild(container)
		this.showFood()

	showFood: () ->
		foodX = Math.round(Math.random() * @row)
		foodY = Math.round(Math.random() * @col)

		while @map[foodX][foodY] 
			foodX = Math.round(Math.random() * @row)
			foodY = Math.round(Math.random() * @col)

		@map[foodX][foodY] = 10
		@list[foodX][foodY].className = "node-10"
		