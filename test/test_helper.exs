ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(TenExTakeHome.Repo, :manual)
Hammox.defmock(TenExTakeHome.MockHttpClient, for: TenExTakeHome.HttpClient.Behaviour)
Application.put_env(:ten_ex_take_home, :http_client, TenExTakeHome.MockHttpClient)
