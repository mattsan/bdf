defmodule BDF.FontTest do
  use ExUnit.Case, async: true
  alias BDF.Font
  alias BDF.Font.{BBX, DWIDTH}
  doctest Font

  setup do
    [font: Font.new()]
  end

  describe "new/0" do
    test "create a new Font data", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0},
               dwidth: %DWIDTH{dwx0: 0, dwy0: 0},
               bitmap: []
             } = font
    end
  end

  describe "put_bbx/2" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78},
               dwidth: %DWIDTH{dwx0: 0, dwy0: 0},
               bitmap: []
             } = Font.put_bbx(font, BBX.new(12, 34, 56, 78))
    end

    test "invalid arguments", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_bbx(font, %{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78})
      end
    end
  end

  describe "put_bbx/5" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78},
               dwidth: %DWIDTH{dwx0: 0, dwy0: 0},
               bitmap: []
             } = Font.put_bbx(font, 12, 34, 56, 78)
    end

    test "invalid arguments", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_bbx(font, "12", "34", "56", "78")
      end
    end
  end

  describe "put_bitmap/2" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0},
               dwidth: %DWIDTH{dwx0: 0, dwy0: 0},
               bitmap: [1, 2, 3, 4, 5, 6, 7, 8]
             } = Font.put_bitmap(font, [1, 2, 3, 4, 5, 6, 7, 8])
    end

    test "invalid type argument", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_bitmap(font, {1, 2, 3, 4, 5, 6, 7, 8})
      end
    end

    test "invalid type of list items", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_bitmap(font, ["1", "2"])
      end
    end
  end

  describe "put_dwidth/2" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0},
               dwidth: %DWIDTH{dwx0: 123, dwy0: 456},
               bitmap: []
             } = Font.put_dwidth(font, DWIDTH.new(123, 456))
    end

    test "invalid arguments", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_dwidth(font, %{dwx0: 123, dwy0: 456})
      end
    end
  end

  describe "put_dwidth/3" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 0,
               bbx: %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0},
               dwidth: %DWIDTH{dwx0: 123, dwy0: 456},
               bitmap: []
             } = Font.put_dwidth(font, 123, 456)
    end

    test "invalid arguments", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_dwidth(font, "123", "456")
      end
    end
  end

  describe "put_encoding/2" do
    test "valid arguments", %{font: font} do
      assert %Font{
               encoding: 1234,
               bbx: %BBX{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0},
               dwidth: %DWIDTH{dwx0: 0, dwy0: 0},
               bitmap: []
             } = Font.put_encoding(font, 1234)
    end

    test "invalid type arguments", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_encoding(font, "1234")
      end
    end

    test "invalid arguments value", %{font: font} do
      assert_raise FunctionClauseError, fn ->
        Font.put_encoding(font, -1234)
      end
    end
  end

  describe "inspection" do
    test "inspect a font", %{font: font} do
      assert font
             |> Font.put_bbx(12, 34, 56, 78)
             |> Font.put_dwidth(12, 34)
             |> Font.put_bitmap([1, 2, 3, 4, 5, 6, 7, 8])
             |> Font.put_encoding(1234)
             |> inspect() ==
               """
               %BDF.Font{
                 encoding: 0x4D2,
                 dwidth: %BDF.Font.DWIDTH{dwx0: 12, dwy0: 34},
                 bbx: %BDF.Font.BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78},
                 bitmap: [0x001, 0x002, 0x003, 0x004, 0x005, 0x006, 0x007, 0x008]
               }
               """
    end
  end
end
