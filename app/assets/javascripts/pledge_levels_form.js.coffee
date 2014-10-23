Cake.pledge_levels.levels_form ?= {}

class PledgeLevel
  constructor: (position, domObject) ->
    @position = position
    @domObject = domObject
    @inputField = @domObject.find('.max_value')
    return

  getDomObject: ->
    return @domObject

  setDomPosition: ->
    @levels = Cake.pledge_levels.levels_form.levels

    index = @levels.indexOf(this)
    @position = index
    #@position = if index is -1 then 0 else index

    #console.log "position: #{@position}"

    @domObject.attr('data-position', @position)
    @domObject.find('.input_position').val(@position)
    return

  setUp: ->
    @setDomPosition()

    if @getNextLevel()
      @setUpNextLevelValue()
      @updateNextLevelValue()
    return

  currentValueOf: (input)->
    return parseInt(input.val()) + 1 || 0

  # Next Level functions
  getNextLevel: ->
    @nextLevel = @levels[@position+1]

    if @nextLevel
      @nextLevelObject = @nextLevel.domObject
      @nextLevelInput = @nextLevelObject.find('.input_min_value')
      @nextLevelSpan = @nextLevelObject.find('.min_value')
    return @nextLevel

  setUpNextLevelValue: (generatorInput)->
    input = generatorInput || @inputField
    val = @currentValueOf(input)

    @nextLevelInput.val(val)
    @nextLevelSpan.html('$'+val)
    return

  updateNextLevelValue: ->
    self = this

    @inputField.keyup ->
      self.setUpNextLevelValue( $(this) )
      return
    return

class PledgeLevelForm
  constructor: ->
    @container = $("#sponsor_categories")

    if @container
      #console.log 'initializeLevels'
      @initializeLevels()
      #console.log 'onLevelAdded'
      @onLevelAdded()
      #console.log 'onLevelRemoved'
      @onLevelRemoved()
      #console.log 'setUpLevels'
      @setUpLevels()
    return

  # Levels functions
  initializeLevels: ->
    levels = new Array()
    levels[0] = new PledgeLevel(0, $('[data-position="0"]') )
    levels[1] = new PledgeLevel(1, $("#sponsor_categories .nested-fields[data-position='1']") ) if $("#sponsor_categories .nested-fields[data-position='1']").length > 0
    levels[2] = new PledgeLevel(2, $("#sponsor_categories .nested-fields[data-position='2']") ) if $("#sponsor_categories .nested-fields[data-position='2']").length > 0
    Cake.pledge_levels.levels_form.levels = @levels = levels
    return

  # Main functions
  setUpLevels: ->
    for level in @levels
      level.setUp()
    return

  onLevelAdded: ->
    self = this
    @container.on "cocoon:after-insert", (e, insertedItem) ->
      #console.log 'insertedItem'
      if insertedItem
        # Create Level for inserted level
        newLevelPosition = self.levels.length
        newLevel = new PledgeLevel(newLevelPosition, insertedItem)
        self.levels.push newLevel

        self.setUpLevels()
      return
    return

  onLevelRemoved: ->
    self = this
    @container.on "cocoon:after-remove", (e, removedItem) ->
      removedPosition = parseInt(removedItem.attr('data-position'))

      #console.log 'removedItem'

      if removedPosition
        #remove level from levels
        removedArrayPosition = removedPosition
        self.levels.splice(removedArrayPosition, 1)

        self.setUpLevels()
        #remove data position in order to be re-added to levels      
        removedItem.removeAttr('data-position')
      return
    return

Cake.pledge_levels.levels_form.init = ->
  Cake.pledge_levels.levels_form.form = null
  Cake.pledge_levels.levels_form.levels = null
  Cake.pledge_levels.levels_form.form = new PledgeLevelForm() if $("#sponsor_categories").length > 0
  return

