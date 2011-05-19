module ApplicationHelper

  def title
    @title ||= t([controller.controller_path.gsub('/', '.'), controller.action_name, 'title'].join('.'))
  end

end
