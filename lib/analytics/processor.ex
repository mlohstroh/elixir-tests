defmodule Analytics.Processor do
  @redis_key "analytics:jobs"
  def start_link do
    # ignored num for now
    { :ok, client } = Exredis.start_link
    pid = spawn_link(__MODULE__, :work, [client])
    { :ok, pid }
  end

  def work(redis) do
    try do
      case next_job(redis) do
        :undefined ->
          wait
        json ->
          json
          |> perform_job
      end
    rescue
      e -> IO.puts inspect(e)
    end
    work(redis)
  end

  def wait do
    :timer.sleep(5000)
  end

  def next_job(redis) do
    redis
    |> Exredis.Api.rpop(@redis_key)
  end

  def perform_job(events) do
    IO.puts "Performing job..."
  end
end