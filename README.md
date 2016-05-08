# Exsolr

Rude try to convert the index part of RSolr to Elixir

## Installation

  1. Add exsolr to your list of dependencies in `mix.exs`:

        def deps do
          [{:exsolr, git: "http://github.com/dcarneiro/exsolr"}]
        end

  2. Ensure exsolr is started before your application:

        def application do
          [applications: [:exsolr]]
        end

## Indexing documents into Solr

Single document via #add

        Exsolr.add(%{id: 1, price: 1.00})

Multiple documents via #add

        [%{id: 1, price: 1.00}, %{id: 2, price: 10.50}]
        |> Exsolr.add