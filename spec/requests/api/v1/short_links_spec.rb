require 'swagger_helper'

RSpec.describe 'api/v1/short_links', type: :request do

  path '/api/v1/short_links' do

    get('List all short_links of a logged user') do
      tags 'Short links'
      produces 'application/json'
      security [bearerAuth: {} ]

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link_list) { create_list(:short_link, 3, user_id: new_user.id)}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('Create a new short_link') do
      tags 'Short links'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          new_short_link: {
            type: :object,
            properties: {
          original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
          slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
        },
        required: ["original_url", "password"],
      } } }

      response(201, 'created') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:params) { {new_short_link: attributes_for(:short_link)}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('Update short_link') do
      tags 'Short links'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          short_link: {
            type: :object,
            properties: {
          original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
          slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
        },
        required: ["email", "password"],
      },
      update_short_link: {
        type: :object,
        properties: {
      original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
      slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
    },
    required: ["email", "password"],
  },
  og_tags: {
    type: :object,
    properties: {
  "og:title": { type: :string, example: Faker::Book.title },
  "og:type": { type: :string, example: "video:movie" },
},
required: ["email", "password"],
}
       } }

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link) { create(:short_link, user_id: new_user.id) }
        let!(:new_og_tags_list) { build_list(:og_tag, 2) }
        let!(:params) { {short_link: {slug: new_short_link.slug },
                        update_short_link: attributes_for(:short_link),
                        og_tags: {"#{new_og_tags_list[0].property}": new_og_tags_list[0].content, "#{new_og_tags_list[1].property}": new_og_tags_list[1].content } } }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('Delete short_link') do
      tags 'Short links'
      consumes 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          short_link: {
            type: :object,
            properties: {
          original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
          slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
        },
        required: ["email", "password"],
      } } }

      response(204, 'no_content') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link) { create(:short_link, user_id: new_user.id)}
        let!(:params) { {short_link: {slug: new_short_link.slug }}}

        run_test!
      end
    end
  end

  path '/api/v1/short_links/show' do

    post('Show specific short_link') do
      tags 'Short links'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          short_link: {
            type: :object,
            properties: {
          original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
          slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
        },
        required: ["email", "password"],
      } } }

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link) { create(:short_link, user_id: new_user.id)}
        let!(:params) { {short_link: {slug: new_short_link.slug }}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/short_links/fetch_og_tags' do

    post('Fetch_og_tags from url saved in specific short_link') do
      tags 'Short links'
      consumes 'application/json'
      produces 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          short_link: {
            type: :object,
            properties: {
          original_url: { type: :string, example: Faker::Internet.url(scheme: 'https') },
          slug: { type: :string, example: Faker::Internet.slug(glue: '-') },
        },
        required: ["email", "password"],
      } } }

      response(201, 'created') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link) { create(:short_link, user_id: new_user.id, original_url: "https://www.wwf.pl/")}
        let!(:params) { {short_link: {slug: new_short_link.slug }}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, 'unprocessable_entity') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:new_short_link) { create(:short_link, user_id: new_user.id, original_url: "https://www.filmweb.pl/ranking/film")}
        let!(:params) { {short_link: {slug: new_short_link.slug }}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

    end
  end

  path '/{slug}' do

    parameter name: 'slug', in: :path, type: :string, description: 'slug'

    get('Redirect to url in short_link') do
      tags 'Redirect'

      response(302, 'found') do
        let!(:new_user) { create(:user)}
        let!(:new_short_link) { create(:short_link, user_id: new_user.id)}
        let(:slug) { new_short_link.slug }

        run_test!
      end

      response(404, 'not_found') do
        let(:slug) { Faker::Internet.slug(glue: '-') }

        run_test!
      end

    end
  end
end
