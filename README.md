# Exsolr

Port of [RSolr](https://github.com/rsolr/rsolr) to Elixir

## Installation

  1. Add exsolr to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exsolr, git: "http://github.com/dcarneiro/exsolr"}]
end
```

  2. Ensure exsolr is started before your application:

        def application do
          [applications: [:exsolr]]
        end

## Configuration

The default behaviour is to configure using the config file:

In `config/config.exs`, add:

```elixir
config :exsolr,
  hostname: "localhost",
  port: 8983,
  core: "elixir_test"
```

## Querying

Use #get to perform a query into Solr. All parameters are optional

```elixir
response = Exsolr.get(q: "roses", fq: ["blue", "violet"])
Enum.map(response["docs"], fn(doc) -> doc["id"] end)
```

The following query fields will have default values if they aren't specified

```elixir
q:     "*:*"
wt:    "json"
start: 0
rows:  10
```

## Indexing documents into Solr

Single document via #add

```elixir
  Exsolr.add(%{id: 1, price: 1.00})
```

Multiple documents via #add

```elixir
  [%{id: 1, price: 1.00}, %{id: 2, price: 10.50}]
  |> Exsolr.add
```

Force a commit into Solr

```elixir
Exsolr.commit
```

## Deleting

Delete by id

```elixir
Exsolr.delete_by_id("1")
```

Delete all the documents from the core

```elixir
Exsolr.delete_all
```
