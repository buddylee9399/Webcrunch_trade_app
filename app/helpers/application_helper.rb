module ApplicationHelper

def menu_items
  [{
    name: 'Home',
    path: root_path,
  }, {
    name: 'About',
    path: about_path,
  }, {
    name: 'Contact',
    path: contact_path,
  }, {
    name: 'Privacy',
    path: privacy_path,
  },].map do |item|
    {
      name: item[:name],
      path: item[:path],
      active: current_page?(item[:path])
    }
  end
end
   def gravatar_for(user, options = { size: 200})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.first_name, class: "border-radius-50")
  end

  def markdown_to_html(text)
    Kramdown::Document.new(text).to_html
  end

  def trade_author(trade)
    user_signed_in? && current_user.id == trade.user_id
  end

end
