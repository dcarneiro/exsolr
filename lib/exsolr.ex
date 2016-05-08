defmodule Exsolr do
  @moduledoc """
  Solr wrapper made in Elixir.
  """

  alias Exsolr.Indexer

  @doc """
  Adds the `document` to Solr.
  """
  def add(document) do
    Indexer.add(document)
  end

  @doc """
  Commits the pending changes to Solr
  """
  def commit do
    Indexer.commit
  end

  @doc """
  Delete all the documents from the Solr index

  https://wiki.apache.org/solr/FAQ#How_can_I_delete_all_documents_from_my_index.3F
  """
  def delete_all do
    Indexer.delete_all
  end
end
