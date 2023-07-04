defmodule TenExTakeHome.MarvelTest do
  use TenExTakeHome.DataCase, async: true

  alias TenExTakeHome.{Cache, Marvel}

  import Hammox

  setup context do
    characters_cache = Application.get_env(:ten_ex_take_home, :marvel_characters_cache)
    true = Cache.clear(characters_cache)

    verify_on_exit!(context)
  end

  describe "list_characters/0" do
    test "returns characters" do
      expect(TenExTakeHome.MockHttpClient, :get, fn _url, _header, _options ->
        {:ok, characters_success_response()}
      end)

      assert [
               %{"id" => 1_011_334, "name" => "3-D Man"},
               %{"id" => 1_017_100, "name" => "A-Bomb (HAS)"}
             ] = list_characters()
    end

    test "returns empty list when characters could not be retrieved" do
      expect(TenExTakeHome.MockHttpClient, :get, fn _url, _header, _options ->
        characters_error_response()
      end)

      assert [] = list_characters()
    end

    test "returns cached characters" do
      expect(TenExTakeHome.MockHttpClient, :get, fn _url, _header, _options ->
        {:ok, characters_success_response()}
      end)
      |> expect(:get, 0, fn _url, _header, _options ->
        {:error, %HTTPoison.Error{reason: "some error"}}
      end)

      characters = list_characters()
      characters_cached = list_characters()

      assert characters_cached == characters
    end
  end

  defp characters_success_response do
    characters = File.read!("test/support/fixtures/marvel/characters.json")

    %HTTPoison.Response{
      body: characters,
      status_code: 200,
      headers: [{"Content-Type", "application/json"}]
    }
  end

  defp characters_error_response do
    {:error, %HTTPoison.Error{reason: "some error"}}
  end

  defp list_characters, do: Marvel.list_characters() |> Enum.sort_by(& &1["id"])
end
