# ELIXIR SCHOOL - ECTO

From https://elixirschool.com.

## Lessons

* [Ecto Basics](https://elixirschool.com/en/lessons/ecto/basics).
* [Ecto Changesets](https://elixirschool.com/en/lessons/ecto/changesets).
* [Ecto Associations](https://elixirschool.com/en/lessons/ecto/associations/).


## VERSIONS

### Phoenix

```bash
╭─elixir@6da418c1ce55 ~/workspace  ‹basics*›
╰─$ mix phx.new --version
Phoenix v1.4.2
```

### Elixir

```bash
╭─elixir@6da418c1ce55 ~/workspace  ‹basics*›
╰─$ elixir --version
Erlang/OTP 21 [erts-10.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Elixir 1.8.1 (compiled with Erlang/OTP 21)

```

## ISSUES

* [Error When Starting IEX in Ecto Lessons](https://github.com/elixirschool/elixirschool/issues/1755).
* [Ecto lesson on changesets could use the Example.Person module instead of the User module ](https://github.com/elixirschool/elixirschool/issues/1756).
* [Possible typo in functions arity on lesson about Ecto Changeset Custom Validators](https://github.com/elixirschool/elixirschool/issues/1757).
* [Compile error when running the migrations for the lesson: Ecto Associations - The Belongs To Migration](https://github.com/elixirschool/elixirschool/issues/1758).


## ECTO ASSOCIATIONS

```bash
╭─elixir@6da418c1ce55 ~/workspace/friends  ‹associations*›
╰─$ iex -S mix
Erlang/OTP 21 [erts-10.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.8.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> alias Example.{Movie, Character, Repo}
[Example.Movie, Example.Character, Example.Repo]
iex(2)> movie = %Movie{title: "Ready Player One", tagline: "Something about video games"}
%Example.Movie{
  __meta__: #Ecto.Schema.Metadata<:built, "movies">,
  actors: #Ecto.Association.NotLoaded<association :actors is not loaded>,
  characters: #Ecto.Association.NotLoaded<association :characters is not loaded>,
  distributor: #Ecto.Association.NotLoaded<association :distributor is not loaded>,
  id: nil,
  tagline: "Something about video games",
  title: "Ready Player One"
}
iex(3)> movie = Repo.insert! movie

20:27:37.922 [debug] QUERY OK db=0.2ms
begin []

20:27:37.932 [debug] QUERY OK db=1.2ms
INSERT INTO "movies" ("tagline","title") VALUES ($1,$2) RETURNING "id" ["Something about video games", "Ready Player One"]

20:27:37.934 [debug] QUERY OK db=1.7ms
commit []
%Example.Movie{
  __meta__: #Ecto.Schema.Metadata<:loaded, "movies">,
  actors: #Ecto.Association.NotLoaded<association :actors is not loaded>,
  characters: #Ecto.Association.NotLoaded<association :characters is not loaded>,
  distributor: #Ecto.Association.NotLoaded<association :distributor is not loaded>,
  id: 1,
  tagline: "Something about video games",
  title: "Ready Player One"
}
iex(4)> character = Ecto.build_assoc(movie, :characters, %{name: "Wade Watts"})
%Example.Character{
  __meta__: #Ecto.Schema.Metadata<:built, "characters">,
  id: nil,
  movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
  movie_id: 1,
  name: "Wade Watts"
}
iex(5)> distributor = Ecto.build_assoc(movie, :distributor, %{name: "Netflix"})
%Example.Distributor{
  __meta__: #Ecto.Schema.Metadata<:built, "distributors">,
  id: nil,
  movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
  movie_id: 1,
  name: "Netflix"
}
iex(6)> Repo.insert! character

20:35:05.366 [debug] QUERY OK db=0.6ms queue=0.2ms
begin []

20:35:05.374 [debug] QUERY OK db=7.5ms
INSERT INTO "characters" ("movie_id","name") VALUES ($1,$2) RETURNING "id" [1, "Wade Watts"]

20:35:05.377 [debug] QUERY OK db=3.0ms
commit []
%Example.Character{
  __meta__: #Ecto.Schema.Metadata<:loaded, "characters">,
  id: 1,
  movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
  movie_id: 1,
  name: "Wade Watts"
}
iex(7)> Repo.insert! distributor

20:35:23.320 [debug] QUERY OK db=0.6ms queue=0.5ms
begin []

20:35:23.328 [debug] QUERY OK db=7.8ms
INSERT INTO "distributors" ("movie_id","name") VALUES ($1,$2) RETURNING "id" [1, "Netflix"]

20:35:23.332 [debug] QUERY OK db=2.7ms
commit []
%Example.Distributor{
  __meta__: #Ecto.Schema.Metadata<:loaded, "distributors">,
  id: 1,
  movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
  movie_id: 1,
  name: "Netflix"
}
iex(8)> alias Example.Actor
Example.Actor
iex(9)> actor = %Actor{name: "Tyler Sheridan"}
%Example.Actor{
  __meta__: #Ecto.Schema.Metadata<:built, "actors">,
  id: nil,
  movies: #Ecto.Association.NotLoaded<association :movies is not loaded>,
  name: "Tyler Sheridan"
}
iex(10)> actor = Repo.insert!(actor)

20:40:54.951 [debug] QUERY OK db=0.5ms queue=0.2ms
begin []

20:40:54.956 [debug] QUERY OK db=4.8ms
INSERT INTO "actors" ("name") VALUES ($1) RETURNING "id" ["Tyler Sheridan"]

20:40:54.959 [debug] QUERY OK db=2.1ms
commit []
%Example.Actor{
  __meta__: #Ecto.Schema.Metadata<:loaded, "actors">,
  id: 1,
  movies: #Ecto.Association.NotLoaded<association :movies is not loaded>,
  name: "Tyler Sheridan"
}
iex(11)> movie = Repo.preload(movie, [:distributor, :characters, :actors])

20:42:24.901 [debug] QUERY OK source="actors" db=2.1ms queue=0.1ms
SELECT a0."id", a0."name", m1."id" FROM "actors" AS a0 INNER JOIN "movies" AS m1 ON m1."id" = ANY($1) INNER JOIN "movies_actors" AS m2 ON m2."movie_id" = m1."id" WHERE (m2."actor_id" = a0."id") ORDER BY m1."id" [[1]]

20:42:24.903 [debug] QUERY OK source="distributors" db=1.1ms decode=2.7ms queue=0.2ms
SELECT d0."id", d0."name", d0."movie_id", d0."movie_id" FROM "distributors" AS d0 WHERE (d0."movie_id" = $1) [1]

20:42:24.903 [debug] QUERY OK source="characters" db=2.2ms decode=1.8ms queue=0.2ms
SELECT c0."id", c0."name", c0."movie_id", c0."movie_id" FROM "characters" AS c0 WHERE (c0."movie_id" = $1) ORDER BY c0."movie_id" [1]
%Example.Movie{
  __meta__: #Ecto.Schema.Metadata<:loaded, "movies">,
  actors: [],
  characters: [
    %Example.Character{
      __meta__: #Ecto.Schema.Metadata<:loaded, "characters">,
      id: 1,
      movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
      movie_id: 1,
      name: "Wade Watts"
    }
  ],
  distributor: %Example.Distributor{
    __meta__: #Ecto.Schema.Metadata<:loaded, "distributors">,
    id: 1,
    movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
    movie_id: 1,
    name: "Netflix"
  },
  id: 1,
  tagline: "Something about video games",
  title: "Ready Player One"
}
iex(12)> movie_changeset = Ecto.Changeset.change movie
#Ecto.Changeset<action: nil, changes: %{}, errors: [], data: #Example.Movie<>,
 valid?: true>
iex(13)> movie_actors_changeset = movie_changeset |> Ecto.Changeset.put_assoc :actors, [actor]
warning: parentheses are required when piping into a function call. For example:

    foo 1 |> bar 2 |> baz 3

is ambiguous and should be written as

    foo(1) |> bar(2) |> baz(3)

Ambiguous pipe found at:
  iex:13

#Ecto.Changeset<
  action: nil,
  changes: %{
    actors: [
      #Ecto.Changeset<action: :update, changes: %{}, errors: [],
       data: #Example.Actor<>, valid?: true>
    ]
  },
  errors: [],
  data: #Example.Movie<>,
  valid?: true
>
iex(14)> movie_actors_changeset = movie_changeset |> Ecto.Changeset.put_assoc(:actors, [actor])
#Ecto.Changeset<
  action: nil,
  changes: %{
    actors: [
      #Ecto.Changeset<action: :update, changes: %{}, errors: [],
       data: #Example.Actor<>, valid?: true>
    ]
  },
  errors: [],
  data: #Example.Movie<>,
  valid?: true
>
iex(15)> Repo.update! movie_
movie_actors_changeset    movie_changeset
iex(15)> Repo.update! movie_
movie_actors_changeset    movie_changeset
iex(15)> Repo.update! movie_actors_changeset

20:46:47.935 [debug] QUERY OK db=0.5ms queue=0.1ms
begin []

20:46:47.942 [debug] QUERY OK db=1.7ms
INSERT INTO "movies_actors" ("actor_id","movie_id") VALUES ($1,$2) [1, 1]

20:46:47.944 [debug] QUERY OK db=2.1ms
commit []
%Example.Movie{
  __meta__: #Ecto.Schema.Metadata<:loaded, "movies">,
  actors: [
    %Example.Actor{
      __meta__: #Ecto.Schema.Metadata<:loaded, "actors">,
      id: 1,
      movies: #Ecto.Association.NotLoaded<association :movies is not loaded>,
      name: "Tyler Sheridan"
    }
  ],
  characters: [
    %Example.Character{
      __meta__: #Ecto.Schema.Metadata<:loaded, "characters">,
      id: 1,
      movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
      movie_id: 1,
      name: "Wade Watts"
    }
  ],
  distributor: %Example.Distributor{
    __meta__: #Ecto.Schema.Metadata<:loaded, "distributors">,
    id: 1,
    movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
    movie_id: 1,
    name: "Netflix"
  },
  id: 1,
  tagline: "Something about video games",
  title: "Ready Player One"
}
iex(16)>
nil
iex(17)> changeset = movie_changeset |> Ecto.Changeset.put_assoc(:actors, [%{name: "Gary"}])
#Ecto.Changeset<
  action: nil,
  changes: %{
    actors: [
      #Ecto.Changeset<
        action: :insert,
        changes: %{name: "Gary"},
        errors: [],
        data: #Example.Actor<>,
        valid?: true
      >
    ]
  },
  errors: [],
  data: #Example.Movie<>,
  valid?: true
>
iex(18)> Repo.update!(changeset)

20:50:49.200 [debug] QUERY OK db=0.6ms queue=0.1ms
begin []

20:50:49.205 [debug] QUERY OK db=3.9ms
INSERT INTO "actors" ("name") VALUES ($1) RETURNING "id" ["Gary"]

20:50:49.210 [debug] QUERY OK db=5.0ms
INSERT INTO "movies_actors" ("actor_id","movie_id") VALUES ($1,$2) [2, 1]

20:50:49.213 [debug] QUERY OK db=2.6ms
commit []
%Example.Movie{
  __meta__: #Ecto.Schema.Metadata<:loaded, "movies">,
  actors: [
    %Example.Actor{
      __meta__: #Ecto.Schema.Metadata<:loaded, "actors">,
      id: 2,
      movies: #Ecto.Association.NotLoaded<association :movies is not loaded>,
      name: "Gary"
    }
  ],
  characters: [
    %Example.Character{
      __meta__: #Ecto.Schema.Metadata<:loaded, "characters">,
      id: 1,
      movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
      movie_id: 1,
      name: "Wade Watts"
    }
  ],
  distributor: %Example.Distributor{
    __meta__: #Ecto.Schema.Metadata<:loaded, "distributors">,
    id: 1,
    movie: #Ecto.Association.NotLoaded<association :movie is not loaded>,
    movie_id: 1,
    name: "Netflix"
  },
  id: 1,
  tagline: "Something about video games",
  title: "Ready Player One"
}

```
