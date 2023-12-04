defmodule Aoc2023.Day03 do
  defmodule Vector2 do
    defstruct [:x, :y]

    @type t() :: %__MODULE__{x: integer(), y: integer()}

    def new(), do: %__MODULE__{x: 0, y: 0}

    def translate_x(%__MODULE__{x: x, y: y}, dx), do: %__MODULE__{x: x + dx, y: y}
    def translate_y(%__MODULE__{x: x, y: y}, dy), do: %__MODULE__{x: x, y: y + dy}
  end

  defmodule Span do
    defstruct [:begin, :end]

    @type t :: %__MODULE__{begin: Vector2.t(), end: Vector2.t()}

    def new(), do: %__MODULE__{begin: Vector2.new(), end: Vector2.new()}

    def contains?(
          %__MODULE__{begin: %Vector2{x: x0, y: y0}, end: %Vector2{x: x1, y: y1}},
          %Vector2{x: vx, y: vy}
        ),
        do: x0 <= vx && vx <= x1 && y0 <= vy && vy <= y1

    def intersects?(%__MODULE__{} = self, %__MODULE__{} = other) do
      contains?(self, other.begin) || contains?(self, other.end) ||
        contains?(other, self.begin) || contains?(other, self.end)
    end

    def disjoint?(%__MODULE__{} = self, %__MODULE__{} = other), do: !intersects?(self, other)

    def around_vector(%Vector2{x: x, y: y}, grow_x, grow_y) do
      %__MODULE__{
        begin: %Vector2{x: x - grow_x, y: y - grow_y},
        end: %Vector2{x: x + grow_x, y: y + grow_y}
      }
    end
  end

  defmodule State do
    defstruct [
      :curr_number,
      :position,
      :numbers,
      :symbols
    ]

    @digits ~w(0 1 2 3 4 5 6 7 8 9)
    @symbols ~w(# $ % & * + - / = @)

    alias Aoc2023.Day03.Span
    alias Aoc2023.Day03.Vector2

    @type num() :: {String.t(), Span.t()}
    @type symbol() :: {String.t(), Vector2.t(), Span.t()}

    @type t() :: %__MODULE__{
            curr_number: nil | num(),
            numbers: [num()],
            symbols: [symbol()]
          }

    def new(),
      do: %__MODULE__{curr_number: nil, position: Vector2.new(), numbers: [], symbols: []}

    def accept_token(%__MODULE__{} = self, token)
        when token in @digits do
      new_num =
        case self.curr_number do
          nil -> {token, %Span{begin: self.position, end: self.position}}
          {num, %Span{begin: begin}} -> {num <> token, %Span{begin: begin, end: self.position}}
        end

      %__MODULE__{self | curr_number: new_num, position: Vector2.translate_x(self.position, 1)}
    end

    def accept_token(%__MODULE__{} = self, token) do
      new_numbers =
        case self.curr_number do
          nil -> self.numbers
          num -> self.numbers ++ [num]
        end

      new_symbols =
        if token in @symbols,
          do: self.symbols ++ [{token, self.position, Span.around_vector(self.position, 1, 1)}],
          else: self.symbols

      new_pos =
        if token == "\n",
          do: %Vector2{x: 0, y: self.position.y + 1},
          else: Vector2.translate_x(self.position, 1)

      %__MODULE__{
        position: new_pos,
        numbers: new_numbers,
        symbols: new_symbols,
        curr_number: nil
      }
    end
  end

  defmodule Part1 do
    alias Aoc2023.Day03.State
    alias Aoc2023.Day03.Span

    def solve(input) do
      %State{numbers: numbers, symbols: symbols} =
        input
        |> String.graphemes()
        |> Enum.reduce(State.new(), fn token, acc -> State.accept_token(acc, token) end)

      numbers
      |> Enum.filter(fn {_num, number_span} ->
        Enum.any?(symbols, fn {_symbol, _pos, symbol_area} ->
          Span.intersects?(number_span, symbol_area)
        end)
      end)
      |> Enum.map(fn {num, _span} -> String.to_integer(num) end)
      |> Enum.reduce(0, &(&1 + &2))
    end
  end

  defmodule Part2 do
    def solve(input) do
      %State{numbers: numbers, symbols: symbols} =
        input
        |> String.graphemes()
        |> Enum.reduce(State.new(), fn token, acc -> State.accept_token(acc, token) end)

      gears =
        Enum.filter(symbols, fn
          {"*", _pos, _span} -> true
          _ -> false
        end)

      gears
      |> Enum.map(fn {_, _pos, symbol_area} ->
        adjacent_numbers =
          numbers
          |> Enum.filter(fn {_, number_span} ->
            Span.intersects?(number_span, symbol_area)
          end)

        case adjacent_numbers do
          [] ->
            nil

          [_] ->
            nil

          _ ->
            Enum.reduce(adjacent_numbers, 1, fn {num, _pos}, acc ->
              acc * String.to_integer(num)
            end)
        end
      end)
      |> Enum.filter(fn
        nil -> false
        _ -> true
      end)
      |> Enum.reduce(0, &(&1 + &2))
    end
  end
end
