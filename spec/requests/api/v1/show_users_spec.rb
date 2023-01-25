require 'rails_helper'


RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /show' do

    context 'with valid token' do
      include_context "register_and_login_user"
      let!(:new_short_link_1) { FactoryBot.create(:short_link, user_id: new_user.id)}
      let!(:new_short_link_2) { FactoryBot.create(:short_link, user_id: new_user.id)}
      let!(:new_short_link_1_json) { new_short_link_1.as_json(only: [:original_url], methods: [:short_url] )}
      let!(:new_short_link_2_json) { new_short_link_2.as_json(only: [:original_url], methods: [:short_url] )}

      before do

        get '/api/v1/users/show', headers: { Authorization:  "Bearer " + token}

      end

      it 'returns user details' do
        expect(JSON.parse(response.body)).to include(JSON.parse(new_user.to_json))
      end

      it 'returns user short links' do
        expect(JSON.parse(response.body)["short_links"]).to include(new_short_link_1_json)
        expect(JSON.parse(response.body)["short_links"]).to include(new_short_link_2_json)
      end


      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end

    end

    context 'with invalid token (after destroying user)' do
      include_context "register_and_login_user"

      before do
        delete '/api/v1/users', headers: { Authorization:  "Bearer " + token}
        get '/api/v1/users/show', headers: { Authorization:  "Bearer " + token}

      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

    end

    context 'with invalid token (with invalid secret key)' do
      let!(:token) {"eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NzQ2ODUxODJ9.lvgopcCi4g8unLazAACBeKBvAB8e5Wj9jk7S9WE3jfA"}
      before do
        get '/api/v1/users/show', headers: { Authorization:  "Bearer " + token}

      end

      it 'returns an unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

    end

  end
end
