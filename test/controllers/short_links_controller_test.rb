require "test_helper"

class ShortLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @short_link = short_links(:one)
  end

  test "should get index" do
    get short_links_url, as: :json
    assert_response :success
  end

  test "should create short_link" do
    assert_difference("ShortLink.count") do
      post short_links_url, params: { short_link: { original_url: @short_link.original_url, short_url: @short_link.short_url } }, as: :json
    end

    assert_response :created
  end

  test "should show short_link" do
    get short_link_url(@short_link), as: :json
    assert_response :success
  end

  test "should update short_link" do
    patch short_link_url(@short_link), params: { short_link: { original_url: @short_link.original_url, short_url: @short_link.short_url } }, as: :json
    assert_response :success
  end

  test "should destroy short_link" do
    assert_difference("ShortLink.count", -1) do
      delete short_link_url(@short_link), as: :json
    end

    assert_response :no_content
  end
end
