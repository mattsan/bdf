# Glyph Bitmap Distribution Format (BDF) Loader

Loads a BDF file or parses a BDF string.

## Installation

```elixir
def deps do
  [
    {:bdf, github: "mattsan/bdf"}
  ]
end
```

## Usage

### Loads from file

```elixir
{:ok, fonts} = BDF.load("path/to/font.bdf")
```

### Loads from io

```elixir
{:ok, fonts} =
  "paht/to/font.bdf"
  |> File.open!()
  |> BDF.load()
```

### Parses string

```elixir
{:ok, font_string} = File.read("path/to/font.bdf")
{:ok, fonts} = BDF.parse(font_string)
```
