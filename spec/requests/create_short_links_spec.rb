require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe 'POST /create' do

    context 'with valid parameters' do
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { short_link: {
                            original_url: new_short_link.original_url,
                            slug: new_short_link.slug
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with missing original_url' do
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { short_link: {
                            original_url: ""
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing original_url and given slug' do
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { short_link: {
                            original_url: "",
                            slug: new_short_link.slug
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid original_url' do
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        invalid_original_url = "#{new_short_link.original_url}^"
        post '/api/v1/short_links', params:
                          { short_link: {
                            original_url: ""
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid slug' do
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        invalid_slug = new_short_link.slug + "123"
        post '/api/v1/short_links', params:
                          { short_link: {
                            original_url: new_short_link.original_url,
                            slug: invalid_slug
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
end
