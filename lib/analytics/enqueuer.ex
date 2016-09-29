defmodule Analytics.Enqueuer do
  # Expects a JSON array as a string
  def enqueue(events) do
    spawn(__MODULE__, :send_to_redis, [events])
  end

  def send_to_redis(events) do
    {:ok, client } = Exredis.start_link
    Exredis.Api.lpush("analytics:jobs", events)
  end
end