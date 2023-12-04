# Advent of Code 2023
My Elixir solutions for Advent of Code 2023

## Status
| Date    | Mon  | Tue  | Wed  | Thu  | Fri  | Sat  | Sun  |
|:-------:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
| `27.11` |      |      |      |      | ⭐️⭐️ | ⭐️⭐️ | ⭐️⭐️ |
| `04.12` | ⭐️⭐️ |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |
| `11.12` |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |
| `18.12` |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |
| `25.12` |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |  ⏳  |

## Running
Make sure to retrieve dependencies

```bash
$ mix deps.get
```

And then run the tests

```bash
$ mix test
```

You can also run a specific solution part and day by running the `day.run` mix task

```bash
# runs part 1 and 2 for the last implemented day
$ mix day.solve

# runs parts 1 and 2 for day 1
$ mix day.solve 1

# runs part 2 for day 3
$ mix day.solve 3 2
```

Note that solver task first looks for a file at `lib/day{padded_day}/input{part}.txt` for the problem input, and if it can't find it, it uses `lib/day{padded_day}/input.txt` instead.

## Development
You can generate a set of solution and test files for any given day by running the `day.new` task.

This creates a 1-part solution for the given day, so it's up to the developer to add more parts.

```bash
# creates files for the first unimplemented day
$ mix day.new

# creates files for day 42
$ mix day.new 42
```

## License
MIT
