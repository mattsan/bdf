defmodule BDF.Font.BBXTest do
  use ExUnit.Case, async: true
  alias BDF.Font.BBX
  doctest BBX

  test "new/0" do
    assert %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0} = BBX.new()
  end

  test "new/4" do
    assert %BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78} = BBX.new(12, 34, 56, 78)
  end

  describe "parse/1" do
    test "valid parameters" do
      assert {:ok, %BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78}} =
               BBX.parse("BBX 12 34 56 78")
    end

    test "invalid parameters (three parameters)" do
      assert {:error, "invalid BBX parameters: \"12 34 56\""} = BBX.parse("BBX 12 34 56")
    end

    test "invalid parameters (two parameters)" do
      assert {:error, "invalid BBX parameters: \"12 34\""} = BBX.parse("BBX 12 34")
    end

    test "invalid parameters (one parameter)" do
      assert {:error, "invalid BBX parameters: \"12\""} = BBX.parse("BBX 12")
    end

    test "invalid parameters (no parameters)" do
      assert {:error, "invalid BBX parameters: \"\""} = BBX.parse("BBX ")
    end

    test "invalid parameters (five parameters)" do
      assert {:error, "invalid BBX parameters: \"12 34 56 78 90\""} =
               BBX.parse("BBX 12 34 56 78 90")
    end

    test "invalid parameters (not integers)" do
      assert {:error, "invalid BBX parameters: \"one two three four\""} =
               BBX.parse("BBX one two three four")
    end
  end
end
