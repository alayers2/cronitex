defmodule Cronitex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cronitex.Repo

  alias Cronitex.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id), do: Repo.get!(User, id)


  def get_user(id) do
    Repo.get(User, id)
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  @doc """
  Function to get the user by a set of parameters
  """
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_user_by!(params) do
    Repo.get_by!(User, params)
  end

  @doc """
  Function to create a new user including hashing their password.
  """
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Function to authenticate a given username and password and return a user if found and correct.
  """
  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  @doc """
  Returns a list of users with ids in a list
  """
  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end
end
