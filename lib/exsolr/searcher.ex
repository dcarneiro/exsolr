defmodule Exsolr.Searcher do
  @moduledoc """
  Provides search functions to Solr
  """

  require Logger

  alias Exsolr.Config
  alias Exsolr.HttpResponse

  def get do
    get(default_parameters)
  end

  @doc """
  Receives the query params, converts them to an url, queries Solr and builds
  the response
  """
  def get(params) do
    params
    |> build_solr_query
    |> do_search
    |> extract_response
  end

  @doc """
  Builds the solr url query. It will use the following default values if they
  are not specifier

  wt: "json"
  q: "*:*"
  start: 0
  rows: 10

  ## Examples

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"])
      "?wt=json&start=0&rows=10&q=roses&fq=blue&fq=violet"

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], start: 0, rows: 10)
      "?wt=json&q=roses&fq=blue&fq=violet&start=0&rows=10"

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], wt: "xml")
      "?start=0&rows=10&q=roses&fq=blue&fq=violet&wt=xml"

  """
  def build_solr_query(params) do
    "?" <> build_solr_query_params(params)
  end

  defp build_solr_query_params(params) do
    params
    |> add_default_params
    |> Enum.map(fn({key, value}) -> build_solr_query_parameter(key, value) end)
    |> Enum.join("&")
  end

  defp add_default_params(params) do
    default_parameters
    |> Keyword.merge(params)
  end

  defp default_parameters do
    [wt: "json", q: "*:*", start: 0, rows: 10]
  end

  defp build_solr_query_parameter(_, []), do: nil
  defp build_solr_query_parameter(key, [head|tail]) do
    [build_solr_query_parameter(key, head), build_solr_query_parameter(key, tail)]
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.join("&")
  end
  defp build_solr_query_parameter(key, value) do
    [Atom.to_string(key), value]
    |> Enum.join("=")
  end

  def do_search(solr_query) do
    solr_query
    |> build_solr_url
    |> HTTPoison.get
    |> HttpResponse.body
  end

  defp build_solr_url(solr_query) do
    url = Config.select_url <> solr_query
    Logger.debug url
    url
  end

  defp extract_response(solr_response) do
    {:ok, %{"response" => response}} = solr_response |> Poison.decode
    response
  end
end