defmodule TenExTakeHome.HttpClient.Behaviour do
  @moduledoc """
  Defines an interface for making http requests.
  """

  @type url :: String.t()
  @type headers :: list()
  @type options :: Keyword.t()
  @type success :: map()
  @type error :: map() | String.t()

  @callback get(url(), headers(), options()) :: {:ok, success()} | {:error, error()}
end
