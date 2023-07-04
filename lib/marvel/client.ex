defmodule TenExTakeHome.Marvel.Client do
  @moduledoc """
  Client for the Marvel API.
  """

  alias TenExTakeHome.HttpClient
  alias TenExTakeHome.Marvel.Client.Auth

  @base_url "https://gateway.marvel.com/v1/public"

  @doc """
  Fetches marvel characters.

  ## Examples

      iex> TenExTakeHome.Marvel.Client.list_characters()
      {
        :ok,
        %{
          "attributionHTML" =>
            "<a href=\"http://marvel.com\">Data provided by Marvel. © 2023 MARVEL</a>",
          "attributionText" => "Data provided by Marvel. © 2023 MARVEL",
          "code" => 200,
          "copyright" => "© 2023 MARVEL",
          "data" => %{
            "count" => 1,
            "limit" => 1,
            "offset" => 0,
            "results" => [
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
            ],
            "total" => 1562
          },
          "etag" => "d40373050db06143ef9eb93af17e81df5300753c",
          "status" => "Ok"
        }
      }

  """
  def list_characters do
    params = Auth.sign_request()
    headers = [{"Accept", "application/json"}, {"Accept-Encoding", "gzip"}]

    HttpClient.get(@base_url <> "/characters", headers, params: params)
  end
end
