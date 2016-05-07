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

