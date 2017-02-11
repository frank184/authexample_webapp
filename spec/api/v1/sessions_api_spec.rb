require 'rails_helper'

RSpec.describe V1::SessionsApi do

  let(:user) { create :user, email: 'user@mail.com', password: 'password' }

  describe 'POST /v1/sessions' do

    context 'valid' do
      before(:each) do
        post '/v1/sessions',
          params: { email: user.email, password: user.password },
          headers: default_headers
      end
      it 'should include an auth token in the Authorization header' do
        expect(response.headers['Authorization']).to be_present
      end
    end

    context 'invalid' do
      before(:each) do
        post '/v1/sessions',
          params: { email: user.email, password: 'invalid' },
          headers: default_headers
      end

      it { expect(json_response).to include(error: "Invalid Email or Password.") }
    end
  end

  describe 'DELETE /v1/sessions' do
    context 'valid' do
      before(:each) do
        delete '/v1/sessions',
          params: {},
          headers: default_headers({'Authorization': user.authentication_token})
      end
      it { expect(response.status).to be 204 }
    end

    context 'invalid' do
      before(:each) do
        delete '/v1/sessions',
          params: {},
          headers: default_headers({'Authentication': 'InvalidToken'})
      end

      it { expect(json_response).to include(error: "Invalid Authentication Token.") }
    end
  end
end
