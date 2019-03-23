defmodule Example.Person do

  @moduledoc """
  # Ecto Changesets

  From lesson:

  * https://elixirschool.com/en/lessons/ecto/changesets


  > There a lot of use cases and functionality that we did not cover in this lesson, such as [schemaless changesets](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-schemaless-changesets) that you can use to validate any data; or dealing with side-effects alongside the changeset ([prepare_changes/2](https://hexdocs.pm/ecto/Ecto.Changeset.html#prepare_changes/2)) or working with associations and embeds. We may cover these in a future, advanced lesson, but in the meantime — we encourage to explore [Ecto Changeset’s documentation](https://hexdocs.pm/ecto/Ecto.Changeset.html) for more information.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :name, :string
    field :age, :integer, default: 0
  end

  @doc """
  # Ecto Changesets

  From following this lesson:
    * https://elixirschool.com/en/lessons/ecto/changesets/

  ## Examples

  ### Checking required field

  Passes validation:

    iex> Person.changeset %Person{}, %{name: "Alice"}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "Alice"},
      errors: [],
      data: #Example.Person<>,
      valid?: true
    >

  Fails validation:

    iex> Person.changeset %Person{}, %{name: ""}
    #Ecto.Changeset<
      action: nil,
      changes: %{},
      errors: [name: {"can't be blank", [validation: :required]}],
      data: #Example.Person<>,
      valid?: false
    >

  ### Checking valid length

  Passes validation:

    iex> Person.changeset %Person{}, %{name: "Bo"}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "Bo"},
      errors: [],
      data: #Example.Person<>,
      valid?: true
    >

  Fails validation:

    iex> Person.changeset %Person{}, %{name: "B"}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "B"},
      errors: [
        name: {"should be at least %{count} character(s)",
         [count: 2, validation: :length, min: 2]}
      ],
      data: #Example.Person<>,
      valid?: false
    >

  """
  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
    |> validate_fictional_name()
  end


  @fictional_names ["Black Panther", "Wonder Woman", "Spiderman"]

  @doc """
  # Custom Changeset Validator

  From lesson:

    * https://elixirschool.com/en/lessons/ecto/changesets/#custom-validations

  We use a custom validator here for demo purposes, but the same functionality
  can be achieved by using `validate_inclusion/4`.

  ## Examples

  Passes validation:

    iex(41)> Person.changeset %Person{}, %{name: "Spiderman"}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "Spiderman"},
      errors: [],
      data: #Example.Person<>,
      valid?: true
    >

  Fails validation:

    iex> Person.changeset %Person{}, %{name: "Bob"}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "Bob"},
      errors: [name: {"is not a superhero", []}],
      data: #Example.Person<>,
      valid?: false
    >
  """
  # This looks like it should be a private function
  def validate_fictional_name(changeset) do
    name = get_field(changeset, :name)

    # I would use pattern matching in function headers instead.
    if name in @fictional_names do
      changeset
    else
      add_error(changeset, :name, "is not a superhero")
    end
  end

  # This looks like it should be a private function
  def set_name_if_anonymous(changeset) do
    name = get_field(changeset, :name)

    # I would use pattern matching in function headers instead.
    if is_nil(name) do
      put_change(changeset, :name, "Anonymous")
    else
      changeset
    end
  end

  @doc """
  # Adding changes Programatically to a Changeset

  From lesson:

    * https://elixirschool.com/en/lessons/ecto/changesets/#adding-changes-programatically

  ## Examples

  Allowing an anonymous person:

    iex()> Person.registration_changeset %Person{}, %{}
    #Ecto.Changeset<
      action: nil,
      changes: %{name: "Anonymous"},
      errors: [],
      data: #Example.Person<>,
      valid?: true
    >

  To be used from a dedicated signup helper elsewhere in our app:

    ```elixir
    def sign_up(params) do
      %Person{}
      |> Person.registration_changeset(params)
      |> Repo.insert()
    end
    ```
  """
  def registration_changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> set_name_if_anonymous()
  end

end
