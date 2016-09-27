require "will_paginate/view_helpers/action_view"

module Pagination
  class BootstrapRenderer < WillPaginate::ActionView::LinkRenderer
    def to_html
      html = pagination.map do |item|
        item.is_a?(Fixnum) ? page_number(item) : send(item)
      end.join(@options[:link_separator])
      html = html_container(html) if @options[:container]
      tag(:ul, html, class: @options[:class])
    end

    protected

    def page_item(text:, url:, link_status: nil, aria_label: "")
      text = text.to_s + tag(:span, "(current)", class: "sr-only") if link_status == "active"
      link_tag = if link_status.nil?
        link(text, url, class: "page-link", aria_label: aria_label, rel: text)
      else
        tag(:span, text, class: "page-link")
      end

      tag(:li, link_tag, class: "page-item #{link_status}")
    end

    def page_number(page)
      link_status = "active" if page == current_page
      page_item(text: page, url: page, link_status: link_status)
    end

    def gap
      text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
      page_item(text: text, url: nil, link_status: "disabled")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, @options[:previous_label], "Previous")
    end

    def next_page
      num = @collection.current_page < total_pages && @collection.current_page + 1
      previous_or_next_page(num, @options[:next_label], "Next")
    end

    def previous_or_next_page(page, text, aria_label)
      link_status = "disabled" unless page
      page_item(text: text, url: page, link_status: link_status, aria_label: aria_label)
    end
  end
end
