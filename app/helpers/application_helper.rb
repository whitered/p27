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

  def time_in_words time
    span = distance_of_time_in_words Time.now, time, true, { :highest_measures => 2 }
    if time.future?
      t('helpers.application.time_in_future', :time => span)
    else
      t('helpers.application.time_in_past', :time => span)
    end
  end

end
