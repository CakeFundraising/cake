# ready = ->
#   $('form.fundraiser, form.campaign').fileupload
#     dataType: 'script'
#     add: (e, data) ->
#       types = /(\.|\/)(gif|jpe?g|png|mov|mpeg|mpeg4|avi)$/i
#       file = data.files[0]
#       if types.test(file.type) || types.test(file.name)
#         data.context = $($.parseHTML(tmpl("template-upload", file))[1])
#         $(this).append(data.context)
#         data.submit()
#       else
#         alert("#{file.name} is not a gif, jpg or png image file")
#     progress: (e, data) ->
#       if data.context
#         progress = parseInt(data.loaded / data.total * 100, 10)
#         data.context.find('.bar').css('width', progress + '%')

# $(document).ready(ready)
# $(document).on('page:load', ready)