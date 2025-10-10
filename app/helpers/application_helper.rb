module ApplicationHelper
  def round_button(path, icon_class, hover_text: nil, color: "button-round")
    link_to path, class: color do
      content_tag(:i, "", class: icon_class) +
        (hover_text ? content_tag(:span, hover_text, class: "absolute -bottom-8 scale-0 group-hover:scale-100 transition-transform bg-gray-800 text-white text-xs rounded px-2 py-1") : "")
    end
  end
end