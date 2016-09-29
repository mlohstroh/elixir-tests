defmodule Analytics.Server do
  @port 1234
  @behaviour :elli_handler
  require Logger
  
  require Record
  import Record, only: [defrecord: 2, extract: 2]
  defrecord :req, extract(:req, from_lib: "elli/include/elli.hrl")

  def start_link do
    :elli.start_link([ callback: Analytics.Server, port: @port])
  end

  def handle(req, _args) do
    method = :elli_request.method(req)
    path = :elli_request.path(req)
    |> full_path
    { _code, _args, _response } = handle(method, path, req)
  end

  def handle(:GET, "/", req) do
    name = :elli_request.get_arg_decoded("name", req, "Anonymous")
    { :ok, [], "Your name is #{name}"}
  end

  def handle(_, _, _req) do
    { 404, [], "Not Found" }
  end

  def handle_event(:request_error, [_req, exception, stack ], _args) do
    IO.puts "An error occured: #{inspect(exception)}"
    IO.puts "Stack: #{stack}"
    :ok
  end

  def handle_event(:request_complete, [request, code, _headers, _body, timings], _) do
    method = :elli_request.method(request)
    path = :elli_request.path(request)
    |> full_path
    { _,request_start } = :lists.keyfind(:request_start, 1, timings)
    { _, request_end } = :lists.keyfind(:request_end, 1, timings)
    diff = :timer.now_diff(request_end, request_start)
    Logger.info "#{method} \"#{path}\" #{code} - #{diff}μs"
    :ok
  end

  def handle_event(_event, _data, _args) do
    :ok
  end

  def full_path(path) do
    "/#{Enum.join(path, "/")}"
  end
end