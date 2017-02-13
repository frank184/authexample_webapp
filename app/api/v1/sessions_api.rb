class V1::SessionsApi < Grape::API
  format :json

  namespace :sessions do

    desc 'Authenticates the user and sends them an auth token via headers'
    params do
      requires :email_username, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User Password'
    end
    post '/' do
      email_username = params[:email_username]
      password = params[:password]

      user = User.where(email: email_username).or(User.where(username: email_username)).first
      correct_password = user.valid_password?(password)

      if email_username.blank? || password.blank? || user.nil? || !correct_password
        error!('Invalid Email or Password.', 401)
      else
        user.ensure_authentication_token
        user.save

        header('Authorization', user.authentication_token)
        status 204
      end
    end

    desc 'Destroy the auth token'
    delete '/' do
      auth_token = headers['Authorization']
      user = User.find_by(authentication_token: auth_token)

      if user.nil?
        error!('Invalid Authentication Token.', 401)
      else
        user.reset_authentication_token!
        status 204
      end
    end

  end
end
