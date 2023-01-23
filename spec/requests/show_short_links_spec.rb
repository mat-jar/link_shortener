require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe 'POST /show' do

    context 'with given original_link' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            original_url: new_short_link.original_url
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
      end

      it 'returns the slug' do
        expect(JSON.parse(response.body)['slug']).to eq(new_short_link.slug)
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with given slug' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            slug: new_short_link.slug
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
      end

      it 'returns the slug' do
        expect(JSON.parse(response.body)['slug']).to eq(new_short_link.slug)
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with given short_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            short_url: "#{ENV["HOST_NAME"]}/#{new_short_link.slug}"
                          } }
      end

      it 'returns short_url' do
        expect(JSON.parse(response.body)['short_url']).to eq("#{ENV["HOST_NAME"]}/#{new_short_link.slug}")
      end

      it 'returns the original_url' do
        expect(JSON.parse(response.body)['original_url']).to eq(new_short_link.original_url)
      end

      it 'returns the slug' do
        expect(JSON.parse(response.body)['slug']).to eq(new_short_link.slug)
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with valid request but empty strings as params' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            original_url: "",
                            slug: "",
                            short_url: ""
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("No record with given parameter(s)")
      end
    end

    context 'without params' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          { short_link: {} }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("You need to provide original_url, slug or short_url as a query parameter")
      end
    end

    context 'with wrong original_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        wrong_original_url = new_short_link.original_url + "-foo"
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            original_url: wrong_original_url
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("No record with given parameter(s)")
      end
    end

    context 'with wrong short_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        wrong_short_url = "#{ENV["HOST_NAME"]}/#{new_short_link.slug}" + "-foo"
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            short_url: wrong_short_url
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("No record with given parameter(s)")
      end
    end

    context 'with wrong slug' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        wrong_slug = new_short_link.slug + "-foo"
        post '/api/v1/short_links/show', params:
                          { short_link: {
                            slug: wrong_slug
                          } }
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("No record with given parameter(s)")
      end
    end

    context 'with invalid parameters' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        post '/api/v1/short_links/show', params:
                          "short_link"
      end

      it 'returns an unprocessable entity status' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns the message' do
        expect(JSON.parse(response.body)['message']).to eq("Provided request parameters are invalid")
      end
    end

    context 'with given original_link of already used short link' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

      before do
        get "/#{new_short_link.slug}"

        post '/api/v1/short_links/show', params:
                          { short_link: {
                            original_url: new_short_link.original_url
                          } }
      end

      it 'returns correct use_counter' do
        expect(JSON.parse(response.body)['use_counter']).to eq(1)
      end

      it 'returns a ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

  end
end
