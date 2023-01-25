require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'PUT /update' do
  context 'with valid parameters' do
  include_context "register_and_login_user"

    before do
      put '/api/v1/users', params:
                        { user: {
                          email: "updated@email.com",
                          password: "Updated_password"
                        } }, headers: { Authorization:  "Bearer " + token}
      end


      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end

    end

    context 'with invalid parameters' do
    include_context "register_and_login_user"
      before do
        put '/api/v1/users', params:
                          { user: {
                            email: '',
                            password: ''
                          } }, headers: { Authorization:  "Bearer " + token}
      end
      it 'returns a unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end
end
