Cake.videos ?= {}

class Video
  constructor: (args) ->
    @provider = args.provider
    @id = args.videoId
    @autoshow = args.autoshow
    @modal = $(args.modal)

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

  onModalHidden: ->
    self = this
    @modal.on "hidden.bs.modal", (e) ->
      self.stopVideo()
    return

class YoutubeVideo extends Video
  constructor: (args) ->
    super args

    @player = new YT.Player("video_placeholder",
      height: "400"
      width: "100%"
      videoId: @id
    )
    return

  playVideo: ->
    @player.playVideo()
    return

  stopVideo: ->
    @player.stopVideo()
    return

Cake.videos.init = (options)->
  if options.provider is 'youtube'
    video = new YoutubeVideo(options)
  if options.provider is 'vimeo'
    video = new VimeoVideo(options)
  return

