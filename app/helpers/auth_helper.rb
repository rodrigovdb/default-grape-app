module AuthHelper
  def authenticate
    User.authenticate params[:public_key], params[:password]
  end

  def check_session
    access_token  = User.find_by access_token: headers['Xauthtoken']

    error!('Invalid Token', 401) if access_token.nil?
    error!('Expired Token', 401) if access_token.expired?
  end
end
