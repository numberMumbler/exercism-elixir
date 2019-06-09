defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  use GenServer

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = GenServer.start_link(BankAccount, 0)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    execute(account, &GenServer.stop(&1))
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    execute(account, &GenServer.call(&1, :balance))
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    execute(account, &GenServer.cast(&1, {:update, amount}))
  end

  defp execute(account, f) do
    if Process.alive?(account) do
      f.(account)
    else
      {:error, :account_closed}
    end
  end

  # Server
  def init(initial_balance) do
    {:ok, initial_balance}
  end

  def handle_call(:balance, _from, current_balance) do
    {:reply, current_balance, current_balance}
  end

  def handle_cast({:update, amount}, current_balance) do
    {:noreply, current_balance + amount}
  end
end
