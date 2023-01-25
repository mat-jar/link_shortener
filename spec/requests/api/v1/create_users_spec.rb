require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'POST /create' do
  context 'with valid parameters' do
    let!(:new_user) { FactoryBot.build(:user)}
    before do
      post '/api/v1/users', params:
                        { user: {
                          email: new_user.email,
                          password: new_user.password
                        } }
      end


      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end


      it 'returns user data' do
        expect(JSON.parse(response.body)["email"]).to include(new_user.email)
      end
    end

    context 'with invalid parameters' do
      before do
        post '/api/v1/users', params:
                          { user: {
                            email: '',
                            password: ''
                          } }
      end
      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end
end
