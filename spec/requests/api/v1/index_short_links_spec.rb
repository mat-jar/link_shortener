require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe "GET /index" do
  context 'with three short links' do
    include_context "register_and_login_user"
    let!(:first_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}
    let!(:second_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}
    let!(:third_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      get '/api/v1/short_links', headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns first' do
        expect(JSON.parse(response.body)).to include(JSON.parse(first_short_link.to_json))
        expect(JSON.parse(response.body)).to include(JSON.parse(second_short_link.to_json))
        expect(JSON.parse(response.body)).to include(JSON.parse(third_short_link.to_json))
      end
    end

  end
end
