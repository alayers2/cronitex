defmodule Cronitex.Monitors do
  @moduledoc """
  The Monitors context.
  """

  import Ecto.Query, warn: false
  alias Cronitex.Repo

  alias Cronitex.Monitors.CronMonitor
  alias Cronitex.Accounts

  @doc """
  Returns the list of cronmonitors.

  ## Examples

      iex> list_cronmonitors()
      [%CronMonitor{}, ...]

  """
  def list_cronmonitors do
    Repo.all(CronMonitor)
  end

  @doc """
  Gets a single cron_monitor.

  Raises `Ecto.NoResultsError` if the Cron monitor does not exist.

  ## Examples

      iex> get_cron_monitor!(123)
      %CronMonitor{}

      iex> get_cron_monitor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cron_monitor!(id), do: Repo.get!(CronMonitor, id)

  @doc """
  Creates a cron_monitor.

  ## Examples

      iex> create_cron_monitor(%{field: value})
      {:ok, %CronMonitor{}}

      iex> create_cron_monitor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cron_monitor(%Accounts.User{} = user, attrs \\ %{}) do
    %CronMonitor{}
    |> CronMonitor.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a cron_monitor.

  ## Examples

      iex> update_cron_monitor(cron_monitor, %{field: new_value})
      {:ok, %CronMonitor{}}

      iex> update_cron_monitor(cron_monitor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cron_monitor(%CronMonitor{} = cron_monitor, attrs) do
    cron_monitor
    |> CronMonitor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cron_monitor.

  ## Examples

      iex> delete_cron_monitor(cron_monitor)
      {:ok, %CronMonitor{}}

      iex> delete_cron_monitor(cron_monitor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cron_monitor(%CronMonitor{} = cron_monitor) do
    Repo.delete(cron_monitor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cron_monitor changes.

  ## Examples

      iex> change_cron_monitor(cron_monitor)
      %Ecto.Changeset{data: %CronMonitor{}}

  """
  def change_cron_monitor(%CronMonitor{} = cron_monitor, attrs \\ %{}) do
    CronMonitor.changeset(cron_monitor, attrs)
  end


  def list_user_monitors(%Accounts.User{} = user) do
    CronMonitor
    |> user_monitor_query(user)
    |> Repo.all()
  end

  def get_user_monitor!(%Accounts.User{} = user, id) do
    CronMonitor
    |> user_monitor_query(user)
    |> Repo.get!(id)
  end

  defp user_monitor_query(query, %Accounts.User{id: user_id}) do
    from(m in query, where: m.user_id == ^user_id)
  end
end
