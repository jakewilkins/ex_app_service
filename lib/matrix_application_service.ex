defmodule MatrixApplicationService do
  def authorize_homeserver(%{"access_token" => at}) do
    case at == homeserver_token() do
      true -> :valid
      _ -> :invalid_session
    end
  end
  def authorize_homeserver(_), do: :session_not_supplied

  def application_service_token do
    Application.get_env(:matrix_application_service,
      :application_service_token)
  end

  defp homeserver_token do
    Application.get_env(:matrix_application_service, :homeserver_token)
  end
end
