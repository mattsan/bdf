defmodule BDF.Parser do
  @moduledoc """
  A BDF parser.
  """

  alias BDF.Font
  alias BDF.Font.{BBX, BITMAP, DWIDTH, ENCODING}

  @spec parse(File.io_device()) :: {:ok, [Font.t()]} | {:error, reason :: String.t()}
  def parse(io) do
    case search_startchar(io, []) do
      {:ok, _} = result -> result
      error -> error
    end
  end

  @doc false
  @spec search_startchar(File.io_device(), [Font.t()]) ::
          {:ok, [Font.t()]} | {:error, reason :: String.t()}
  def search_startchar(io, fonts) do
    io
    |> IO.stream(:line)
    |> Enum.reduce_while(fonts, fn
      "ENDFONT" <> _, acc ->
        {:halt, {:ok, Enum.reverse(acc)}}

      "STARTCHAR " <> _, acc ->
        case parse_char(io, Font.new()) do
          {:ok, font} ->
            {:cont, [font | acc]}

          error ->
            {:halt, error}
        end

      _, acc ->
        {:cont, acc}
    end)
  end

  @doc false
  @spec parse_char(File.io_device(), Font.t()) :: {:ok, Font.t()} | {:error, reason :: String.t()}
  def parse_char(io, font) do
    io
    |> IO.stream(:line)
    |> Enum.reduce_while(font, fn
      "BITMAP" <> _, acc ->
        case BITMAP.load(io, acc.dwidth.dwx0) do
          {:ok, bitmap} -> {:halt, {:ok, Font.put_bitmap(acc, bitmap)}}
          error -> {:halt, error}
        end

      "DWIDTH " <> _ = params, acc ->
        case DWIDTH.parse(params) do
          {:ok, dwidth} -> {:cont, Font.put_dwidth(acc, dwidth)}
          error -> {:halt, error}
        end

      "BBX " <> _ = params, acc ->
        case BBX.parse(params) do
          {:ok, bbx} -> {:cont, Font.put_bbx(acc, bbx)}
          error -> {:halt, error}
        end

      "ENCODING " <> _ = params, acc ->
        case ENCODING.parse(params) do
          {:ok, encoding} -> {:cont, Font.put_encoding(acc, encoding)}
          error -> {:halt, error}
        end

      _, acc ->
        {:cont, acc}
    end)
  end
end
