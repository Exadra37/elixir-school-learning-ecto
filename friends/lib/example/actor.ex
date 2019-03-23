defmodule Example.Actor do
  use Ecto.Schema

  schema "actors" do
    field :name, :string
    many_to_many :movies, Example.Movie, join_through: "Movies_Actors"
  end
end
