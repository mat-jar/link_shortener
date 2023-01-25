RSpec.shared_context "register_and_login_user", :shared_context => :metadata do
    let!(:new_user) { FactoryBot.create(:user)}

    before do

      post '/api/v1/login', params:
                        { user: {
                          email: new_user.email,
                          password: new_user.password
                        } }

      end
      let!(:token) {JSON.parse(response.body)["token"]}
end
