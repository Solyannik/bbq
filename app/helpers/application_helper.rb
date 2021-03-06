module ApplicationHelper
  def user_avatar(user)
    return user.avatar.url if user.avatar?

    asset_pack_path("media/images/user.png")
  end

  def user_avatar_thumb(user)
    if user.avatar.file.present?
      user.avatar.thumb.url
    else
      asset_pack_path('media/images/user.png')
    end
  end

  def event_photo(event)
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.url
    else
      asset_pack_path('media/images/event.jpg')
    end
  end

  def event_thumb(event)
    photos = event.photos.persisted

    if photos.any?
      photos.sample.photo.thumb.url
    else
      asset_pack_path('media/images/event_thumb.jpg')
    end
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  def bootstrap_flash(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "m-3 alert #{bootstrap_class_for(msg_type)}", role: "alert") do
        concat content_tag(:button, '×', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end

  private
  def bootstrap_class_for(level)
    case level
    when "notice" then "alert-info"
    when "success" then "alert-success"
    when "error" then "alert-warning"
    when "alert" then "alert-danger"
    else level
    end
  end
end
