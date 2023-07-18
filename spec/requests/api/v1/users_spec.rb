require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do

  path '/api/v1/users' do

    get('list users') do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: {} ]

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }

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

    post('create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
          email: { type: :string, example: Faker::Internet.email(name: Faker::Name.first_name) },
          password: { type: :string, example: Faker::Internet.password },
        },
        required: ["email"],
      } } }

      response(201, 'created') do

        let!(:params) { {user: attributes_for(:user)}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:params) { {user: { email: Faker::Internet.email } } }

        run_test!
      end

    end

    put('update user') do
      tags 'Users'
      consumes "application/json"
      produces 'application/json'
      security [bearerAuth: {} ]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
          email: { type: :string, example: Faker::Internet.email(name: Faker::Name.first_name) },
          password: { type: :string, example: Faker::Internet.password },
        },
        required: ["email", "password"],
      } } }

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let!(:params) { {user: attributes_for(:user)}}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(422, "unprocessable_entity") do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }
        let(:params) { {user: { email: Faker::Internet.slug } } }

        run_test!
      end

    end

    delete('delete user') do
      tags 'Users'
      security [bearerAuth: {} ]

      response(204, 'no_content') do
        include_context "register_and_login_user"
        let(:'Authorization') { "Bearer " + token }

        run_test!
      end
    end
  end

  path '/api/v1/users/show' do

    get('show user') do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: {} ]

      response(200, 'successful') do
        include_context "register_and_login_user"
        let(:"Authorization") { "Bearer #{token}" }

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
end
