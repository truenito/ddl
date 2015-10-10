# Rails Application helper, general helper methods.
module ApplicationHelper
  def leader_real_name(user)
    markup = ''
    if user.real_name.nil?
      markup = '(sin nombre real)'
    elsif user.real_name.present? && user.real_middle_name && user.real_last_name
      markup = user.real_name + ' ' + user.real_middle_name + ' ' + user.real_last_name
    elsif user.real_name.present? && user.real_last_name
      markup = user.real_name + ' ' + user.real_last_name
    end
    markup.html_safe
  end

  def leaderboard_image(position)
    if position == 0
      image_tag('avatars/cent-avatar.png')
    elsif position == 1
      image_tag('avatars/bm-avatar.png')
    elsif position == 2
      image_tag('avatars/sven-avatar.png')
    else
      image_tag('avatars/wr-avatar.png')
    end
  end

  def resource_class
    devise_mapping.to
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
