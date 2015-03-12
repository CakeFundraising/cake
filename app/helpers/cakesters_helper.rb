module CakestersHelper
  def commissions_percentage
    Cakester::COMMISSIONS.map{|v| ["#{v}%", v]}
  end

  def destroy_cakester_button(campaign_cakester)
    if campaign_cakester.cakester_request.present? and campaign_cakester.cakester_request.accepted?
      link_to delete_cakester_request_path(campaign_cakester.cakester_request), data: {confirm: 'Are you sure you want to terminate this partnership?'}, class:'btn btn-sm btn-danger' do
        content_tag(:span, nil, class:'glyphicon glyphicon-trash')
      end
    else
      link_to campaign_cakester, method: :delete, data: {confirm: 'Are you sure you want to remove this Cakester?'}, class:'btn btn-sm btn-danger' do
        content_tag(:span, nil, class:'glyphicon glyphicon-trash')
      end
    end
  end

end
