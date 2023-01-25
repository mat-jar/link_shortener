require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe "GET /index" do
  context 'with three users' do
    include_context "register_and_login_user"
    let!(:first_user) { FactoryBot.create(:user)}
    let!(:second_user) { FactoryBot.create(:user)}
    let!(:third_user) { FactoryBot.create(:user)}

    before do
      get '/api/v1/users', headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns first' do
        expect(JSON.parse(response.body)).to include(JSON.parse(new_user.to_json))
        expect(JSON.parse(response.body)).to include(JSON.parse(first_user.to_json))
        expect(JSON.parse(response.body)).to include(JSON.parse(second_user.to_json))
        expect(JSON.parse(response.body)).to include(JSON.parse(third_user.to_json))
      end
    end

  end
end
