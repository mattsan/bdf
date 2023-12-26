defmodule BDF.Font do
  @moduledoc """
  A structure of font of BDF.
  """

  alias BDF.Font.{BBX, BITMAP, DWIDTH}

  defstruct bitmap: [], dwidth: DWIDTH.new(), bbx: BBX.new(), encoding: 0

  @type t() :: %__MODULE__{
          bitmap: BITMAP.t(),
          dwidth: DWIDTH.t(),
          bbx: BBX.t(),
          encoding: non_neg_integer()
        }

  @doc """
  Creates a new BDF.Font data.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{}
  end

  @doc """
  Puts a `BDF.Font.BBX` data into the `BDF.Font` data.

  ## Example

  ```elixir
  iex> BDF.Font.put_bbx(BDF.Font.new(), BDF.Font.BBX.new(1, 2, 3, 4))
  %BDF.Font{bbx: %BDF.Font.BBX{bbw: 1, bbh: 2, bbxoff0x: 3, bbyoff0y: 4}}
  ```
  """
  @spec put_bbx(t(), BBX.t()) :: t()
  def put_bbx(%__MODULE__{} = font, %BBX{} = bbx) do
    %{font | bbx: bbx}
  end

  @doc """
  Puts integers as a `BDF.Font.BBX` data into the `BDF.Font` data.

  ## Example

  ```elixir
  iex> BDF.Font.put_bbx(BDF.Font.new(), 1, 2, 3, 4)
  %BDF.Font{bbx: %BDF.Font.BBX{bbw: 1, bbh: 2, bbxoff0x: 3, bbyoff0y: 4}}
  ```
  """
  @spec put_bbx(t(), non_neg_integer(), non_neg_integer(), integer(), integer()) :: t()
  def put_bbx(%__MODULE__{} = font, bbw, bbh, bbxoff0x, bbyoff0y) do
    put_bbx(%__MODULE__{} = font, BBX.new(bbw, bbh, bbxoff0x, bbyoff0y))
  end

  @doc """
  Puts a `BDF.Font.BITMAP` data into the `BDF.Font` data.
  """
  @spec put_bitmap(t(), BITMAP.t()) :: t()
  def put_bitmap(%__MODULE__{} = font, bitmap) do
    unless BITMAP.bitmap?(bitmap),
      do: raise(FunctionClauseError, module: __MODULE__, function: :put_bitmap, arity: 2)

    %{font | bitmap: bitmap}
  end

  @doc """
  Puts a `BDF.Font.DWIDTH` data into the `BDF.Font` data.

  ```elixir
  iex> BDF.Font.put_dwidth(BDF.Font.new(), BDF.Font.DWIDTH.new(1, 2))
  %BDF.Font{dwidth: %BDF.Font.DWIDTH{dwx0: 1, dwy0: 2}}
  ```
  """
  @spec put_dwidth(t(), DWIDTH.t()) :: t()
  def put_dwidth(%__MODULE__{} = font, %DWIDTH{} = dwidth) do
    %{font | dwidth: dwidth}
  end

  @doc """
  Puts integers as a `BDF.Font.DWIDTH` data into the `BDF.Font` data.

  ## Example

  ```elixir
  iex> BDF.Font.put_dwidth(BDF.Font.new(), 1, 2)
  %BDF.Font{dwidth: %BDF.Font.DWIDTH{dwx0: 1, dwy0: 2}}
  ```
  """
  @spec put_dwidth(t(), integer(), integer()) :: t()
  def put_dwidth(%__MODULE__{} = font, dwx0, dwy0) when is_integer(dwx0) and is_integer(dwy0) do
    put_dwidth(%__MODULE__{} = font, DWIDTH.new(dwx0, dwy0))
  end

  @doc """
  Puts encoding data into the `BDF.Font` data.

  ## Example

  ```elixir
  iex> BDF.Font.put_encoding(BDF.Font.new(), 1234)
  %BDF.Font{encoding: 1234}
  ```
  """
  @spec put_encoding(t(), non_neg_integer()) :: t()
  def put_encoding(%__MODULE__{} = font, encoding) when is_integer(encoding) and encoding >= 0 do
    %{font | encoding: encoding}
  end

  defimpl Inspect do
    def inspect(font, _opts) do
      """
      %BDF.Font{
        encoding: 0x#{Integer.to_string(font.encoding, 16)},
        dwidth: #{inspect(font.dwidth)},
        bbx: #{inspect(font.bbx)},
        bitmap: [#{format(font)}]
      }
      """
    end

    defp format(format) do
      digits = div(format.dwidth.dwx0 + 3, 4)

      format.bitmap
      |> Enum.map_join(", ", fn n ->
        :io_lib.format("0x~*.16.0B", [digits, n])
      end)
    end
  end
end
