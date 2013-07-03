module ApplicationHelper

  def full_page_title(page_title)
    base_title = "ShuffleBoard"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
end
