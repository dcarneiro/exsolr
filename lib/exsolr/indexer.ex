defmodule Exsolr.Indexer do
  require Logger

  def add(document) do
    HTTPoison.post(json_docs_update_url, body(document), json_headers)
    |> handle_http_poison_response
  end

  @doc """
  Function to delete all documents from the Solr Index
  """
  def delete_all do
    update_request(xml_headers, delete_all_xml_body)
    commit
  end

  @doc """
  Commit changes into Solr
  """
  def commit do
    update_request(xml_headers, commit_xml_body)
  end

  defp update_request(headers, body) do
    HTTPoison.post(update_url, body, headers)
    |> handle_http_poison_response
  end

  defp handle_http_poison_response({status, response}) do
    case {status, response} do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        Logger.debug response_body
        true
      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        Logger.warn "status_code: #{status_code} - #{response_body}"
        false
      {_, %HTTPoison.Error{id: _, reason: error_reason}} ->
        Logger.error error_reason
        false
    end
  end

  defp json_headers, do: [{"Accept", "application/json"}]
  defp xml_headers, do: [{"Content-type", "text/xml; charset=utf-8"}]
  defp delete_all_xml_body, do: "<delete><query>*:*</query></delete>"
  defp commit_xml_body, do: "<commit/>"

  defp json_docs_update_url, do: "#{update_url}/json/docs"
  defp update_url, do: "http://localhost:8983/solr/#{solr_core}/update"
  defp solr_core, do: "elixir_test"

  defp body(document) do
    {:ok, body} = Poison.encode(document)
    body
  end
end