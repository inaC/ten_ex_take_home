defmodule TenExTakeHome.Marvel.Client.Auth do
  @moduledoc """
  Handles authentication, required to use the Marvel API
  """

  @public_key Application.compile_env!(:ten_ex_take_home, :marvel_api)[:public_key]
  @private_key Application.compile_env!(:ten_ex_take_home, :marvel_api)[:private_key]

  def sign_request(request_params \\ %{}) when is_map(request_params) do
    %{hash: hash, ts: ts} = get_codes()

    request_params
    |> Map.put(:hash, hash)
    |> Map.put(:ts, ts)
    |> Map.put(:apikey, @public_key)
  end

  defp get_codes do
    timestamp = get_timestamp()

    %{
      ts: timestamp,
      hash: get_md5(timestamp)
    }
  end

  defp get_timestamp do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end

  defp get_md5(timestamp) do
    ("#{timestamp}" <> @private_key <> @public_key)
    |> :erlang.md5()
    |> Base.encode16(case: :lower)
  end
end
