Cake.clicks ?= {}

Cake.clicks.after_click = ->
  click_modal = $('#contribute_modal')
  contribute_form = click_modal.find(".formtastic.click")
  visit_sponsor_button = click_modal.find('#visit_sponsor_link')

  visit_sponsor_button.hide()

  contribute_form.submit (e)->
    e.preventDefault();
    this.submit();

    click_modal.find(".modal-body").html("<div class='lead'>Your click has already been counted, but please visit our sponsor again!</div>")
    $('#contribute_link').hide()
    visit_sponsor_button.show()
    return
  return