defmodule TenExTakeHome.Cache do
  @moduledoc """
  Cache with ttl invalidation.
  """

  use GenServer

  @default_ttl 5

  def child_spec(cache_name) do
    %{
      id: cache_name,
      start: {__MODULE__, :start_link, [cache_name]}
    }
  end

  def start_link(cache_name) do
    GenServer.start_link(__MODULE__, cache_name, name: cache_name)
  end

  def get(cache, key) do
    case :ets.lookup(cache, key) do
      [element] -> element
      [] -> nil
    end
  end

  def clear(cache) do
    GenServer.call(cache, {:clear})
  end

  def insert(cache, key, value) do
    GenServer.cast(cache, {:insert, {key, value}})
  end

  def all_values(cache) do
    GenServer.call(cache, {:all_values})
  end

  def init(cache) do
    :ets.new(cache, [:set, :named_table, read_concurrency: true])
    {:ok, cache}
  end

  def handle_cast({:insert, {key, value}}, cache) do
    expiration = now() + @default_ttl
    :ets.insert(cache, {key, value, expiration})

    {:noreply, cache}
  end

  def handle_call({:all_values}, _from, cache) do
    {:reply, get_values(cache), cache}
  end

  def handle_call({:clear}, _from, cache) do
    {:reply, :ets.delete_all_objects(cache), cache}
  end

  defp get_values(cache) do
    cache
    |> tap(&remove_expired_items/1)
    |> :ets.tab2list()
    |> Enum.map(&elem(&1, 1))
  end

  defp remove_expired_items(cache) do
    :ets.select_delete(cache, [{{:_, :_, :"$1"}, [{:<, :"$1", now()}], [true]}])
  end

  defp now, do: :os.system_time(:seconds)
end
