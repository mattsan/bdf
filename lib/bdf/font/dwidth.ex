defmodule BDF.Font.DWIDTH do
  @moduledoc """
  A structure of DWIDTH of BDF.
  """

  defstruct [:dwx0, :dwy0]

  @type t() :: %__MODULE__{
          dwx0: integer(),
          dwy0: integer()
        }

  defguardp is_dwidth(dwx0, dwy0) when is_integer(dwx0) and is_integer(dwy0)

  @doc """
  Creates a new `BDF.Font.DWIDTH` data.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{dwx0: 0, dwy0: 0}
  end

  @doc """
  Creates a new `BDF.Font.DWIDTH` data.
  """
  @spec new(integer(), integer()) :: t()
  def new(dwx0, dwy0) when is_dwidth(dwx0, dwy0) do
    %__MODULE__{dwx0: dwx0, dwy0: dwy0}
  end

  @doc """
  Parses DWIDTH string.

  ## Example

  ```elixir
  iex> BDF.Font.DWIDTH.parse("DWIDTH 1 2")
  {:ok, %BDF.Font.DWIDTH{dwx0: 1, dwy0: 2}}
  ```
  """
  @spec parse(String.t()) :: {:ok, t()} | {:error, reason :: String.t()}
  def parse("DWIDTH " <> param_str) do
    try do
      with param_items <- String.split(param_str, ~r/\s/, trim: true),
           [dwx0, dwy0] <- Enum.map(param_items, &String.to_integer/1) do
        if dwx0 >= 0 && dwy0 >= 0 do
          {:ok, %__MODULE__{dwx0: dwx0, dwy0: dwy0}}
        else
          {:error, error_message(param_str)}
        end
      else
        _ ->
          {:error, error_message(param_str)}
      end
    rescue
      ArgumentError ->
        {:error, error_message(param_str)}
    end
  end

  defp error_message(str) do
    ~s'invalid DWIDTH parameters: "#{String.trim(str)}"'
  end
end
