module MetaHelper
	def display_meta(title, og=nil, description=nil, keywords=nil)
		content_tag(:span, class: 'meta') do
			set_meta_tags :description => t('application.meta.description') if description.nil?
			set_meta_tags :keywords => t('application.meta.keywords') if keywords.nil?
			set_meta_tags :og => {
				title: t('application.meta.og.title'), 
				image: image_url("fb_share.png"), 
				url: request.original_url, 
				description: t('application.meta.description') 
			} if og.nil?

			set_meta_tags :title => title if !title.nil?
			set_meta_tags :description => description if !description.nil?
			set_meta_tags :keywords => keywords if !keywords.nil?
			set_meta_tags :og => og if !og.nil?
		end
	end
end
