Code.require_file "../../test_helper.exs", __DIR__

defmodule Ecto.Query.FromBuilderTest do
  use ExUnit.Case, async: true

  import Ecto.Query.FromBuilder

  defmodule MyEntity do
    use Ecto.Entity
    table_name :my_entity
  end

  test "escape" do
    assert { :x, MyEntity } ==
           escape(quote do x in MyEntity end, __ENV__)

    assert { :x, MyEntity } ==
           escape(quote do x in Elixir.Ecto.Query.FromBuilderTest.MyEntity end, __ENV__)
  end

  test "escape raise" do
    message = "only `in` expressions binding variables to records allowed in from expressions"

    assert_raise Ecto.InvalidQuery, message, fn ->
      escape(quote do 1 end, __ENV__)
    end

    assert_raise Ecto.InvalidQuery, message, fn ->
      escape(quote do f() end, __ENV__)
    end

    assert_raise Ecto.InvalidQuery, message, fn ->
      escape(quote do x end, __ENV__)
    end

    assert_raise Ecto.InvalidQuery, message, fn ->
      escape(quote do x in y end, __ENV__)
    end

    assert_raise Ecto.InvalidQuery, "`NotAnEntity` is not an Ecto entity", fn ->
      escape(quote do p in NotAnEntity end, __ENV__)
    end
  end
end