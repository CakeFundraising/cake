module Cake
  APPLICATION_FEE = 0.050
  STRIPE_FEE = 0.029

  DISQUS_SHORTNAME = ENV["DISQUS_SHORTNAME"]
  DISQUS_CAMPAIGNS_CATEGORY_ID = ENV["DISQUS_CAMPAIGNS_CATEGORY_ID"]
  DISQUS_PLEDGES_CATEGORY_ID = ENV["DISQUS_PLEDGES_CATEGORY_ID"]
  IFRAME_HOST = ENV['CAKE_IFRAME_HOST']

  ASYNC_CAMPAIGN_JS = [
    "//f.vimeocdn.com/js/froogaloop2.min.js", 
    "//js.pusher.com/2.2/pusher.min.js", 
    "https://checkout.stripe.com/checkout.js",
    "//s7.addthis.com/js/300/addthis_widget.js#async=1&pubid=ra-542a2ea07b4b6c5d"
  ]
end