--- Static class for registering and reacting to mouse inputs
-- @classmod MouseInputsManager

class MouseInputsManager

  --- Initialize fields and start reacting to clicks
  -- @function Initialize
  @Initialize: ->
    -- Notice the @ before the method's name. This will make Initialize a static method, or a class
    -- function, allowing us to call it without instanciating this class! Also note that we're not
    -- using fat arrows (=>) anymore here, since there is no class instance. Instead, '@' will refer
    -- to the whole class here.

    --- Dictionary that associates a Roblox part with a function to be executed once the part is
    -- clicked
    -- @field LeftClickHandlers {Instance, function}
    @LeftClickHandlers = {}
    --- Same as above, but for right clicks
    -- @field RightClickHandlers {Instance, function}
    @RightClickHandlers = {}
    --- Reference to the player's mouse
    -- @field Mouse Instance
    @Mouse = game.Players.LocalPlayer\GetMouse!
    --- A Roblox SelectionBox that is shown over any hovered activable part
    -- @field SelectionBox Instance
    @SelectionBox

    -- Since the above fields are defined in a static method, they are static too and can be
    -- accessed directly from the MouseInputsManager class without instanciating it.

    @SelectionBox = with Instance.new "SelectionBox"
      .Color3 = Color3.new!
      .Parent = game.Players.LocalPlayer.PlayerGui

    -- On every click, check if there is a handler associated with the clicked part
    @Mouse.Button1Down\Connect -> if handler = @LeftClickHandlers[@Mouse.Target] then handler!
    @Mouse.Button2Down\Connect -> if handler = @RightClickHandlers[@Mouse.Target] then handler!
    @Mouse.Move\Connect @UpdateSelectionBox

    print "Now registering mouse inputs"

  --- Set some functions to be executed once a part is left or right clicked
  -- @function BindPartToClick
  -- @tparam Instance part the part that will trigger the functions when clicked
  -- @tparam function leftClickCallback what to execute when the part is left clicked
  -- @tparam function rightClickCallback what to execute when the part is right clicked
  @BindPartToClick: (part, leftClickCallback, rightClickCallback) ->
    @LeftClickHandlers[part] = leftClickCallback
    @RightClickHandlers[part] = rightClickCallback
    -- When calling a static method it is important to add a dot after the @. Otherwise, a 'self'
    -- argument will automatically be passed
    @.UpdateSelectionBox!

  --- Make the given part not react to clicks anymore
  -- @function UnbindPartFromClick
  -- @tparam Instance part the part to unbind
  @UnbindPartFromClick: (part) ->
    @LeftClickHandlers[part] = nil
    @RightClickHandlers[part] = nil
    @.UpdateSelectionBox!

  --- Update the selection box's adornee to be the hovered clickable part, if applicable
  -- @function UpdateSelectionBox
  @UpdateSelectionBox: ->
    if @LeftClickHandlers[@Mouse.Target] or @RightClickHandlers[@Mouse.Target]
      @SelectionBox.Adornee = @Mouse.Target
    else
      @SelectionBox.Adornee = nil
