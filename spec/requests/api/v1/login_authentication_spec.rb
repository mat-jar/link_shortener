require 'rails_helper'

RSpec.describe 'Api::V1::Authentication', type: :request do
  describe 'POST /login' do

    context 'with valid parameters' do
      include_context "register_user"

      before do

        post '/api/v1/login', params:
                          { user: {
                            email: new_user.email,
                            password: new_user.password
                          } }
        end



      it 'returns the token' do
        expect(JSON.parse(response.body)['token']).not_to be_nil
      end

      it 'returns the expiry time' do
        expect(JSON.parse(response.body)['exp']).not_to be_nil
      end

      it 'returns an ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      before do
        post '/api/v1/login', params:
                          { user: {
                            email: '',
                            password: ''
                          } }
      end
      it 'returns a unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq('Invalid credentials')
      end

    end
  end
end
