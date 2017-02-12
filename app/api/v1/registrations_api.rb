class V1::RegistrationsApi < Grape::API
  format :json

  namespace :registrations do
    desc 'Creates a user registration'
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
        status 201
      else
        error!(user.errors, 401)
      end
    end

    desc 'Updates a user registration'
    params do
      optional :username, type: String, desc: 'User pseudonym'
      optional :email, type: String, desc: 'User email'
      optional :password, type: String, desc: 'User password'
      optional :password_confirmation, type: String, desc: 'User password confirmation'
    end
    put '/' do
      auth_token = headers['Authorization']
      error!('Invalid Authentication Token.', 401) unless auth_token.present?
      user = User.find_by(authentication_token: auth_token)

      username = params[:username]
      email = params[:email]
      password = params[:password]
      password_confirmation = params[:password_confirmation] || "wrong" if password.present?

      if user.update(
        username: (username if username.present?),
        email:    (email if email.present?),
        password: (password if password.present?),
        password_confirmation: (password_confirmation if password_confirmation.present?)
      )
        status 204
      else
        error!(user.errors, 422)
      end
    end

    desc 'Destroys a user registration'
    delete '/' do
      auth_token = headers['Authorization']
      error!('Invalid Authentication Token.', 401) unless auth_token.present?
      user = User.find_by(authentication_token: auth_token)
      user.destroy

      if user.destroyed?
        status 204
      else
        error!(user.errors, 500)
      end
    end
    
  end
end
