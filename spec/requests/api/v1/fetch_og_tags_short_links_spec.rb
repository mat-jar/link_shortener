require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe "POST /fetch_og_tags" do
  context 'with random url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      post '/api/v1/short_links/fetch_og_tags', params:
                        { short_link: {
                          slug: new_short_link.slug
                        } }, headers: { Authorization:  "Bearer " + token}
    end



    it 'returns short_url' do
      expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
    end

    it 'returns the original_url' do
      expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
    end
    end

  end
end
