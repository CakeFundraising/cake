module MetaHelper
	def display_meta(title, description, keywords, og)
		if description.nil?
			description = "Check out Cake Fundraising for nonprofits and charities. Cake Fundraising is donation per click fundraising, you click on sponsor logos and they donate to charity for you! Now you can contribute to your favorite causes for free! Set up a Cake Fundraising campaign for your nonprofit today! Add It's 100% free!"
		end
		if og.nil?
			og = {title: "Cake Fundraising - 100% Free, Donation Per Click Fundraising for Good Causes.", image: "/images/cake_fb.jpg", description: "Check out Cake Fundraising for nonprofits and charities. Cake Fundraising is donation per click fundraising, you click on sponsor logos and they donate to charity for you! Now you can contribute to your favorite causes for free! Set up a Cake Fundraising campaign for your nonprofit today! Add It's 100% free!", url: request.original_url}
		end
		content_tag(:span, class: 'meta') do
			meta title: title,
				description: description,
				keywords: keywords,
				og: og
		end
	end
end
