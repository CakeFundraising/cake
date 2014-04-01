Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "iBrgyZ3KHCdWSuiuu08qQ", "6Fy4KkYW7nM1PKmt8hxOgXgf7ygSPNx3HTicFPnHJGY"
  provider :facebook, '637877232912071', 'f7e3e166815beed10a02056b6e4bd30b'
  provider :linkedin, '75adconoxd5t9f', 'ZzC4CUKTUBU5YUb4'
end