--- Class that represents a part with some text displayed on it. It can also be clicked.
-- @classmod TextPart

MouseInputsManager = require script.Parent.Parent\WaitForChild "MouseInputsManager"

class TextPart

  new: (size, location) =>
    --- Roblox part corresponding to this tile
    -- @field Part Instance
    @Part
    --- Roblox TextLabel displayed on the top of this tile
    -- @field Label Instance
    @Label

    -- I like to define every fields at the beginning of the 'new' method, even when they're empty
    -- because having doc comments in the middle of the scripts looks weird.

    -- Kids, here's how you create a Roblox instance Moonscript style.
    -- Introducing: the 'with' statement
    @Part = with Instance.new "Part"
      .Anchored = true
      .TopSurface = "Smooth"
      .BottomSurface = "Smooth"
      .Size = size
      .CFrame = location
      .Parent = game.Workspace

    -- You can name the instance you're working with if you need to
    with surfaceGui = Instance.new("SurfaceGui")
      .Face = Enum.NormalId.Top
      .CanvasSize = 25*Vector2.new size.z, size.x
      @Label = with Instance.new "TextLabel" -- You can even nest them!
        .Size = UDim2.new 1, 0, 1, 0
        .BackgroundTransparency = 1
        .TextScaled = true
        .Text = ""
        .Parent = surfaceGui
      .Parent = @Part

  --- Set functions to be called when the part is left or right clicked
  -- @tparam function leftClickCallback what to execute when left clicked
  -- @tparam function rightClickCallback what to execute when right clicked
  RegisterClick: (leftClickCallback, rightClickCallback) =>
    MouseInputsManager.BindPartToClick @Part, leftClickCallback, rightClickCallback

  --- Unbind clicks from the part
  UnregisterClick: =>
    MouseInputsManager.UnbindPartFromClick @Part

  --- Clear this item
  Destroy: =>
    @UnregisterClick! -- This is important. Never forget about memory leaks, kids.
    @Part\Destroy!
