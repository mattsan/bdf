defmodule BDF.Font.ENCODING do
  @moduledoc """
  Functions for ENCODING of BDF.
  """

  @doc """
  Parses ENCODING string.

  ## Examples

  ```elixir
  iex> BDF.Font.ENCODING.parse("ENCODING 1234")
  {:ok, 1234}
  ```

  ```elixir
  iex> BDF.Font.ENCODING.parse("ENCODING UNKNOWN")
  {:error, "invalid ENCODING parameter: \\"UNKNOWN\\""}
  ```

  ```elixir
  iex> BDF.Font.ENCODING.parse("THIS IS NOT ENCODING")
  {:error, "invalid ENCODING parameter: \\"THIS IS NOT ENCODING\\""}
  ```
  """
  @spec parse(String.t()) :: {:ok, non_neg_integer()} | {:error, reason :: String.t()}
  def parse("ENCODING " <> param_str) do
    try do
      encoding =
        param_str
        |> String.trim()
        |> String.to_integer()

      if encoding >= 0 do
        {:ok, encoding}
      else
        {:error, error_message(param_str)}
      end
    rescue
      ArgumentError ->
        {:error, error_message(param_str)}
    end
  end

  def parse(term) do
    {:error, error_message(term)}
  end

  defp error_message(term) do
    str =
      if is_binary(term) do
        term
      else
        term
        |> inspect()
      end

    ~s'invalid ENCODING parameter: "#{String.trim(str)}"'
  end
end
