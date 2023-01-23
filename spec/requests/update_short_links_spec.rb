require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe 'PUT /update' do

    context 'with original_link and valid update parameters' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        put '/api/v1/short_links', params:
                          { short_link: {
                            original_url: new_short_link.original_url
                            },

                            update_short_link: {
                            original_url: "https://updated.url",
                            slug: "updated-slug"
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/updated-slug")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq("https://updated.url")
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with slug and valid update parameters' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        put '/api/v1/short_links', params:
                          { short_link: {
                            slug: new_short_link.slug
                            },

                            update_short_link: {
                            original_url: "https://updated.url",
                            slug: "updated-slug"
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/updated-slug")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq("https://updated.url")
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        put '/api/v1/short_links', params:
                          { short_link: {
                            original_url: new_short_link.original_url
                            },

                            update_short_link: {
                            original_url: "",
                            slug: ""
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with already used slug' do
      let!(:old_short_link) { FactoryBot.create(:short_link)}
      let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        put '/api/v1/short_links', params:
                          { short_link: {
                            original_url: new_short_link.original_url
                            },

                            update_short_link: {
                            slug: old_short_link.slug
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("Given slug is already used")
      end
    end

  end
end
