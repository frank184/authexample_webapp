require 'rails_helper'

RSpec.describe V1::RegistrationsApi do
  describe 'POST /v1/registrations' do
    context 'valid' do
      before(:each) do
        post '/v1/registrations',
          params: { email: 'user@mail.com', password: 'password' },
          headers: default_headers
      end

      it 'should include an auth token in the Authorization header' do
        expect(response.headers['Authorization']).to be_present
      end

      it { expect(status_code).to be 204 }
    end

    context 'invalid' do
      before(:each) do
        user = create(:user, email: 'user@mail.com', password: 'password')
        post '/v1/registrations',
          params: { email: user.email, password: user.password },
          headers: default_headers
      end

      it { expect(json_response).to include(error: {:email=>["has already been taken"]}) }
      it { expect(status_code).to be 401 }
    end
  end
end
