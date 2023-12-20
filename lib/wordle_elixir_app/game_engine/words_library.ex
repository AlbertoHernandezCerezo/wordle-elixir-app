defmodule WordleElixirApp.GameEngine.WordsLibrary do
  @moduledoc """
    Collection of words to guess

    from https://github.com/cwackerfuss/react-wordle/blob/main/src/constants
  """

  def words() do
    ~w(
      which
      there
      their
      about
      would
      these
      other
      words
      could
      write
    )
  end
end
