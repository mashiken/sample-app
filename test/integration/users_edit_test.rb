require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: "",
                                             email: "foo@invalid",
                                             password: "foo",
                                             password_confirmation: "bar" } }
    assert_template 'users/edit'
   # assert_select 'div.alert', "The from contains 4 errors"
  end
  
  test "successful edit" do
    get edit_user_path(@user)
    log_in_as(@user)
    #  転送先URLの確認(次回転送先がデフォルトになっているか)
    assert_nil session[:forwarding_url]
    assert_redirected_to edit_user_url(@user)
    name = "Foo bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {name: name,
                                             email: email,
                                             password: "",
                                             password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
