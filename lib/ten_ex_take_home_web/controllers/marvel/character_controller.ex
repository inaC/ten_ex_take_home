defmodule TenExTakeHomeWeb.Marvel.CharacterController do
  use TenExTakeHomeWeb, :controller

  alias TenExTakeHome.Marvel

  def index(conn, _params) do
    characters = Marvel.list_characters()
    render(conn, :index, characters: characters)
  end
end
