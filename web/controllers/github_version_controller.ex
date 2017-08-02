defmodule Healthlocker.GithubVersionController do
  use Healthlocker.Web, :controller

  def index(conn, _params) do
    IO.inspect(conn)
    # leaving IO.inspect / puts in for debugging till further notice
    IO.inspect(System.cmd("pwd", []))
    {ls, _} = IO.inspect(System.cmd("ls", ["-a"]))
    IO.inspect ls
    ls = String.split(ls, "\n")
    IO.inspect ls

    unless Enum.member?(ls, ".git") do
      File.cd("./builds")
      IO.inspect(System.cmd("pwd", []))
    end

    {rev, _} = System.cmd("git", ["rev-parse", "HEAD"])
    IO.puts(String.replace(rev, "\n", ""))
    text conn, String.replace(rev, "\n", "")
  end
end
