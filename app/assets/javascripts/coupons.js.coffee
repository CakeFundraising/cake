Cake.coupons ?= {}

Cake.coupons.tos_toggle = ->
  checkbox = $('#coupons .boolean.checkbox input[type="checkbox"]')
  standard_tos = $('#std_tos_text').val()

  checkbox.change ->
    tos_text_area = $(this).closest('.nested-fields').find('textarea').last()

    if $(this).prop("checked")
      tos_text_area.val(standard_tos)
    else
      tos_text_area.val('')
    return

  return

Cake.coupons.tos = ->
  Cake.coupons.tos_toggle()
  
  $("#coupons").on "cocoon:after-insert", (e, insertedItem) ->
      Cake.coupons.tos_toggle()
      #Cake.crop.init(insertedItem.find('.cloudinary-fileupload'))
    return
  return

Cake.coupons.validation = ->
  jQuery.validator.addClassRules
    coupon_title:
      required: true
    coupon_expires_at:
      required: true
    coupon_description:
      required: true
    coupon_merchandise_categories:
      required: true
    coupon_terms_conditions:
      required: true      
    max_value:
      required: true
      number: true
      minStrictPledgeLevels: true

  $('.formtastic.pledge').validate(
    errorElement: "span"
  )
  return