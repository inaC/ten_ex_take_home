defmodule TenExTakeHome.Marvel do
  @moduledoc """
  Marvel domain.
  """

  @characters_cache Application.compile_env(:ten_ex_take_home, :marvel_characters_cache)

  alias TenExTakeHome.Cache
  alias TenExTakeHome.Marvel.Client

  @doc """
  Returns marvel characters

  ## Examples

      iex> TenExTakeHome.Marvel.Client.list_characters()
      {
        :ok,
        [
          %{
            "comics" => %{
              "available" => 1,
              "collectionURI" =>
                "http://gateway.marvel.com/v1/public/characters/1011334/comics",
              "items" => [
                %{
                  "name" => "Avengers: The Initiative (2007) #14",
                  "resourceURI" => "http://gateway.marvel.com/v1/public/comics/21366"
                }
              ],
              "returned" => 1
            },
            "description" => "",
            "events" => %{
              "available" => 1,
              "collectionURI" =>
                "http://gateway.marvel.com/v1/public/characters/1011334/events",
              "items" => [
                %{
                  "name" => "Secret Invasion",
                  "resourceURI" => "http://gateway.marvel.com/v1/public/events/269"
                }
              ],
              "returned" => 1
            },
            "id" => 1_011_334,
            "modified" => "2014-04-29T14:18:17-0400",
            "name" => "3-D Man",
            "resourceURI" => "http://gateway.marvel.com/v1/public/characters/1011334",
            "series" => %{
              "available" => 1,
              "collectionURI" =>
                "http://gateway.marvel.com/v1/public/characters/1011334/series",
              "items" => [
                %{
                  "name" => "Avengers: The Initiative (2007 - 2010)",
                  "resourceURI" => "http://gateway.marvel.com/v1/public/series/1945"
                }
              ],
              "returned" => 1
            },
            "stories" => %{
              "available" => 1,
              "collectionURI" =>
                "http://gateway.marvel.com/v1/public/characters/1011334/stories",
              "items" => [
                %{
                  "name" => "Cover #19947",
                  "resourceURI" => "http://gateway.marvel.com/v1/public/stories/19947",
                  "type" => "cover"
                }
              ],
              "returned" => 1
            },
            "thumbnail" => %{
              "extension" => "jpg",
              "path" => "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"
            },
            "urls" => [
              %{
                "type" => "detail",
                "url" =>
                  "http://marvel.com/characters/74/3-d_man?utm_campaign=apiRef&utm_source=ccc1f767344154bb74081e8ca6ea8e33"
              },
              %{
                "type" => "wiki",
                "url" =>
                  "http://marvel.com/universe/3-D_Man_(Chandler)?utm_campaign=apiRef&utm_source=ccc1f767344154bb74081e8ca6ea8e33"
              },
              %{
                "type" => "comiclink",
                "url" =>
                  "http://marvel.com/comics/characters/1011334/3-d_man?utm_campaign=apiRef&utm_source=ccc1f767344154bb74081e8ca6ea8e33"
              }
            ]
          }
        ]
      }

  """
  def list_characters do
    case do_list_characters() do
      {:ok, characters} -> characters
      _error -> []
    end
  end

  defp do_list_characters do
    case Cache.all_values(@characters_cache) do
      [] -> add_characters(Client.list_characters())
      characters -> {:ok, characters}
    end
  end

  defp add_characters({:error, _reason} = error), do: error

  defp add_characters({:ok, response}) do
    characters = response["data"]["results"]
    Enum.each(characters, &add_character/1)

    {:ok, characters}
  end

  defp add_character(character) do
    Cache.insert(@characters_cache, character["id"], character)
  end
end
