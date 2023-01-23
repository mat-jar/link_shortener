require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe "GET /index" do
  context 'with three short links' do
    let!(:first_short_link) { FactoryBot.create(:short_link)}
    let!(:second_short_link) { FactoryBot.create(:short_link)}
    let!(:third_short_link) { FactoryBot.create(:short_link)}

    before do
      get '/api/v1/short_links'
    end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns first' do
        expect(JSON.parse(response.body)[0]).to eq(JSON.parse(first_short_link.to_json))
      end
    end

  end
end
