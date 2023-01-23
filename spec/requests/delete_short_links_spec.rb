require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe "DELETE /destroy" do
    context 'with existing original_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          original_url: new_short_link.original_url
                        } }
    end

      it 'returns status no_content - code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with existing slug' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          slug: new_short_link.slug
                        } }
    end

      it 'returns status no_content - code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with existing short_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          short_url: "#{ENV["HOST_NAME"]}/#{new_short_link.slug}"
                        } }
    end

      it 'returns status no_content - code 204' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with non-existing original_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      non_existing_original_url = new_short_link.original_url + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          original_url: non_existing_original_url
                        } }
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with non-existing slug' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      non_existing_slug = new_short_link.slug + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          slug: non_existing_slug
                        } }
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with non-existing short_url' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

    before do
      non_existing_short_url = "#{ENV["HOST_NAME"]}/#{new_short_link.slug}" + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          short_url: non_existing_short_url
                        } }
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
end
