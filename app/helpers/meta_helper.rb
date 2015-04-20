module MetaHelper
	def display_meta(title)
		content_tag(:span, class: 'meta') do
			meta({title: title})
		end
	end

	#Meta Tags
	def cake_meta_tags
	  tags = {
	    site: t('application.name'), 
	    title: [:title, :site], 
	    description: t('application.meta.description'), 
	    keywords: t('application.meta.keywords'), 
	    og: { 
	      title: t('application.meta.og.title'), 
	      description: t('application.meta.description'),
	      image: image_url('fb_share.png'), 
	      url: request.original_url, 
	    },
	    twitter: {
				card: 'summary',
				site: '@CakeCauses',
				title: t('application.meta.og.title'),
				description: t('application.meta.description'), 
				image: image_url('fb_share.png'), 
				url:request.original_url
			}
	  }
	  metamagic tags
	end

	def campaign_page_meta(campaign)
		tags = {
			title: t('application.meta.og.campaigns.title', fr: campaign.fundraiser),
			og: {
				title: t('application.meta.og.campaigns.title', fr: campaign.fundraiser), 
				image: campaign.shareable_screenshot_url, 
				description: campaign.mission, 
				url: campaign_url(campaign)
			},
			twitter: {
				card: 'summary',
				site: '@CakeCauses',
				title: t('application.meta.og.campaigns.title', fr: campaign.fundraiser),
				description: campaign.mission, 
				image: campaign.shareable_screenshot_url, 
				url: campaign_url(campaign)
			}
		}
		content_tag(:span, class: 'meta') do
			meta tags
		end
	end

	def pledge_page_meta(pledge)
		tags = {
			title: t('application.meta.og.campaigns.title', fr: pledge.fundraiser),
			og: {
				title: t('application.meta.og.campaigns.title', fr: pledge.fundraiser), 
				description: pledge.mission, 
				image: pledge.shareable_screenshot_url, 
				url: pledge_url(pledge)
			},
			twitter: {
				card: 'summary',
				site: '@CakeCauses',
				title: t('application.meta.og.campaigns.title', fr: pledge.fundraiser),
				description: pledge.mission, 
				image: pledge.shareable_screenshot_url, 
				url: pledge_url(pledge)
			}
		}
		content_tag(:span, class: 'meta') do
			meta tags
		end
	end

	def fr_page_meta(fr)
		tags = {
			title: t('application.meta.og.fundraisers.title', fr: fr),
			og: {
				title: t('application.meta.og.fundraisers.title', fr: fr), 
				description: fr.mission, 
				image: fr.picture.avatar_path, 
				url: fundraiser_url(fr)
			},
			twitter: {
				card: 'summary',
				site: '@CakeCauses',
				title: t('application.meta.og.fundraisers.title', fr: fr),
				description: fr.mission, 
				image: fr.picture.avatar_path, 
				url: fundraiser_url(fr)
			}
		}
		content_tag(:span, class: 'meta') do
			meta tags
		end
	end

	def sp_page_meta(sp)
		tags = {
			title: t('application.meta.og.sponsors.title', sp: sp),
			og: {
				title: t('application.meta.og.sponsors.title', sp: sp), 
				description: sp.mission, 
				image: sp.picture.avatar_path, 
				url: sponsor_url(sp)
			},
			twitter: {
				card: 'summary',
				site: '@CakeCauses',
				title: t('application.meta.og.sponsors.title', sp: sp),
				description: sp.mission, 
				image: sp.picture.avatar_path, 
				url: sponsor_url(sp)
			}
		}
		content_tag(:span, class: 'meta') do
			meta tags
		end
	end

end
