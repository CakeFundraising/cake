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

Cake.pledge_levels.levels_form.levels = ->
  #HTML present elements
  @container = $("#sponsor_categories")
  base_level =
    $object: $('[data-position="0"]')
    position: -1
    dataPosition: 0

  #Items array
  items = new Array()
  items[0] = $("#sponsor_categories .nested-fields[data-position='1']") if $("#sponsor_categories .nested-fields[data-position='1']").length > 0
  items[1] = $("#sponsor_categories .nested-fields[data-position='2']") if $("#sponsor_categories .nested-fields[data-position='2']").length > 0

  # First item is middle level
  first_item =
    position: 0
    dataPosition: 1
    $object: ->
      return items[0]

  # Last item is top level
  last_item =
    position: 1
    dataPosition: 2
    $object: ->
      return items[1]

  # Main functions
  @increment_items = ->
    @container.on "cocoon:after-insert", (e, insertedItem) ->
      items_last_item = items[items.length-1] || base_level.$object
      #set inserted item position
      Cake.pledge_levels.levels_form.set_position(insertedItem, (items.length+1) )
      #set inserted item min value
      Cake.pledge_levels.levels_form.set_min_value(insertedItem, items_last_item)
      #update inserted item min value when previous max value updates
      Cake.pledge_levels.levels_form.update_min_value(insertedItem, items_last_item)
      
      #update items array
      items.push(insertedItem)
      return
    return
  @decrement_items = ->
    @container.on "cocoon:after-remove", (e, removedItem) ->
      removedPosition = parseInt(removedItem.attr('data-position'))

      #update last item's position if removing first item (not needed when removing last item.. first item remains in same position :) )
      if first_item.$object() and last_item.$object()
        if first_item.$object().length > 0 and last_item.$object().length > 0
          
          if first_item.dataPosition is removedPosition
            # set last item position
            Cake.pledge_levels.levels_form.set_position(last_item.$object(), 1)
            # set last item min value
            Cake.pledge_levels.levels_form.set_min_value(last_item.$object(), base_level.$object )
            # update last item min value when base item's max value updates
            Cake.pledge_levels.levels_form.update_min_value(last_item.$object(), base_level.$object )
      
      #remove item from items
      removedArrayPosition = removedPosition - 1
      items.splice(removedArrayPosition, 1)
      #remove data position in order to be re-added to items array      
      removedItem.removeAttr('data-position')
      return
    return

  #Public functions
  @items = ->
    return items
  @base_level = ->
    return base_level
  @first_item = ->
    return first_item
  @last_item = ->
    return last_item

  @increment_items()
  @decrement_items()

  return

Cake.pledge_levels.levels_form.init = ->
  Cake.pledge_levels.levels_form.levels()
  return