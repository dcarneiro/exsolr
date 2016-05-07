defmodule Exsolr do
  alias Exsolr.Indexer

  def add(document) do
    Indexer.add(document)
  end

  def commit do
    Indexer.commit
  end
end
