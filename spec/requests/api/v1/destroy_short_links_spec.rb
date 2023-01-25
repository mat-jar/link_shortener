require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe "DELETE /destroy" do
    context 'with existing original_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          original_url: new_short_link.original_url
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status no_content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with existing slug' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          slug: new_short_link.slug
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status no_content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with existing short_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      delete '/api/v1/short_links', params:
                        { short_link: {
                          short_url: "#{ENV["HOST_NAME"]}/#{new_short_link.slug}"
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status no_content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with non-existing original_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      non_existing_original_url = new_short_link.original_url + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          original_url: non_existing_original_url
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with non-existing slug' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      non_existing_slug = new_short_link.slug + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          slug: non_existing_slug
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with non-existing short_url' do
    include_context "register_and_login_user"
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

    before do
      non_existing_short_url = "#{ENV["HOST_NAME"]}/#{new_short_link.slug}" + "-foo"
      delete '/api/v1/short_links', params:
                        { short_link: {
                          short_url: non_existing_short_url
                        } }, headers: { Authorization:  "Bearer " + token}
    end

      it 'returns status unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
end
