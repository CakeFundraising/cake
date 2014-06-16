module SearchesHelper
  def search_parameters_hidden_fields
    request.query_parameters
      .reject {| key, value | %w[utf8 search].include? key }
      .map {|k,v| hidden_field_tag k, v }
      .join
      .html_safe
  end

  def pagination(collection, opts = {})
    paginate collection, opts.merge({theme: 'twitter-bootstrap-3'}) if collection.any?
  end
end
