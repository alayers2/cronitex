defmodule Cronitex.AccountsTest do
  use Cronitex.DataCase, async: true

  alias Cronitex.Accounts
  alias Cronitex.Accounts.User
  alias Cronitex.TestHelpers

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

  test "list users should get all users" do
    TestHelpers.user_fixture()
    assert 1 = Enum.count(Accounts.list_users())
  end

  test "we can get a user by id" do
    user = TestHelpers.user_fixture()
    assert user = Accounts.get_user!(user.id)

    assert user = Accounts.get_user(user.id)
  end

  test "we fail to get a user for a bad ID" do
   refute Accounts.get_user(0)
  end

  test "we raise on fail to get a user for a bad ID" do
    catch_error Accounts.get_user!(0)
  end


end
