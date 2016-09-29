defmodule Analytics do
  use Application


  def start(_type, _args) do
    Analytics.Supervisor.start_link
  end
end