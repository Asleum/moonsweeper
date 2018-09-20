--- Class that represents a board of Minesweeper
-- @classmod Board

Tile = require script.Parent\WaitForChild "Tile"
Mine = require script.Parent\WaitForChild "Mine"
TextPart = require script.Parent\WaitForChild "TextPart"
-- Be wary with 'require's, having too many of them is tedious and will cause problems (i.e. case
-- when two modules require eachother). What I do in big projects is I have one script that requires
-- everything once and puts the modules' return value inside everything as local variables using
-- Lua's setfenv.

class Board

  --- Instanciates a new board
  -- @tparam number width how many tiles make up the board's width
  -- @tparam number height how many tiles make up the board's height
  -- @tparam number mines how many mines are to be placed in the board
  -- @tparam Vector3 position 3D position of the board's top-left corner
  new: (width, height, mines, position) =>
    --- Width of the board, in tiles
    -- @field Width number
    @Width = width
    --- Height of the board, in tiles
    -- @field Height number
    @Height = height
    --- Number of mines in this board
    -- @field Mines number
    @Mines = mines
    --- Position of this board in the workspace
    -- @field Position Vector3
    @Position = position
    --- If true, then stop the game
    -- @field GameEnded boolean
    @GameEnded = false
    --- Count how many mines have been correctly flagged
    -- @field CorrectlyFlaggedMines number
    @CorrectlyFlaggedMines = 0
    --- Keeps track of the amount of flags in the board
    -- @field FlagsCount number
    @FlagsCount = 0
    --- Part that display the amount of mines remaining
    -- @field MinesCounter `TextPart`
    @MinesCounter
    --- Part that will reset the game when clicked
    -- @field Resetter `TextPart`
    @Resetter
    --- List of all the tiles that make up this board
    -- @field Tiles {`Tile`}
    @Tiles = {}

    -- The 'new' method is particular, it is called each time your class is instanciated. This is
    -- where you should define your fields.
    -- In case you're wondering, this @ symbol that's basically everywhere is an alias for self.

    -- Create the reset 'button'
    resetterSize = Vector3.new 5, 3, 10
    resetterLocation = (CFrame.new position + Vector3.new 8, .75, -3)
    resetterAngle = CFrame.Angles 0, -math.pi/2, -math.pi/4
    @Resetter = TextPart resetterSize, resetterLocation*resetterAngle
    @Resetter.Label.Text = "Click here to reset game"
    @Resetter\RegisterClick -> @ResetGame! -- The '->' symbol defines a new function

    -- Create the mines number display
    @MinesCounter = TextPart resetterSize, (resetterLocation + Vector3.new 12, 0, 0)*resetterAngle
    @MinesCounter.Label.Text = "Mines left: 0"

    -- Everything has been initialized, now create the board itself.
    @PrepareBoard!

  --- Spawns the board's tiles
  PrepareBoard: =>
    -- First, we need to generate our mine's positions
    generator = Random.new!
    minesPositions = {} -- This is a set that will hold the chosen positions
    for i = 1, @Mines
      while true -- We need to pick a new position until we get one that's not been picked before
        -- This generates a random position and hash it to a string
        minePos = "#{generator\NextInteger 1, @Width};#{generator\NextInteger 1, @Height}"
        if not minesPositions[minePos]
          minesPositions[minePos] = true
          break

    -- Fills Tiles, which is a 2D array containing instances of Tile and Mine
    for y = 1, @Height
      row = {}
      for x = 1, @Width
        if minesPositions["#{x};#{y}"]
          row[x] = Mine @, x, y, @Position -- Instanciate a Mine
        else
          row[x] = Tile @, x, y, @Position -- Instanciate a Tile
      @Tiles[y] = row

    @UpdateMinesCounter!

  --- Resets all the boards's field and regenerate the tiles. This is called when the reset part
  -- is clicked.
  ResetGame: =>
    -- Clean up tiles
    for y = 1, @Height
      -- If a block contains only one statement, you can collapse it in a single line like so
      tile\Destroy! for tile in *@Tiles[y]
    -- Reset fields
    @Tiles = {}
    @GameEnded = false
    @FlagsCount = 0
    @CorrectlyFlaggedMines = 0
    -- Re-create new tiles
    @PrepareBoard!

  --- Reveal all the tiles
  -- @tparam boolean revealMines if true, mines will also be revealed
  EndGame: (revealMines=true) =>
    return if @GameEnded
    @GameEnded = true
    for row in *@Tiles
      for tile in *row
        -- This is how you check an instance's class
        tile\Activate! if tile.__class.__name != "Mine" or revealMines

  --- Makes an iterator that goes over a given tile's neighbors
  -- @tparam Tile tile the tile we want to get the neighbors of
  -- @treturn function an iterator for the tile's neighbors
  TileNeighborsIterator: (tile) =>
    startX = tile.XPosition - 1
    startY = tile.YPosition - 1
    i = 0
    -- In Lua, an iterator is a function that returns whatever you want to iterate over when called.
    -- It can be used in 'for ... in ...' statements.
    iterator = ->
      -- Note that we use either '->' or '=>' to define functions. The difference is that '=>'
      -- includes a 'self' argument and must be called with an '\', which allows us to use @ in the
      -- function. When you define a method that needs to reference the current instance, use '=>',
      -- otherwise use '->'
      if i < 9
        x, y = startX + i%3, startY + math.floor i/3
        i += 1
        -- When defining local variables like below, there's no 'local' keyword. That's because
        -- all variables are local by default.
        isMiddle = x == tile.XPosition and y == tile.YPosition -- The calling tile is not a neighbor
        xValid = x >= 1 and x <= @Width -- Check if we're in the board's boundaries
        yValid = y >= 1 and y <= @Height
        -- Returning iterator! if a condition isn't met is a way to skip an iteration
        return if xValid and yValid and not isMiddle then @Tiles[y][x] else iterator!
    iterator -- In Moonscript, the last statement is always returned

  --- Makes the MinesCounter reflect the amount of flags placed
  UpdateMinesCounter: =>
    @MinesCounter.Label.Text = "Mines left: #{@Mines - @FlagsCount}"

  --- Checks if the last mine has been flagged, and stop the game it it's the case
  CheckVictory: =>
    if @CorrectlyFlaggedMines == @Mines
      @EndGame false
      @MinesCounter.Label.Text = "You won!"
