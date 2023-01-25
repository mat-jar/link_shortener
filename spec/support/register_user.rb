RSpec.shared_context "register_user", :shared_context => :metadata do
    let!(:new_user) { FactoryBot.build(:user)}
    before do
      post '/api/v1/users', params:
                        { user: {
                          email: new_user.email,
                          password: new_user.password
                        } }
      end
end
