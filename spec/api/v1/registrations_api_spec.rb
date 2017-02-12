require 'rails_helper'

RSpec.describe V1::RegistrationsApi do
  describe 'POST /api/v1/registrations' do
    context 'valid' do
      before(:each) do
        post '/api/v1/registrations',
          params: { email: 'user@mail.com', password: 'password' },
          headers: default_headers
      end

      it 'should include an auth token in the Authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it { expect(status_code).to be 201 }
    end

    context 'invalid' do
      before(:each) do
        user = create(:user, email: 'user@mail.com', password: 'password')
        post '/api/v1/registrations',
          params: { email: user.email, password: user.password },
          headers: default_headers
      end

      it { expect(json_response[:error]).to include(email: ["has already been taken"]) }
      it { expect(json_response[:error]).to include(username: ["has already been taken"]) }
      it { expect(status_code).to be 401 }
    end
  end

  describe 'PUT /api/v1/registrations' do
    let(:user) { create :user, email: 'user@mail.com', password: 'password' }

    context 'valid' do
      before(:each) do
        put '/api/v1/registrations',
          params: { username: 'user1', email: 'newuser@mail.com', password: 'newpassword', password_confirmation: 'newpassword' },
          headers: default_headers({'Authorization': user.authentication_token})
        user.reload
      end

      it { expect(user.username).to eq 'user1' }
      it { expect(user.email).to eq 'newuser@mail.com' }
      it 'should be valid password when "newpassword"' do
        expect(user.valid_password?('newpassword')).to be_truthy
      end
      it { expect(status_code).to be 204 }
    end

    context 'invalid' do
      before(:each) do
        put '/api/v1/registrations',
          params: { username: 'user1', email: 'newuser@mail.com', password: 'newpassword', password_confirmation: 'wrong' },
          headers: default_headers({'Authorization': user.authentication_token})
        user.reload
      end

      it { expect(json_response).to include(error: {:password_confirmation=>["doesn't match Password"]})}
      it { expect(status_code).to be 422 }
    end
  end

  describe 'DELETE /api/v1/registrations' do
    context 'valid' do
      let(:user) { create :user, email: 'user@mail.com', password: 'password' }

      before(:each) do
        delete '/api/v1/registrations', headers: default_headers({'Authorization': user.authentication_token})
      end

      it 'should be destroyed' do
        expect(User.where(id: user)).to be_empty
      end
      it { expect(status_code).to be 204 }
    end

    context 'invalid' do
      before(:each) do
        delete '/api/v1/registrations', headers: default_headers
      end

      it { expect(status_code).to be 401 }
    end
  end
end
