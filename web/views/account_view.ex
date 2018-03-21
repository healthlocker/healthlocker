defmodule Healthlocker.AccountView do
  use Healthlocker.Web, :view
  import Healthlocker.LayoutView, only: [care_team?: 1]

  @default_classes "link dib fl black tc pv1"
  @selected " bb b--hl-aqua"
  @unselected " bg-white"

  def create_selected_link(text, path, classes \\ "") do
    link(text, to: path, class: @default_classes <> @selected <> classes)
  end

  def create_link(text, path, classes \\ "") do
    link(text, to: path, class: @default_classes <> @unselected <> classes)
  end

  def generate_menu(conn) do
    user_role = conn.assigns.current_user.role
    path = conn.request_path

    if user_role != "clinician" do
      case path do
        "/account" -> [
          create_selected_link("Profile", account_path(conn, :index), " w-33"),
          create_link("Security", page_path(conn, :show, "security"), " w-33"),
          create_link("Consent", account_path(conn, :consent), " w-33")
        ]
        "/pages/security" -> [
          create_link("Profile", account_path(conn, :index), " w-33"),
          create_selected_link("Security", page_path(conn, :show, "security"), " w-33"),
          create_link("Consent", account_path(conn, :consent), " w-33")
        ]
        "/account/consent" -> [
          create_link("Profile", account_path(conn, :index), " w-33"),
          create_link("Security", page_path(conn, :show, "security"), " w-33"),
          create_selected_link("Consent", account_path(conn, :consent), " w-33")
        ]
      end
    else
      case path do
        "/account" -> [
          create_selected_link("Profile", account_path(conn, :index), " w-50"),
          create_link("Consent", account_path(conn, :consent), " w-50")
        ]
        "/account/consent" -> [
          create_link("Profile", account_path(conn, :index), " w-50"),
          create_selected_link("Consent", account_path(conn, :consent), " w-50")
        ]
      end
    end
  end
end
