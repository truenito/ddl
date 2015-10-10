class MatchDecorator < Draper::Decorator
delegate_all

  def name
    h.truncate(object.name.upcase, length: 64)
  end

  def time_ago
    " " + h.time_ago_in_words(object.created_at)
  end

  def pretty_status
    markup = ""
    if object.status == 'waiting'
      markup = h.content_tag(:span, "#{object.match_tokens.count}/10" ,{class: 'waiting'})
    elsif object.status == 'playing'
      markup = h.content_tag(:span, object.status ,{class: 'playing'})
    elsif object.status == 'canceled'
      markup = h.content_tag(:span, object.status ,{class: 'canceled'})
    else object.status == 'ended'
      markup = h.content_tag(:span, object.status ,{class: 'ended'})
    end
    markup.html_safe
  end

  def action(user)
    markup = ""
    if object.match_tokens.count == 10
      markup = h.content_tag(:span, 'full' ,{class: 'ended'})
    elsif !user
      markup = h.link_to('log in', '#',{"data-popup" => "facebox", :href => "#login-box"})
    elsif !user.facebook_authed?
      markup = h.link_to('Autenticar Facebook', h.join_match_path(object.id))
    elsif !(user.match_tokens.where(match_id: object.id)).empty?
      markup = h.link_to('ver', h.match_path(match))
    elsif user.match_tokens.where(result: nil).any?
      markup = h.content_tag(:span, 'en curso' ,{class: 'waiting'})
    else
      markup = h.link_to('entrar', h.join_match_path(object.id))
    end
    markup.html_safe
  end

end
