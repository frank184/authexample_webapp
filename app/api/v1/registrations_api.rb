class V1::RegistrationsApi < Grape::API
  format :json

  namespace :registrations do
    desc 'Registers a new user'
    params do
      optional :username, type: String, desc: 'User pseudonym'
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User Password'
    end
    post '/' do
      username = params[:username]
      email = params[:email]
      password = params[:password]

      user = User.new(username: username, email: email, password: password)

      if user.save
        header('Authorization', user.authentication_token)
        status 204
      else
        error!(user.errors, 401)
      end
    end
  end
end
