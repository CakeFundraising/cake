Cake.pusher.client = ->
  return new Pusher(Cake.pusher.appKey)

Cake.pusher.campaigns.updateRaised = (campaignId)->
  pusher = Cake.pusher.client()
  channel = pusher.subscribe "campaign_#{campaignId}_raised"

  raisedContainers = $('.raised')
  campaignThermometer = $('.progress.campaign-thermometer .progress-bar')

  channel.bind 'update', (data)->
    raisedContainers.html(data.raised)
    campaignThermometer.css({width: "#{data.campaign_thermometer}%"})

    miniPledgeThermometer = $(".platinum##{data.pledge_id} .progress-bar")
    miniPledgeThermometer.css({width: "#{data.pledge_thermometer}%"})
    return
  return