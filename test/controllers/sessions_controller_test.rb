require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "create" do
    # create the user
    post "/users.json", params: { name: "Test", email: "test@test.com", password: "password", password_confirmation: "password" }

    #log the user in
    post "/sessions.json", params: { email: "test@test.com", password: "password" }
    assert_response 201

    data = JSON.parse(response.body)
    assert_equal [ "email", "user_id"], data.keys
  end

  test "destroy" do
    delete "/sessions.json"
    assert_response 200
  end
end
