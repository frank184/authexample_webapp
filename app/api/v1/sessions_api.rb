class V1::SessionsApi < Grape::API
  format :json

  namespace :sessions do

    desc 'Authenticates the user and sends them an auth token'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User Password'
    end
    post '/' do
      email = params[:email]
      password = params[:password]

      user = User.find_by(email: email)
      correct_password = user.valid_password?(password)

      if email.blank? || password.blank? || user.nil? || !correct_password
        error!('Invalid Email or Password.', 401)
      else
        user.ensure_authentication_token
        user.save

        status 200
        { auth_token: user.authentication_token }
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
