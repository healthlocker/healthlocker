defmodule Healthlocker.CaseloadController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    hl_patients = ["Nyasia Dooley", "Brandt Herta",
                "Edmund Cleveland", "Tania Precious",
                "Mikayla Marks", "Lamar Major",
                "Kristopher Gutmann", "Andre Hintz",
                "Chanel Kamren", "Gabriella Smith"]
    non_hl_patients = ["Angela Hernandez", "Marcella May",
                "Chad Moody", "Jim Flores", "Bruce Bowers",
                "Kevin Patterson", "Evan Burns", "Jeremy Pope",
                "Lisa Sandoval", "Shane Austin"]
    render(conn, "index.html", hl_patients: hl_patients,
                  non_hl_patients: non_hl_patients)
  end
end
