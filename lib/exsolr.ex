defmodule Exsolr do
  @moduledoc """
  Solr wrapper made in Elixir.
  """

  alias Exsolr.Config
  alias Exsolr.Indexer
  alias Exsolr.Searcher

  @doc """
  Returns a map containing the solr connection info

  ## Examples

      iex> Exsolr.info
      %{hostname: "localhost", port: 8983, core: "elixir_test"}
  """
  def info do
    Config.info
  end

  @doc """
  Send a search request to Solr
  """
  def get(query_params) do
    Searcher.get(query_params)
  end

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
  Delete the document with id `id` from the solr index
  """
  def delete_by_id(id) do
    Indexer.delete_by_id(id)
  end

  @doc """
  Delete all the documents from the Solr index

  https://wiki.apache.org/solr/FAQ#How_can_I_delete_all_documents_from_my_index.3F
  """
  def delete_all do
    Indexer.delete_all
  end
end
