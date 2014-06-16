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

  #Filters helpers
  def filters
    request.query_parameters
  end

  def no_queries?
    filters.count.zero?
  end

  def active_filter?(facet, row)
    value = row.value.is_a?(Range) ? row.value.to_s_without_gsub : row.value.to_s
    params[facet] == value
  end

  def filter_link_name(row, hash=nil)
    (hash.nil? ? row.value.to_s.titleize : hash.key(row.value)).to_s
  end

  def remove_filter_button(facet, row, filters=nil)
    if active_filter?(facet, row)
      param_filters = filters.nil? ? nil : filters.except(facet)
      return_path = Rails.application.routes.recognize_path(request.fullpath)

      link_to return_path.merge(param_filters), :class => 'btn btn-danger btn-mini pull-right' do
        content_tag(:span, nil, class: "glyphicon glyphicon-remove")
      end
    end
  end

  def filter_link(hash, facet, row, filters=nil)
    content_tag(:div) do
      concat(
        content_tag(:span, class: "link") do
          if filters.nil?
            link_to filter_link_name(row, hash), facet => row.value
          else
            value = row.value.is_a?(Range) ? row.value.to_s_without_gsub : row.value
            filter_params = filters.merge({facet => value}).except(:page)
            link_to filter_link_name(row, hash), filter_params 
          end
        end
      ) +
      concat(
        content_tag(:span, class: "info-data pull-right") do
          row.count.to_s + ' items'
          #t('semantic.n_items', n: row.count)
        end
      )
    end
  end

  def active_filter_link(hash, facet, row, filters=nil)
    content_tag(:div) do
      concat(
        content_tag(:span, class: "link") do
          filter_link_name(row, hash)
        end
      ) +
      concat(
        content_tag(:span) do
          remove_filter_button(facet, row, filters)
        end
      )
    end
  end

  def filter_row(hash, facet, row, filters=nil)
    if active_filter?(facet, row)
      active_filter_link(hash, facet, row, filters)
    else
      filter_link(hash, facet, row, filters)
    end
  end
end
