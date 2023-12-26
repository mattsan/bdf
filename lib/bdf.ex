defmodule BDF do
  @moduledoc """
  A BDF library.

  see:
  - [Glyph Bitmap Distribution Format - Wikipedia](https://en.wikipedia.org/wiki/Glyph_Bitmap_Distribution_Format)
  - [Glyph Bitmap Distribution Format (BDF) Specification Adobe Version 2.2](https://adobe-type-tools.github.io/font-tech-notes/pdfs/5005.BDF_Spec.pdf) (PDF)
  """

  alias BDF.{Font, Parser}

  @doc """
  Loads BDF file.
  """
  @spec load(String.t() | File.io_device()) :: {:ok, [Font.t()]} | {:error, reason :: String.t()}
  def load(filename_or_io)

  def load(filename) when is_binary(filename) do
    case File.open(filename, &Parser.parse/1) do
      {:ok, {:ok, _} = result} -> result
      {:ok, error} -> error
      error -> error
    end
  end

  def load(io) do
    Parser.parse(io)
  end

  @doc """
  Parses BDF string.
  """
  @spec parse(String.t()) :: {:ok, [Font.t()]} | {:error, reason :: String.t()}
  def parse(string) when is_binary(string) do
    case StringIO.open(string, &Parser.parse/1) do
      {:ok, {:ok, _} = result} -> result
      {:ok, error} -> error
    end
  end
end
