--- Script that initializes inputs and generates a bunch of Minesweeper boards
-- @module Initializer

-- Some of my comments will start with 3 dashes like the one above, these are ldoc comments that
-- describe classes, methods and fields.

-- When calling functions, parenthesis are entirely optionnal!
print "Initializing..."

-- Here we get our classes from their ModuleScripts.
gameElements = script.Parent\WaitForChild "GameElements"
Board = require gameElements\WaitForChild "Board"
MouseInputsManager = require script.Parent\WaitForChild "MouseInputsManager"

-- MouseInputsManager's Initialize method is static, it can be called directly from the class.
-- The exclamation point is how you call a parameter-less function
MouseInputsManager.Initialize!

-- Spawn our boards. Calling a class as if it were a function is how you instanciate it.
Board 12, 8, 16, Vector3.new 0, 0, -50
Board 8, 6, 8, Vector3.new 70, 0, -45
Board 20, 16, 60, Vector3.new -110, 0, -70

print "Ready!"
-- Hope you enjoyed the ride !
