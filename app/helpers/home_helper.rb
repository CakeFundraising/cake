module HomeHelper
  def home_tab_button(model, text)
    link_to home_load_tab_path(model: model), data:{toggle: 'remoteTab', target: "#pop-#{underscore_to_dash(model.to_s).pluralize}"}, id:"tab-#{underscore_to_dash(model.to_s).pluralize}" do
      content_tag(:span, text)
    end
  end
end
