module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /^#{capture_model}(?:'s)? registration page$/                    
      new_user_registration_path
      
    when /^sign in page$/  
      new_user_session_path

    when /^get started page$/  
      home_get_started_path

    when /^settings page$/
      dashboard_settings_users_path 

    when /^account settings page$/
      account_path

    #pledges
    when /^pledge invitation page$/
      pledge_campaign_path(@campaign)

    when /^pledge wizard (.*?) page$/
      path_components = $1.split(/\s+/)
      send(path_components.push('pledge').push('path').join('_').to_sym, @pledge)

    when /^pledge's page$/
      pledge = @pledge || model(:pledge)
      pledge_path(pledge)

    when /^new pledge page$/
      campaign = @campaign || model(:campaign) || @pledge_request.campaign
      new_pledge_path(campaign: campaign.id)

    when /^new pledge request page$/
      sponsor = @sponsor || model(:sponsor)
      new_pledge_request_path(sponsor_id: sponsor.id)

    when /^increase pledge page$/
      increase_pledge_path(@pledge)
    
    #campaign
    when /^campaign wizard (.*?) page$/
      path_components = $1.split(/\s+/)
      send(path_components.push('campaign').push('path').join('_').to_sym, @campaign)

    when /^campaign's page$/
      campaign = @campaign || model(:campaign) || @not_launched_campaign
      campaign_path(campaign)
      

    #Sponsor
    when /^sponsor's page$/
      sponsor_path(model(:sponsor))

    when /^sponsor pledge requests page$/
      sponsor_pledge_requests_path

    #Fundraiser
    when /^fundraiser bank account page$/
      bank_account_fundraiser_path(model(:fundraiser))

    when /^fundraiser pending pledges page$/
      fundraiser_pending_pledges_path

    when /^new #{capture_model}(?:'s)? page$/
      path_components = $1.split(/\s+/)
      send(path_components.unshift('new').push('path').join('_').to_sym)
      
    # the following are examples using path_to_pickle

    when /^#{capture_model}(?:'s)? page$/                           # eg. the forum's page
      path_to_pickle $1

    when /^#{capture_model}(?:'s)? #{capture_model}(?:'s)? page$/   # eg. the forum's post's page
      path_to_pickle $1, $2

    when /^#{capture_model}(?:'s)? #{capture_model}'s (.+?) page$/  # eg. the forum's post's comments page
      path_to_pickle $1, $2, :extra => $3                           #  or the forum's post's edit page

    when /^#{capture_model}(?:'s)? (.+?) page$/                     # eg. the forum's posts page
      path_to_pickle $1, :extra => $2                               #  or the forum's edit page

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))


    else
      begin
        page_name =~ /(.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)