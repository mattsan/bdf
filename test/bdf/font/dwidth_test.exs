defmodule BDF.Font.DWIDTHTest do
  use ExUnit.Case, async: true
  alias BDF.Font.DWIDTH
  doctest DWIDTH

  test "new/0" do
    assert %DWIDTH{dwx0: 0, dwy0: 0} = DWIDTH.new()
  end

  test "new/2" do
    assert %DWIDTH{dwx0: 123, dwy0: 456} = DWIDTH.new(123, 456)
  end

  describe "parse/1" do
    test "valid parameters" do
      assert {:ok, %DWIDTH{dwx0: 123, dwy0: 456}} = DWIDTH.parse("DWIDTH 123 456")
    end

    test "invalid parameters (less parameters)" do
      assert {:error, "invalid DWIDTH parameters: \"123\""} = DWIDTH.parse("DWIDTH 123")
    end

    test "invalid parameters (no parameters)" do
      assert {:error, "invalid DWIDTH parameters: \"\""} = DWIDTH.parse("DWIDTH ")
    end

    test "invalid parameters (too many parameters)" do
      assert {:error, "invalid DWIDTH parameters: \"12 34 56\""} = DWIDTH.parse("DWIDTH 12 34 56")
    end

    test "invalid parameters (not integer)" do
      assert {:error, "invalid DWIDTH parameters: \"one two\""} = DWIDTH.parse("DWIDTH one two")
    end

    test "invalid parameters (first parameter is a negative value)" do
      assert {:error, "invalid DWIDTH parameters: \"-12 34\""} = DWIDTH.parse("DWIDTH -12 34")
    end

    test "invalid parameters (second parameter is a negative value)" do
      assert {:error, "invalid DWIDTH parameters: \"12 -34\""} = DWIDTH.parse("DWIDTH 12 -34")
    end
  end
end
