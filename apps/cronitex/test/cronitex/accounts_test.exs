defmodule Cronitex.AccountsTest do
  use Cronitex.DataCase, async: true

  alias Cronitex.Accounts
  alias Cronitex.Accounts.User

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      username: "username",
      password: "supersecret"
    }
    @invalid_attrs %{
      name: "User",
      username: "username",
      password: "abc"
    }
  end

  test "with valid data inserts user" do
    assert {:ok, %User{id: id}=user} = Accounts.register_user(@valid_attrs)
    assert user.name == "User"
    assert user.username == "username"
  end

  test "with invalid data rejects user" do
    assert {:error, changeset} = Accounts.register_user(@invalid_attrs)
    assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
  end

end
