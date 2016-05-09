# Exsolr

Rude try to convert the indexing part of RSolr to Elixir

## Installation

  1. Add exsolr to your list of dependencies in `mix.exs`:

        def deps do
          [{:exsolr, git: "http://github.com/dcarneiro/exsolr"}]
        end

  2. Ensure exsolr is started before your application:

        def application do
          [applications: [:exsolr]]
        end

## Configuration

The default behaviour is to configure using the config file:

In `config/config.exs`, add:

        config :exsolr,
          hostname: "localhost",
          port: 8983,
          core: "elixir_test"

## Indexing documents into Solr

Single document via #add

        Exsolr.add(%{id: 1, price: 1.00})

Multiple documents via #add

        [%{id: 1, price: 1.00}, %{id: 2, price: 10.50}]
        |> Exsolr.add

Force a commit into Solr

        Exsolr.commit

## Deleting

Delete by id

        Exsolr.delete_by_id("1")

Delete all the documents from the core

        Exsolr.delete_all