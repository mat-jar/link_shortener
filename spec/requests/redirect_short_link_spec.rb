require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  describe "GET/redirect" do
    context 'with valid slug' do
    let!(:new_short_link) { FactoryBot.create(:short_link)}

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

    context 'with invalid slug' do
      let!(:new_short_link) { FactoryBot.create(:short_link)}

        before do
          invalid_slug = "#{new_short_link.slug}-foo-bar"
          get "/#{invalid_slug}"
        end

        it 'returns not found status' do
          expect(response).to have_http_status(:not_found)
        end
    end

  end
end
