defmodule BDF.ParserTest do
  use ExUnit.Case, async: true
  alias BDF.{Font, Parser}
  alias BDF.Font.{BBX, DWIDTH}
  doctest Parser

  setup %{string: string} do
    {:ok, io} = StringIO.open(string)

    [io: io]
  end

  describe "parse/2" do
    @tag string: """
         STARTCHAR 1234
         ENCODING 1234
         DWIDTH 8 4
         BBX 12 34 56 78
         BITMAP
         11
         22
         33
         44
         ENDCHAR
         ENDFONT
         """
    test "valid data", %{io: io} do
      assert {
               :ok,
               [
                 %Font{
                   encoding: 1234,
                   dwidth: %DWIDTH{dwx0: 8, dwy0: 4},
                   bbx: %BBX{bbw: 12, bbh: 34, bbxoff0x: 56, bbyoff0y: 78},
                   bitmap: [0x11, 0x22, 0x33, 0x44]
                 }
               ]
             } = Parser.parse(io)
    end

    @tag string: """
         STARTCHAR 1234
         ENCODING one-two-three-four
         DWIDTH 8 4
         BBX 12 34 56 78
         BITMAP
         11
         22
         33
         44
         ENDCHAR
         ENDFONT
         """
    test "invalid ENCODING", %{io: io} do
      assert {:error, "invalid ENCODING parameter: \"one-two-three-four\""} = Parser.parse(io)
    end

    @tag string: """
         STARTCHAR 1234
         ENCODING 1234
         DWIDTH eight four
         BBX 12 34 56 78
         BITMAP
         11
         22
         33
         44
         ENDCHAR
         ENDFONT
         """
    test "invalid DWIDTH", %{io: io} do
      assert {:error, "invalid DWIDTH parameters: \"eight four\""} = Parser.parse(io)
    end

    @tag string: """
         STARTCHAR 1234
         ENCODING 1234
         DWIDTH 8 4
         BBX one two three four
         BITMAP
         11
         22
         33
         44
         ENDCHAR
         ENDFONT
         """
    test "invalid BBX", %{io: io} do
      assert {:error, "invalid BBX parameters: \"one two three four\""} = Parser.parse(io)
    end
  end
end
