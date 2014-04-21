Cake.locations = ->
  $('select.country_select').change (event) ->
    select_wrapper = $('#states_wrapper')

    $('select', select_wrapper).attr('disabled', true)

    country_code = $(this).val()
    model_name = $(this).attr('name').split('[')[0]

    url = "/locations/subregion_options?parent_region=#{country_code}&model=#{model_name}"
    select_wrapper.load(url)