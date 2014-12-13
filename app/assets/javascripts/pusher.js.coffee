Cake.pusher ?= {}

Cake.pusher.client = ->
  return new Pusher(Cake.pusher.appKey)

Cake.pusher.campaigns ?= {}

Cake.pusher.campaigns.updateRaised = (campaignId)->
  pusher = Cake.pusher.client()
  channel = pusher.subscribe "campaign_#{campaignId}_raised"

  raisedContainers = $('.raised')
  thermometer = $('.progress.campaign-thermometer .progress-bar')

  channel.bind 'update', (data)->
    raisedContainers.html(data.raised)
    thermometer.css({width: "#{data.thermometer}%"})
    return
  return