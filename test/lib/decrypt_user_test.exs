defmodule Healthlocker.DecryptUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.DecryptUser

  test "string is split & returns correct portions" do
    user_data = "UserName=robert_macmurray@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
    actual = DecryptUser.get_user_guid_and_expiry_token(user_data)
    expected = ["randomstringtotestwith", "2017-06-23T11:15:53"]
    assert actual == expected
  end

  test "nil returns list of empty strings" do
    actual = DecryptUser.get_user_guid_and_expiry_token(nil)
    expected = ["", ""]
    assert actual == expected
  end
end
