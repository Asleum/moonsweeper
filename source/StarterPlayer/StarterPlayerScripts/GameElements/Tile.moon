--- Class that represents one single MineSweeper regular tile (with no mine on it)
-- @classmod Tile

TextPart = require script.Parent\WaitForChild "TextPart"

-- Using the 'extends' keyword, we make Tile inherit from the TextPart class
class Tile extends TextPart

  --- Instanciates a mine
  -- @tparam Board board the Board instance containing this tile
  -- @tparam number x the x position of the tile in the board
  -- @tparam number y the y position of the tile in the board
  new: (board, x, y) =>
    --- True if the tile has already been clicked on
    -- @field Activated boolean
    @Activated = false
    --- Reference to the Board containing this tile
    -- @field Board `Board`
    @Board = board
    --- X position of the tile in the board
    -- @field XPosition number
    @XPosition = x
    --- Y position of the tile in the board
    -- @field YPosition number
    @YPosition = y

    size = Vector3.new 4.5, 2, 4.5
    location = (CFrame.new board.Position + Vector3.new x*5, 0, y*5)*CFrame.Angles 0, -math.pi/2, 0
    -- The 'super' function is the corresponding method (here: new) inside the parent class (here:
    -- TextPart). In other word, we're calling TextPart.new here
    super size, location
    -- This will call TextPart's RegisterClick method, since there is no RegisterClick method
    -- it will be executed from the parent class TextPart
    @RegisterClick (-> @Activate!), (-> @ToggleFlag!)

  --- Called when the tile is clicked. Reveal it and prevent clicking on it again.
  Activate: =>
    return if @Activated -- You can collapse if statements with one line like so
    @Activated = true
    @UnregisterClick!
    @Reveal!

  --- Display the number of neighboring mines. If 0, reveal neighboring tiles.
  Reveal: =>
    -- This is a TextPart field too. Hurray for inheritance!
    @Part.BrickColor = BrickColor.new "Light stone grey"

    -- Count neighboring mines
    neighboringMines = 0
    -- We're using our custom iterator defined in Board.TileNeighborsIterator to loop over neighbors
    for tile in @Board\TileNeighborsIterator @ -- Remember, @ is the current instance, or self.
      neighboringMines += 1 if tile.__class.__name == "Mine"

    -- If no neighboring mine, reveil neighbors
    if neighboringMines == 0
      for tile in @Board\TileNeighborsIterator @
        tile\Activate!
    else
      @Label.Text = neighboringMines
      @Label.TextColor3 = Color3.fromHSV neighboringMines/8, 1, .75

  --- Toggle the flag on this tile. Called when right-clicking on the tile.
  ToggleFlag: =>
    @Flagged = not @Flagged
    if @Flagged then
      @Label.Text = "*Flag*" -- Look I'm not an artist ok?
      @Board.FlagsCount += 1
    else
      @Label.Text = ""
      @Board.FlagsCount -= 1
    @Board\UpdateMinesCounter!
