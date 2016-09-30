defmodule Analytics.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Analytics.Server, [])
    ]
    # |> processor(3)
    
    supervise(children, strategy: :one_for_one)
  end

  def processor(list, n) do
    temp = for i <- 0..n do
      worker(Analytics.Processor, [], id: "Processor #{i}")
    end

    list ++ temp
  end
end