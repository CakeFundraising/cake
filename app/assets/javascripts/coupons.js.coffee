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

  $('.formtastic.coupon').validate(
    errorElement: "span"
  )
  return

