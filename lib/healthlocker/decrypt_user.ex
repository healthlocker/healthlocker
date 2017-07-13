defmodule Healthlocker.DecryptUser do
  alias Healthlocker.ReadOnlyRepo

  def decrypt_user_data(user_str) do

    case Application.get_env(:healthlocker, :environment) do
      :test ->
        ["randomstringtotestwith", "3000-06-23T11:15:53"]
      _ ->
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

        case Ecto.Adapters.SQL.query(ReadOnlyRepo, query, []) do
          {:ok, result} ->
            result.rows
            |> List.flatten
            |> List.first
            |> get_user_guid_and_expiry_token
          {:error, _} ->
            ""
        end
    end
  end

  def get_user_guid_and_expiry_token(str) do
    case str do
      nil ->
        ["", ""]
      str ->
        str
        |> String.split("\\n")
        |> Enum.at(0)
        |> String.split("UserId=")
        |> Enum.at(1)
        |> String.split("&tokenexpiry=")
    end
  end
end
