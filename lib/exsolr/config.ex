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
end

