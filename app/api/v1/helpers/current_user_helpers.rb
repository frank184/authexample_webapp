module CurrentUserHelpers
  def current_user
    @current_user ||= User.find_by(authentication_token: headers['Authorization'])
  end

  def user_signed_in?
    current_user.present?
  end
end
