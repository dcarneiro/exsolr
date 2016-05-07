defmodule ExsolrTest do
  use ExUnit.Case
  doctest Exsolr

  # curl -X POST -H 'Content-Type: application/json' 'http://localhost:8983/solr/my_collection/update/json/docs' --data-binary '
  # {
  #   "id": "1",
  #   "title": "Doc 1"
  # }'
  test "add a document" do
    document = %{id: "3", title: "Doc 3" }
    Exsolr.add(document)
  end

  test "commit" do
    assert Exsolr.commit
  end
end
