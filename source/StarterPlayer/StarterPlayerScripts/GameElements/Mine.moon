--- Class that represents a mine (i.e. activating it will make the player loose)
-- @classmod Mine

Tile = require script.Parent\WaitForChild "Tile"

-- A mine is a Tile, but with different 'Reveal' and 'ToggleFlag' methods
class Mine extends Tile

  -- Note that there's no 'new' method in this class. But since there's one in our parent class
  -- Tile, that one will be called.

  --- Reveal the mine, ending the game
  Reveal: =>
    @Label.Text = "X"
    @Part.BrickColor = BrickColor.new "Bright red"
    @Board\EndGame!

  --- Toggle the flag on this mine
  ToggleFlag: =>
    super! -- This will call Tile.ToggleFlag
    if @Flagged then @Board.CorrectlyFlaggedMines += 1
    else @Board.CorrectlyFlaggedMines -= 1
    @Board\CheckVictory!
