module ApplicationHelper
  def generate_previous_next_label(first, previous, nexxt, last)
     url_link = String.new
     url_link << (link_to image_tag("first.png", :title => "First"), first)
     url_link << " | "
     if previous
       url_link << (link_to image_tag("previous.png", :title => "Previous"), previous) + " | "
     else
       url_link << (link_to image_tag("previous.png", :title => "Previous"), "#", {:onclick => "alert('There is no more record')"}) + " | "
     end

     if nexxt
       url_link << (link_to image_tag("next.png", :title => "Next"), nexxt) + " | "
     else
       url_link << (link_to image_tag("next.png", :title => "Next"), "#",  {:onclick => "alert('There is no more record')"}) + " | "
     end

     url_link << (link_to image_tag("last.png", :title => "Last"), last)
     url_link
  end
  
  def show_image(con)
    if con
      image_tag("true.png")
    else
      image_tag("false.png")
    end
  end

  def title(page_title)
    content_for(:title) { page_title.to_s }
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
end
