defmodule Healthlocker.Analytics do
  @moduledoc """
  This module defines the behaviour required by any Analytics provider
  supported by Healthlocker.
  """

  @type user_id :: String.t
  @type event_name :: String.t
  @type traits :: map
  @type properties :: map

  @callback identify(user_id, traits) :: {:ok, term} | {:error, term}

  @doc """
  Calls `track` in the Analytics implementation.

  Returns either an `:ok` or `:error` tuple
  """
  @callback track(user_id, event_name, properties) :: {:ok, term} | {:error, term}

  # These are the methods for the public interface

  alias Healthlocker.Analytics.EventNameBuilder
  alias Healthlocker.Analytics.PropertiesBuilder

  @api Application.get_env(:healthlocker, :analytics)

  def identify(%Healthlocker.User{} = user) do
    @api.identify(user.id)
  end

  def track(%Healthlocker.User{} = user, action, model) do
    event_name = EventNameBuilder.build(action, model)
    properties = PropertiesBuilder.build(model)
    @api.track(user.id, event_name, properties)
  end
end
