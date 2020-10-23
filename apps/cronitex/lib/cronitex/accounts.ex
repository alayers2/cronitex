defmodule Cronitex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Cronitex.Repo

  alias Cronitex.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)


  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  @doc """
  Function to get the user by a set of parameters

  ## Examples

    iex> Rumbl.Accounts.get_user_by(name: "Bruce")
    %Rumbl.Accounts.User{id: "2", name: "Bruce", username: "redrapids"}


    iex> Rumbl.Accounts.get_user_by(id: "2")
    %Rumbl.Accounts.User{id: "2", name: "Bruce", username: "redrapids"}


    iex> Rumbl.Accounts.get_user_by(username: "redrapids")
    %Rumbl.Accounts.User{id: "2", name: "Bruce", username: "redrapids"}

    iex> Rumbl.Accounts.get_user_by(name: "Jimmy")
    nil
  """
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def get_user_by!(params) do
    Repo.get_by!(User, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

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

  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end
end
