ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cronitex.Repo, :manual)


defmodule Cronitex.TestHelpers do
  alias Cronitex.Accounts


  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: attrs[:username] || "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "supersecret"
      })
      |> Accounts.register_user()
    user
  end

  
end
