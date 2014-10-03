module MetaHelper
	def display_meta(title, og=nil, description=nil, keywords=nil)
		description = t('application.meta.description') if description.nil?
		
		og = {
			title: t('application.meta.og.title'), 
			image: image_path("cake_fb.jpg"), 
			url: request.original_url, 
			description: t('application.meta.description') 
		} if og.nil?

		content_tag(:span, class: 'meta') do
			meta title: title, description: description, keywords: keywords, og: og
		end
	end
end
