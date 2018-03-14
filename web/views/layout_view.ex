defmodule Healthlocker.LayoutView do
  use Healthlocker.Web, :view
  alias Healthlocker.Repo

  def segment_snippet do
    if segment_write_key(), do: render(Healthlocker.LayoutView, "_segment.html")
  end

  def segment? do
    !!System.get_env("SEGMENT_WRITE_KEY")
  end

  defp segment_write_key do
    System.get_env("SEGMENT_WRITE_KEY")
  end

  def care_team?(user) do
    user = user |> Repo.preload(:caring)

    case user.caring do
      [] ->
        case user.role do
          "carer" -> true
          _ -> false
        end
      _ -> true
    end
  end

  def nav_bar_classes(list, "account-security") do
    case Enum.member?(list, "account") || Enum.member?(list, "security") do
      true -> "f3 white-80 db hover-white b"
      false -> "f3 white-80 db hover-white"
    end
  end

  def nav_bar_classes(list, string) do
    if string === "home" && list === [] do
      "f3 white-80 db hover-white b"
    else
      case Enum.member?(list, string) do
        true -> "f3 white-80 db hover-white b"
        false -> "f3 white-80 db hover-white"
      end
    end
  end
end
