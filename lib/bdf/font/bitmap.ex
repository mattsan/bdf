defmodule BDF.Font.BITMAP do
  @moduledoc """
  A structure of BITMAP of BDF.
  """

  @type t() :: [non_neg_integer()]

  @doc """
  Checks the argument is bitmap data (list of `non_neg_integer`).

  ## Examples

  ```elixir
  iex> BDF.Font.BITMAP.bitmap?([1])
  true
  ```
  """
  @spec bitmap?(term) :: boolean()
  def bitmap?(list) when is_list(list) do
    Enum.all?(list, fn item -> is_integer(item) && item >= 0 end)
  end

  def bitmap?(_) do
    false
  end

  @doc """
  Loads bitmap data form IO.
  """
  @spec load(File.io_device(), pos_integer()) :: {:ok, t()} | {:error, reason :: String.t()}
  def load(io, width) do
    io
    |> IO.stream(:line)
    |> Enum.reduce_while([], fn
      "ENDCHAR" <> _, acc ->
        {:halt, {:ok, Enum.reverse(acc)}}

      line, acc ->
        digits = String.trim(line)

        case Integer.parse(digits, 16) do
          {value, ""} ->
            length = String.length(digits)
            <<bits::size(width), _::bits>> = <<value::size(length)-unit(4)>>
            {:cont, [bits | acc]}

          _ ->
            {:halt, {:error, "UNEXPECTED LINE: #{inspect(digits)}"}}
        end
    end)
  end
end
