defmodule Healthlocker.Analytics.Local do
  @behaviour Healthlocker.Analytics
  require Logger

  def identify(user_id, _traits) do
    Logger.info "identify(#{user_id})"
  end

  def track(user_id, event_name, properties) do
    Logger.info ~s(Local track: user_id="#{user_id}" event_name="#{event_name}" properties=#{inspect properties})
  end
end
