defmodule Exsolr.Config do
  @moduledoc """
  Access the Exsolr configurations
  """

  def hostname do
    Application.get_env(:exsolr, :hostname)
  end

  def port do
    Application.get_env(:exsolr, :port)
  end

  def core do
    Application.get_env(:exsolr, :core)
  end

  @doc """
  Returns the base url to do `select` queries to solr

  ## Examples

      iex> Exsolr.Config.select_url
      "http://localhost:8983/solr/elixir_test/select"

  """
  def select_url, do: "#{base_url}/select"

  @doc """
  Returns the base url to do `update` queries to solr

  ## Examples

      iex> Exsolr.Config.update_url
      "http://localhost:8983/solr/elixir_test/update"
  """
  def update_url, do: "#{base_url}/update"

  defp base_url, do: "http://#{hostname}:#{port}/solr/#{core}"
end

