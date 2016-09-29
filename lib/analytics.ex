defmodule Analytics do
  use Application

  def start(_type, _args) do
    IO.puts "Starting application!"
    { :ok, pid } = :elli.start_link([ callback: Analytics.Server, port: 1234])
  end
end