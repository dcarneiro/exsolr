defmodule ExsolrTest do
  use ExUnit.Case, async: true
  doctest Exsolr

  test "get a document" do
    Exsolr.get(q: "roses")
  end

  test "add a document" do
    document = %{id: "3", title: "Doc 3" }
    Exsolr.add(document)
  end

  test "delete a document by id" do
    Exsolr.delete_by_id(3)
  end

  test "commit" do
    assert Exsolr.commit
  end
end
