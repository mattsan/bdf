defmodule BDF.Font.BITMAPTest do
  use ExUnit.Case, async: true
  alias BDF.Font.BITMAP
  doctest BITMAP

  setup context do
    string = Map.get(context, :string, "")
    {:ok, io} = StringIO.open(string)

    [io: io]
  end

  describe "load/2" do
    @tag string: """
         11
         22
         33
         44
         ENDCHAR
         """
    test "valid termination", %{io: io} do
      assert {:ok, [0x11, 0x22, 0x33, 0x44]} = BITMAP.load(io, 8)
    end

    @tag string: """
         11
         END
         """
    test "invalid termination", %{io: io} do
      assert {:error, ~S'UNEXPECTED LINE: "END"'} = BITMAP.load(io, 8)
    end
  end
end
