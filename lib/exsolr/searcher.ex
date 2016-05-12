defmodule Exsolr.Searcher do
  @moduledoc """
  Provides search functions to Solr
  """

  require Logger
  require IEx

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
  Builds the solr url query. If the `wt` parameter is not specified, it defaults
  it to `json.

  ## Examples

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"])
      "?q=roses&fq=blue&fq=violet&wt=json"

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], start: 0, rows: 10)
      "?q=roses&fq=blue&fq=violet&start=0&rows=10&wt=json"

      iex> Exsolr.Searcher.build_solr_query(q: "roses", fq: ["blue", "violet"], wt: "xml")
      "?q=roses&fq=blue&fq=violet&wt=xml"

  """
  def build_solr_query(params) do
    "?" <> build_solr_query_params(params)
  end

  defp build_solr_query_params(params) do
    params
    |> add_default_params
    |> Enum.map(fn({key, value}) -> build_solr_query_part(key, value) end)
    |> Enum.join("&")
  end

  # I'm having a difficult time to dynamically add default values to the params
  # Since for now is just wt: json, lets hardcode it :(
  defp add_default_params(params) do
    if List.keyfind(params, :wt, 0) do
      params
    else
      params ++ [wt: "json"]
    end
    # default_params = %{wt: "json"}
    # Enum.map(default_params, fn(key, value) -> add_default_param(params, key, value) end)
  end

  # defp add_default_param(params, key, value) do
  #   if List.keyfind(params, key, 0) do
  #     params
  #   else
  #     params ++ [key, value]
  #   end
  # end

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
    url = Config.select_url <> solr_query
    Logger.debug url
    url
  end
end