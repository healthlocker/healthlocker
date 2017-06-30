defmodule Healthlocker.DecryptUserTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.DecryptUser

  test "string is split & returns correct portion" do
    user_data = "UserName=robert_macmurray@nhs.co.uk&UserId=randomstringtotestwith&tokenexpiry=2017-06-23T11:15:53"
    actual = DecryptUser.get_user_guid(user_data)
    expected = "randomstringtotestwith"
    assert actual == expected
  end

  test "nil returns empty string" do
    actual = DecryptUser.get_user_guid(nil)
    expected = ""
    assert actual == expected
  end
end
