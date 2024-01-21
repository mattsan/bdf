defmodule BDF.Font.BBX do
  @moduledoc """
  A structure of BBX of BDF.
  """

  defstruct [:bbw, :bbh, :bbxoff0x, :bbyoff0y]

  @type t() :: %__MODULE__{
          bbw: non_neg_integer(),
          bbh: non_neg_integer(),
          bbxoff0x: integer(),
          bbyoff0y: integer()
        }

  defguardp is_bbx(bbw, bbh, bbxoff0x, bbyoff0y)
            when is_integer(bbw) and bbw > 0 and is_integer(bbh) and bbh > 0 and
                   is_integer(bbxoff0x) and is_integer(bbyoff0y)

  @doc """
  Creates a new `BDF.Font.BBX` data.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{bbw: 0, bbh: 0, bbxoff0x: 0, bbyoff0y: 0}
  end

  @doc """
  Creates a new `BDF.Font.BBX` data.
  """
  @spec new(non_neg_integer(), non_neg_integer(), integer(), integer()) :: t()
  def new(bbw, bbh, bbxoff0x, bbyoff0y) when is_bbx(bbw, bbh, bbxoff0x, bbyoff0y) do
    %__MODULE__{bbw: bbw, bbh: bbh, bbxoff0x: bbxoff0x, bbyoff0y: bbyoff0y}
  end

  @doc """
  Parses BBX string.

  ## Example

  ```elixir
  iex> BDF.Font.BBX.parse("BBX 1 2 3 4")
  {:ok, %BDF.Font.BBX{bbw: 1, bbh: 2, bbxoff0x: 3, bbyoff0y: 4}}
  ```
  """
  @spec parse(String.t()) :: {:ok, t()} | {:error, reason :: String.t()}
  def parse("BBX " <> param_str) do
    try do
      with items <- String.split(param_str, ~r/\s/, trim: true),
           [bbw, bbh, bbxoff0x, bbyoff0y] <- Enum.map(items, &String.to_integer/1) do
        if bbw > 0 && bbh > 0 do
          {:ok, %__MODULE__{bbw: bbw, bbh: bbh, bbxoff0x: bbxoff0x, bbyoff0y: bbyoff0y}}
        else
          {:error, error_message(param_str)}
        end
      else
        items when is_list(items) ->
          if length(items) < 4 do
            {:error, error_message(param_str)}
          else
            {:error, error_message(param_str)}
          end
      end
    rescue
      ArgumentError ->
        {:error, error_message(param_str)}
    end
  end

  defp error_message(str) do
    ~s'invalid BBX parameters: "#{String.trim(str)}"'
  end
end
