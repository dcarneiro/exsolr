defmodule Exsolr.Indexer do
  require Logger
  # curl -X POST -H 'Content-Type: application/json' 'http://localhost:8983/solr/my_collection/update/json/docs' --data-binary '
  # {
  #   "id": "1",
  #   "title": "Doc 1"
  # }'

  def add(document) do
    case HTTPoison.post(json_docs_url, body(document), [{"Accept", "application/json"}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        Logger.debug response_body
        true
      {_, %HTTPoison.Error{id: _, reason: error_reason}} ->
        Logger.error error_reason
        false
    end
  end

  def commit do
    case HTTPoison.get("#{url}?commit=true") do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        Logger.debug response_body
        true
      {_, %HTTPoison.Error{id: _, reason: error_reason}} ->
        Logger.error error_reason
        false
    end
  end

  defp json_docs_url do
    "#{url}/json/docs"
  end

  defp url do
    "http://localhost:8983/solr/#{solr_core}/update"
  end

  defp solr_core do
    "elixir_test"
  end

  defp body(document) do
    {:ok, body} = Poison.encode(document)
    body
  end
end