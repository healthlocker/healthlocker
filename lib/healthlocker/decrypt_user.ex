defmodule Healthlocker.DecryptUser do
  alias Healthlocker.ReadOnlyRepo

  def decrypt_user_data(user_str) do
    pass = System.get_env("MPass")
    query = """
      DECLARE @UserData VARBINARY(MAX), @passphrase varchar(255), @UserDataString VARCHAR(MAX);
      SET @passphrase = HASHBYTES('MD5', N'#{pass}');
      SELECT @UserData =
              CAST(N'' AS XML).value(
                  'xs:base64Binary("#{user_str}")'
                , 'VARBINARY(MAX)'
              )
      ;
      SELECT CONVERT(VARCHAR(8000),DecryptByPassPhrase(@passphrase,@UserData));
    """

    Ecto.Adapters.SQL.query(ReadOnlyRepo, query, [])
  end
end
