Code.require_file "../test_helper.exs", __DIR__

defmodule Kernel.DocsTest do
  use ExUnit.Case

  test "compiled with docs" do
    defmodule Docs do
      @moduledoc "moduledoc"

      defp private, do: 1
      defp __struct__, do: %{}

      @doc "Some example"
      def example(false), do: 0
      def example(var),   do: var && private

      def nodoc(var \\ 0)
      def nodoc(_), do: 2

      def struct(%Docs{}), do: %{}
    end

    expected = [
      {{:example, 1}, 14, :def, [{:var, [line: 15], nil}], "Some example"},
      {{:nodoc, 1}, 17, :def, [{:\\, [line: 17], [{:var, [line: 17], nil}, 0]}], nil},
      {{:struct, 1}, 20, :def, [{:docs, [line: 20], nil}], nil}
    ]

    assert Docs.__info__(:docs) == expected
    assert Docs.__info__(:moduledoc) == { 7, "moduledoc" }
  end


  test "compiled without docs" do
    Code.compiler_options(docs: false)

    defmodule NoDocs do
      @moduledoc "moduledoc"

      @doc "Some example"
      def example(var), do: var
    end

    assert NoDocs.__info__(:docs) == nil
    assert NoDocs.__info__(:moduledoc) == nil
  after
    Code.compiler_options(docs: true)
  end
end
