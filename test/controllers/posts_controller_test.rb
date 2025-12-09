require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post "/users.json", params: { name: "Test", email: "test@test.com", password: "password", password_confirmation: "password", admin: true}
    post "/sessions.json", params: { email: "test@test.com", password: "password" }
  end

test "index" do
    get "/posts.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Post.count, data.length
  end

  test "show" do
    post "/users.json", params: { name: "Test", email: "test@test.com", password: "password", password_confirmation: "password" }
    post "/sessions.json", params: { email: "test@test.com", password: "password" }

    get "/posts/#{Post.first.id}.json"
    assert_response 200
  end

  test "create" do
    assert_difference "Post.count", 1 do
      post "/posts.json", params: { title: "test", body: "test post", image: "image.jpg" }
      data = JSON.parse(response.body)
      assert_response 200
    end

    # test sad path - if someone isn't signed in
    delete "/sessions.json"
    post "/posts.json", params: { title: "Test", body: "test post", image: "test.jpg" }
    assert_response 401
  end

  test "update" do
    post = Post.first
    patch "/posts/#{post.id}.json", params: { title: "Updated name" }
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal "Updated name", data["title"]

    # test sad path - if someone isn't signed in
    delete "/sessions.json"
    patch "/posts/#{post.id}", params: { title: "Something Else"}
    assert_response 401
  end

  test "destroy" do
    assert_difference "Post.count", -1 do
      delete "/posts/#{Post.first.id}.json"
      assert_response 200
    end

    #test sad path - if someone isn't signed in
     delete "/sessions.json"
    delete "/posts/#{Post.first.id}"
    assert_response 401
  end
end
