defmodule Exsolr.Searcher do
  @moduledoc """
  Provides search functions to Solr
  """

  alias Exsolr.Config

  @doc """
  Receives the query params, converts them to an url, queries Solr and builds
  the response
  """
  def get(params) do
    params
    |> build_solr_query
    |> do_search
    # |> build_response
  end

  @doc """
  Builds the solr url query

  ## Examples

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"])
      "?q=roses&fq=blue&fq=violet"

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], start: 0, rows: 10)
      "?q=roses&fq=blue&fq=violet&start=0&rows=10"

  """
  def build_solr_query(params) do
    "?#{build_solr_query_params(params)}"
  end

  defp build_solr_query_params(params) do
    params
    |> Enum.map(fn({key, value}) -> build_solr_query_part(key, value) end)
    |> Enum.join("&")
  end

  defp build_solr_query_part(_, []), do: nil
  defp build_solr_query_part(key, [head|tail]) do
    [build_solr_query_part(key, head), build_solr_query_part(key, tail)]
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.join("&")
  end
  defp build_solr_query_part(key, value) do
    [Atom.to_string(key), value]
    |> Enum.join("=")
  end

  def do_search(solr_query) do
    solr_query
    |> build_solr_url
    |> HTTPoison.get
  end

  defp build_solr_url(solr_query) do
    Config.select_url <> solr_query
  end
end