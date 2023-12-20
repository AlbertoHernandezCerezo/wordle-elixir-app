defmodule WordleElixirApp.GameEngine.GameLogic do
  alias WordleElixirApp.GameEngine.GameState

  @spec new(String.to()) :: %GameState{}
  def new(word_to_guess) do
    word_to_guess |> GameState.new()
  end

  # Transforms guess word in game word tiles
  @spec tilerize(GameState.t(), String.t()) :: GameState.guess_attempt()
  # If guess & game word match all tiles are correct
  def tilerize(%GameState{ word: word }, guess) when guess == word do
    _graphemes_with_index(word)
      |> Enum.map(fn { tile_char, _index } -> %{ char: tile_char, state: :correct } end)
  end

  # If guess & game word do not match, we need to compute each tile state
  def tilerize(game, guess) do
    correct_tiles = _graphemes_with_index(game.word)

    _graphemes_with_index(guess)
      |> Enum.map(fn {tile_char, index} ->
          case Enum.at(correct_tiles, index) do
            {correct_char, _} when correct_char == tile_char ->
              %{char: tile_char, state: :correct}
            _ ->
              %{char: tile_char, state: :incorrect}
          end
        end)
  end

  def winner?(guess_attempt) do
    guess_attempt |> Enum.map(fn %{ state: state } -> state == :correct end) |> Enum.all?()
  end

  @spec resolve(GameState.t(), String.t()) :: GameState.t()
  def resolve(game, guess) do
    guess_atempt = tilerize(game, guess)

    state = if winner?(guess_atempt) do
              :won
            else
              # If total attempts reach game limit game is over
              if length(game.guess_attempts) + 1 == game.allowed_guess_attempts do
                :lost
              else
                :playing
              end
            end

    %{ game | state: state, guess_attempts: game.guess_attempts ++ [guess_atempt], over?: state != :playing }
  end

  # "Word" -> [0: "W", 1: "O", 2: "R", 3: "D"]
  defp _graphemes_with_index(word) do
    word
      |> String.upcase()
      |> String.graphemes()
      |> Enum.with_index()
  end
end
