defmodule Analytics.Collector do
  # Expects a JSON array as a string
  def collect(events) do
    # {:ok, client } = Exredis.start_link
    # client 
    # |> Exredis.Api.lpush("analytics:jobs", events)

    # client |> Exredis.stop
    spawn(__MODULE__, :send_to_redis, [events])
  end

  def send_to_redis(events) do
    {:ok, client } = Exredis.start_link
    client 
    |> Exredis.Api.lpush("analytics:jobs", events)

    client |> Exredis.stop
  end
end