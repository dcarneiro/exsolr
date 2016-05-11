defmodule Exsolr.Indexer do
  @moduledoc """
  Provides functions that write documents to Solr
  """

  require Logger

  alias Exsolr.Config

  def add(document) do
    json_docs_update_url
    |> HTTPoison.post(encode(document), json_headers)
    |> handle_http_poison_response
  end

  @doc """
  Delete the document with id `id` from the solr index

  From the Solr docs:

  The JSON update format allows for a simple delete-by-id. The value of a delete
  can be an array which contains a list of zero or more specific document id's
  (not a range) to be deleted. For example, a single document:

    { "delete": { "id": "myid" } }

  https://cwiki.apache.org/confluence/display/solr/Uploading+Data+with+Index+Handlers#UploadingDatawithIndexHandlers-JSONFormattedIndexUpdates
  """
  def delete_by_id(id) do
    update_request(json_headers, delete_by_id_json_body(id))
  end

  @doc """
  Function to delete all documents from the Solr Index

  https://wiki.apache.org/solr/FAQ#How_can_I_delete_all_documents_from_my_index.3F
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
    Config.update_url
    |> HTTPoison.post(body, headers)
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

  defp json_headers, do: [{"Content-Type", "application/json"}]
  defp xml_headers, do: [{"Content-type", "text/xml; charset=utf-8"}]

  @doc """
  Builds the delete_by_id request body

  ## Examples

      iex> Exsolr.Indexer.delete_by_id_json_body(27)
      ~s({"delete":{"id":"27"}})

      iex> Exsolr.Indexer.delete_by_id_json_body("42")
      ~s({"delete":{"id":"42"}})

  """
  def delete_by_id_json_body(id) when is_integer(id)  do
    id
    |> Integer.to_string()
    |> delete_by_id_json_body
  end
  def delete_by_id_json_body(id) do
    {:ok, body} = %{delete: %{id: id}}
                  |> Poison.encode

    body
  end

  defp delete_all_xml_body, do: "<delete><query>*:*</query></delete>"
  defp commit_xml_body, do: "<commit/>"

  defp json_docs_update_url, do: "#{Config.update_url}/json/docs"

  defp encode(document) do
    {:ok, body} = Poison.encode(document)
    body
  end
end