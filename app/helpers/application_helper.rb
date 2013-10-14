module ApplicationHelper

  def to_dos
    ToDo.all
  end

  def sortable(args)
    args[:direction] = (args[:sort] == params[:sort] &&
      params[:direction] == "asc") ? "desc" : "asc"
    args[:course] = params[:course] if params[:course]
    link_to args.fetch(:title) { args.fetch(:sort).titleize }, args
  end

  def sort_image(column)
    if params[:sort] && params[:direction]
      direction = params[:direction] == 'asc' ? 'down' : 'up'
      content_tag(:i, nil, class: "icon-chevron-#{direction}") unless params[:sort] != column
    elsif column == 'title'
      content_tag(:i, nil, class: 'icon-chevron-down')
    end
  end

end
