Cake.videos ?= {}

class Video
  constructor: (args) ->
    @modal = $(args.modal)
    @embedIn = args.embedIn

    @provider = args.provider
    @id = args.videoId
    @width = args.width
    @height = args.height

    @autoshow = args.autoshow

    @onModalShown()
    @onModalHidden()
    return

  showModal: ->
    @modal.modal('show')
    return

  hideModal: ->
    @modal.modal('hide')
    return

  onModalShown: ->
    self = this
    @modal.on "shown.bs.modal", (e) ->
      self.playVideo()
      return
    return

  onModalHidden: ->
    self = this
    @modal.on "hidden.bs.modal", (e) ->
      self.stopVideo()
      return
    return

class YoutubeVideo extends Video
  constructor: (args) ->
    super args

    @player = new YT.Player(@embedIn || "video_placeholder",
      height: @height || "400"
      width: @width || "100%"
      videoId: @id
    )
    return

  playVideo: ->
    @player.playVideo()
    return

  stopVideo: ->
    @player.stopVideo()
    return

#Initialize Youtube API
Cake.videos.youtubeApi = ->
  tag = document.createElement("script")
  tag.src = "https://www.youtube.com/iframe_api"

  firstScriptTag = document.getElementsByTagName("script")[0]
  firstScriptTag.parentNode.insertBefore tag, firstScriptTag
  return

#Init function
Cake.videos.init = (options)->
  if options.provider is 'youtube'
    new YoutubeVideo(options)
  if options.provider is 'vimeo'
    new VimeoVideo(options)
  return

#Other functions
Cake.videos.autoshow = ->
  $('#video_modal').modal('show') if Cake.videos.autoshow_setting
  return

Cake.videos.restartOnModalHidden = (modal_id)->
  $(modal_id).on "hidden.bs.modal", (e) ->
    $(modal_id + " iframe").attr "src", $(modal_id + " iframe").attr("src")
    return
  return

