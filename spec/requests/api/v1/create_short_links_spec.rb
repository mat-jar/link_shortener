require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe 'POST /create' do

    context 'with valid parameters (but no og_tags)' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: new_short_link.original_url,
                            slug: new_short_link.slug
                          } }, headers: { Authorization:  "Bearer " + token}
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

    context 'with valid parameters and valid og_tags' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: new_short_link.original_url,
                            slug: new_short_link.slug
                          },
                          new_og_tags: {"og:title": "hello", "og:type": "video.movie",
                          "og:image": "http://example.com/example.png", "og:url": "http://example.com"}
                         }, headers: { Authorization:  "Bearer " + token}
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
      end

      it 'returns og_tags' do
        expect(JSON.parse(response.body)['og_tags']).to include({"property"=>"og:title", "content"=>"hello"})
        expect(JSON.parse(response.body)['og_tags']).to include({"property"=>"og:type", "content"=>"video.movie"})
        expect(JSON.parse(response.body)['og_tags']).to include({"property"=>"og:image", "content"=>"http://example.com/example.png"})
        expect(JSON.parse(response.body)['og_tags']).to include({"property"=>"og:url", "content"=>"http://example.com"})
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with missing original_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: ""
                          } }, headers: { Authorization:  "Bearer " + token}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with missing original_url and given slug' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: "",
                            slug: new_short_link.slug
                          } }, headers: { Authorization:  "Bearer " + token}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid original_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        invalid_original_url = "#{new_short_link.original_url}^"
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: ""
                          } }, headers: { Authorization:  "Bearer " + token}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid slug' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        invalid_slug = new_short_link.slug + "123"
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: new_short_link.original_url,
                            slug: invalid_slug
                          } }, headers: { Authorization:  "Bearer " + token}
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with already used slug' do
    include_context "register_and_login_user"
    let!(:old_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}
    let!(:new_short_link) { FactoryBot.build(:short_link)}

      before do
        post '/api/v1/short_links', params:
                          { new_short_link: {
                            original_url: new_short_link.original_url,
                            slug: old_short_link.slug
                          } }, headers: { Authorization:  "Bearer " + token}
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
