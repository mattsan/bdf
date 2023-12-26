defmodule BDF.Font.ENCODINGTest do
  use ExUnit.Case, async: true
  alias BDF.Font.ENCODING
  doctest ENCODING

  describe "parse/1" do
    test "valid parameter" do
      assert {:ok, 1234} = ENCODING.parse("ENCODING 1234")
    end

    test "no parameters" do
      assert {:error, ~S'invalid ENCODING parameter: ""'} = ENCODING.parse("ENCODING ")
    end

    test "not integer" do
      assert {:error, ~S'invalid ENCODING parameter: "one-two-three-four"'} =
               ENCODING.parse("ENCODING one-two-three-four")
    end

    test "minus value" do
      assert {:error, ~S'invalid ENCODING parameter: "-1234"'} = ENCODING.parse("ENCODING -1234")
    end
  end
end
