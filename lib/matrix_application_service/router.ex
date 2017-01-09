defmodule MatrixApplicationService.Router do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    conn = fetch_query_params(conn)
    #                  Allows mounting to any endpoint without knowing what it is.
    call(conn.method, [Enum.reverse(conn.path_info) | []], conn, opts)
  end

  #def call("GET", ["_matrix", "app", "r0", "user"], conn, opts) do
  #end
  #def call("GET", ["_matrix", "app", "r0", "alias"], conn, opts) do
  #end

  # return user information to HS on existence and info on this user
  def call("GET", [user_id, "users", _], conn, opts) do
    case MatrixApplicationService.authorize_homeserver(conn.query_params) do
      :valid -> apply_func(conn, Keyword.get(opts, :user_query), %{user_id: user_id})
      :session_not_supplied -> send_resp(conn, 401, "")
      :invalid_session -> send_resp(conn, 403, "")
    end
  end
  # return room information to HS on existence of this room
  def call("GET", [room_alias, "rooms", _], conn, opts) do
    case MatrixApplicationService.authorize_homeserver(conn.query_params) do
      :valid -> apply_func(conn, Keyword.get(opts, :room_query), %{room_alias: room_alias})
      :session_not_supplied -> send_resp(conn, 401, "")
      :invalid_session -> send_resp(conn, 403, "")
    end
  end
  # Receive events from HS
  def call("PUT", [transaction_id, "transactions", _], conn, opts) do
    {body, conn} = conn |> get_body
    case MatrixApplicationService.authorize_homeserver(conn.query_params) do
      :valid -> apply_func(conn, Keyword.get(opts, :transactions), %{transaction_id: transaction_id, body: body})
      :session_not_supplied -> send_resp(conn, 401, "")
      :invalid_session -> send_resp(conn, 403, "")
    end
  end
  def call(_, _, conn, _opts) do
    send_resp(conn, 404, "route unknown")
  end

  defp get_body(conn) do
    {body, conn} = do_read_body(conn)
    json = case body |> Poison.decode do
      {:error, _} -> body
      {:ok, json} -> json
    end
    {json, conn}
  end

  defp apply_func(conn, opt, args \\ %{})
  defp apply_func(conn, opt, args) when is_function(opt) do
    opt.(conn, args)
  end
  defp apply_func(conn, _, _) do
    send_resp(conn, 200, "")
  end

  defp do_read_body(conn, out \\ "")
  defp do_read_body({:ok, body, conn}, out), do: {out <> body, conn}
  defp do_read_body({:more, partial, conn}, out) do
    out = out <> partial
    do_read_body(conn, out)
  end
  defp do_read_body(conn, out) do
    do_read_body(read_body(conn), out)
  end
end
