require 'rails_helper'


RSpec.describe 'Api::V1::Users', type: :request do
  describe 'DELETE /destroy' do

    context 'with valid token' do
      include_context "register_and_login_user"

      before do

        delete '/api/v1/users', headers: { Authorization:  "Bearer " + token}

      end

      it 'returns status no_content' do
        expect(response).to have_http_status(:no_content)
      end
    end

  end
end
