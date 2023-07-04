defmodule TenExTakeHome.HttpClient do
  @moduledoc """
  Client to make HTTP requests.
  """

  alias TenExTakeHome.HttpClient.Behaviour

  @behaviour Behaviour

  @success_status_codes [200]

  @doc """
  Make a HTTP request usig the `GET` verb.

  ## Examples

      iex> HttpClient.get("https://www.globo.com")
      {:ok, "google main page in html format}

      iex> HttpClient.get("localhost")
      {:error, :econnrefused}

  """
  @impl Behaviour
  def get(url, headers \\ [], options \\ []) do
    url
    |> impl().get(headers, options)
    |> process_response()
  end

  defp process_response(
         {:ok, %HTTPoison.Response{status_code: status_code, body: body, headers: headers}}
       )
       when status_code in @success_status_codes do
    {:ok, process_body(body, headers)}
  end

  defp process_response({:ok, %HTTPoison.Response{body: body, headers: headers}}) do
    {:error, process_body(body, headers)}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp process_body(body, resp_headers) do
    body
    |> unzip_body(resp_headers)
    |> decode(resp_headers)
  end

  defp unzip_body(body, resp_headers) do
    case body_zipped?(resp_headers) do
      true -> :zlib.gunzip(body)
      false -> body
    end
  end

  defp body_zipped?(resp_headers) do
    resp_headers
    |> Enum.any?(fn
      {"Content-Encoding", "gzip"} -> true
      _ -> false
    end)
  end

  defp decode(body, resp_headers) do
    case json?(resp_headers) do
      true -> Jason.decode!(body)
      false -> body
    end
  end

  defp json?(headers) do
    Enum.any?(headers, fn {header, value} ->
      header == "Content-Type" and String.match?(value, ~r/json/)
    end)
  end

  defp impl, do: Application.get_env(:ten_ex_take_home, :http_client, HTTPoison)
end
