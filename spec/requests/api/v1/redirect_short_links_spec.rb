require 'rails_helper'

RSpec.describe 'Api::V1::ShortLinks', type: :request do
  describe "GET/redirect" do
    context 'with valid slug' do
    let!(:new_user) { FactoryBot.create(:user)}
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

      before do
        get "/#{new_short_link.slug}"
      end

      it 'returns found status' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to short_link" do
        expect(response).to redirect_to(new_short_link.original_url)
      end

    end

    context 'with valid slug and og_tags' do
    let!(:new_user) { FactoryBot.create(:user)}
    let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

      before do
        new_short_link.og_tags.create!(property: "og:title", content: "Page title")
        get "/#{new_short_link.slug}"
      end

      it 'returns found status' do
        expect(response).to have_http_status(:found)
      end

      it "redirects to short_link" do
        expect(response).to redirect_to(new_short_link.original_url)
      end

    end

    context 'with non-existing slug' do
      let!(:new_user) { FactoryBot.create(:user)}
      let!(:new_short_link) { FactoryBot.create(:short_link, user_id: new_user.id)}

        before do
          non_existing_slug = "#{new_short_link.slug}-foo-bar"
          get "/#{non_existing_slug}"
        end

        it 'returns not found status' do
          expect(response).to have_http_status(:not_found)
        end
    end

  end
end
