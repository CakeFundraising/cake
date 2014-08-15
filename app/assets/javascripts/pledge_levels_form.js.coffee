Cake.pledge_levels.levels_form ?= {}

Cake.pledge_levels.levels_form.set_position = (item, position)->
  item.attr('data-position', position)
  item.find('.input_position').val(position)
  return

#Set min value input
Cake.pledge_levels.levels_form.set_min_value = (insertedItem, previousItem)->
  max_value = previousItem.find('.max_value')
  min_value_input = insertedItem.find('.input_min_value')
  min_value_span = insertedItem.find('.min_value')

  new_val = parseInt(max_value.val()) + 1

  min_value_input.val(new_val)
  min_value_span.html('$'+new_val)
  return

#update min value input
Cake.pledge_levels.levels_form.update_min_value = (insertedItem, previousItem)->
  max_value = previousItem.find('.max_value')
  min_value_input = insertedItem.find('.input_min_value')
  min_value_span = insertedItem.find('.min_value')

  max_value.change ->
    val = parseInt($(this).val()) + 1
    min_value_input.val(val)
    min_value_span.html('$'+val)
    return

  return

Cake.pledge_levels.levels_form.after_insert = (insertedItem, levels) ->
  previous_position = $.inArray(insertedItem, levels.items)

  if previous_position is 0
    previousItem = levels.list.last.$object
  if previous_position is 1
    previousItem = levels.items[previous_position-1]
  
  #set inserted item position
  Cake.pledge_levels.levels_form.set_position(insertedItem, (previous_position+1) )
  #set inserted item min value
  Cake.pledge_levels.levels_form.set_min_value(insertedItem, previousItem)
  #update inserted item min value when previous max value updates
  Cake.pledge_levels.levels_form.update_min_value(insertedItem, previousItem)
  return

Cake.pledge_levels.levels_form.after_remove = (removedItem, item, levels) ->
  second_level = levels.items[0].attr('data-position') 
  first_level = levels.items[1].attr('data-position') if levels.items[1] isnt undefined

  if second_level isnt undefined and removedItem.attr('data-position') is second_level
    if first_level isnt undefined and item.attr('data-position') is first_level
      # set inserted item position
      Cake.pledge_levels.levels_form.set_position(item, 1)
      # set inserted item min value
      Cake.pledge_levels.levels_form.set_min_value(item, levels.list.last.$object )
      # update inserted item min value when previous max value updates
      Cake.pledge_levels.levels_form.update_min_value(item, levels.list.last.$object )
  
  return

#pledge levels object
Cake.pledge_levels.levels_form.levels = ->
  items = $("#sponsor_categories .nested-fields[data-position='1'], #sponsor_categories .nested-fields[data-position='2']") || new Array()
  #items = items.map (item) -> $(item)

  if items.length > 0
    items[0] = $(items[0])
    items[1] = $(items[1])

  levels =
    items: items

  levels =
    container: $("#sponsor_categories")
    items: items
    reload: ->
      return this
    increment_items: ->
      this.container.on "cocoon:after-insert", (e, insertedItem) ->
        #update items array
        levels.items.push(insertedItem)
        
        Cake.pledge_levels.levels_form.after_insert(insertedItem, levels)
        return
      return
    decrement_items: ->
      this.container.on "cocoon:after-remove", (e, removedItem) ->
        #update remaining items's position
        $.each levels.items, (i, v) ->
          Cake.pledge_levels.levels_form.after_remove(removedItem, v, levels)
          return

        #remove item from items
        levels.items = levels.items.filter (item) -> $(item).attr('data-position') isnt removedItem.attr('data-position')
        return
      return
    list:
      last: 
        $object: $('[data-position="0"]')
        position: 0
        next: this.second
        previous: null
      second:
        $object: ->
          return levels.items[0]
        position: 1
        next: this.first
        previous: this.last
      first:
        $object: ->
          return levels.items[1]
        position: 2
        next: null
        previous: this.second

  levels.increment_items()
  levels.decrement_items()

  return levels

Cake.pledge_levels.levels_form.init = ->
  Cake.pledge_levels.levels_form.levels()
  return