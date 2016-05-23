defmodule Exsolr.HttpResponse do
  @moduledoc """
  Isolate the handling of Solr HTTP responses.
  """

  require Logger

  def body({status, response}) do
    case {status, response} do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        _ = Logger.debug response_body
        response_body
      {:ok, %HTTPoison.Response{status_code: status_code, body: response_body}} ->
        _ = Logger.warn "status_code: #{status_code} - #{response_body}"
        nil
      {_, %HTTPoison.Error{id: _, reason: error_reason}} ->
        _ = Logger.error error_reason
        nil
    end
  end
end
