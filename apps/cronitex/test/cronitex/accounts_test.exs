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
    assert user.password_hash
    refute user.is_superuser
  end

  test "with invalid data rejects user" do
    assert {:error, changeset} = Accounts.register_user(@invalid_attrs)
    assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
  end

  test "list users should get all users" do
    TestHelpers.user_fixture()
    assert 1 = Enum.count(Accounts.list_users())
  end

  test "list by ID should filter users" do
    user1 = TestHelpers.user_fixture()
    user2 = TestHelpers.user_fixture()

    filtered_users = Accounts.list_users_with_ids([user1.id])
    assert 1 = Enum.count(filtered_users)

    filtered_users = Accounts.list_users_with_ids([user1.id, user2.id])
    assert 2 = Enum.count(filtered_users)
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

  test "unique constraint on usernames" do
    assert {:ok, user} = Accounts.register_user(@valid_attrs)
    assert {:error, changeset} = Accounts.register_user(@valid_attrs)
    assert %{username: ["has already been taken"]} = errors_on(changeset)
  end

  test "we can get a user by other params as long as it's unique" do
    user = TestHelpers.user_fixture()
    assert user = Accounts.get_user_by!(username: user.username)

    assert user = Accounts.get_user_by(username: user.username)
  end

  test "we fail to get a user for a bad username" do
   refute Accounts.get_user_by(username: "blah")
  end

  test "we raise on fail to get a user for a bad username" do
    catch_error Accounts.get_user_by!(username: "blah")
  end

  test "we can authenticate a valid user" do
    user = TestHelpers.user_fixture()

    assert {:ok, user} = Accounts.authenticate_by_username_and_pass(
      user.username, user.password
    )
  end

  test "unauthorized returned for bad pasword" do
    user = TestHelpers.user_fixture()

    assert {:error, :unauthorized} = Accounts.authenticate_by_username_and_pass(
      user.username, "bad_pass"
    )
  end

  test "not found for unknown username" do
    assert {:error, :not_found} = Accounts.authenticate_by_username_and_pass(
      "bad_username", "bad_pass"
    )
  end

end
