module ApplicationHelper
  def current_user_avatar
    current_user&.avatar || "https://i.pravatar.cc/150?img=68" # Default avatar
  end
end