defmodule WordleElixirApp.GameEngine.GameState do
  @moduledoc """
    Tracks the progress of a game: complation, guess attempts, etc
  """

  @enforce_keys [:word]
  defstruct guess_attempts: [], state: :playing, allowed_guess_attempts: 5, word: nil, over?: false

  # Each game tile, representing a character, in a guess attempt
  @type tile() :: %{ char: String.t(), state: :correct | :incorrect | :invalid | :empty }

  # Word introduced by player to guess game word
  @type guess_attempt() :: list(tile())

  # Game progress: attemps information and current state based on that
  @type t() :: %__MODULE__{
    allowed_guess_attempts: Integer.t(),
    guess_attempts: list(guess_attempt()),
    over?: Boolean.t(),
    state: :playing | :lost | :won,
    word: String.t() | nil,
  }

  @spec new(String.t()) :: t()
  def new(word_to_guess) do
    %__MODULE__{word: word_to_guess}
  end
end
