require 'swagger_helper'

RSpec.describe 'api/v1/login', type: :request do

  path '/api/v1/login' do

    post('login user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
          email: { type: :string, example: "user@example.com" },
          password: { type: :string, example: "PASSword123" },
        },
        required: ["email", "password"],
      } } }

      response(200, 'ok') do
        include_context "register_user"
        let!(:params) { {user: { email: new_user.email, password: new_user.password  } }}

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, "unauthorized") do
        let(:params) { {user: { email: Faker::Internet.email, password: Faker::Internet.password } } }

        run_test!
      end

    end
  end
end
