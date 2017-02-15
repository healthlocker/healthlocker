defmodule Healthlocker.PostsLikes do
  use Ecto.Schema

  schema "posts_likes" do
    belongs_to :posts, Healthlocker.Post
    belongs_to :user, Healthlocker.User
  end
end
