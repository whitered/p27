module ApplicationHelper

  def page_title
    if @page_title.nil?
      if content_for? :title
        @page_title = content_for(:title)
      else
        @page_title = t([controller.controller_path.gsub('/', '.'), controller.action_name, 'title'].join('.'), :default => '')
      end
    end
    @page_title
  end

  def body_title
    if content_for?(:title_prefix)
      if page_title.blank?
        content_for :title_prefix
      else
        content_for(:title_prefix) + ' | ' + page_title
      end
    else
      page_title
    end
  end

  def head_title
    if page_title.blank?
      'p27'
    else
      page_title + ' | p27'
    end
  end

  def inside_group group
    content_for :title_prefix, link_to(group.name, group)
  end

end
