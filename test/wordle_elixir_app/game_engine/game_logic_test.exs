defmodule WordleElixirApp.GameEngine.GameLogicTest do
  use ExUnit.Case
  alias WordleElixirApp.GameEngine.GameLogic

  describe "tilerize" do
    test "if guess word is the same as the game word,
          return guess word tiles with correct state" do
      tiles = "sugar"
            |> GameLogic.new()
            |> GameLogic.tilerize("sugar")

      assert tiles == [
        %{ char: "S", state: :correct },
        %{ char: "U", state: :correct },
        %{ char: "G", state: :correct },
        %{ char: "A", state: :correct },
        %{ char: "R", state: :correct },
      ]
    end

    test "if guess word is different the game word,
          return guess word tiles with the corresponding correct/incorrect state" do
      tiles = "sugar"
        |> GameLogic.new()
        |> GameLogic.tilerize("zugar")

      assert tiles == [
        %{ char: "Z", state: :incorrect },
        %{ char: "U", state: :correct },
        %{ char: "G", state: :correct },
        %{ char: "A", state: :correct },
        %{ char: "R", state: :correct },
      ]
    end
  end

  describe "winner?" do
    test "if guess attempt contains no incorrect tiles, returns true" do
      guess_attempt = [
        %{ char: "S", state: :correct },
        %{ char: "U", state: :correct },
        %{ char: "G", state: :correct },
        %{ char: "A", state: :correct },
        %{ char: "R", state: :correct },
      ]

      assert GameLogic.winner?(guess_attempt)
    end

    test "if guess attempt contains incorrect tiles, returns false" do
      guess_attempt = [
        %{ char: "Z", state: :incorrect },
        %{ char: "U", state: :correct },
        %{ char: "G", state: :correct },
        %{ char: "A", state: :correct },
        %{ char: "R", state: :correct },
      ]

      refute GameLogic.winner?(guess_attempt)
    end
  end

  describe "resolve" do
    test "if game is not completed, tracks guess attempt" do
      game_word = "sugar"
      game = game_word |> GameLogic.new()

      game = GameLogic.resolve(game, "zugar")
      assert length(game.guess_attempts) == 1

      game = GameLogic.resolve(game, "zugar")
      assert length(game.guess_attempts) == 2
    end

    test "if guess does not match game word, and there are guess attempts left,
          set game as playing" do
      game_word = "sugar"
      game = game_word |> GameLogic.new()

      game = GameLogic.resolve(game, "zugar")
      assert game.state == :playing
    end

    test "if guess does not match game word, and there are no guess attempts left,
          set game as lost" do
      game_word = "sugar"
      game = game_word |> GameLogic.new()

      game = GameLogic.resolve(game, "zugar")
      game = GameLogic.resolve(game, "zugar")
      game = GameLogic.resolve(game, "zugar")
      game = GameLogic.resolve(game, "zugar")
      game = GameLogic.resolve(game, "zugar")
      assert game.state == :lost
    end

    test "if guess matches game word, set game as won" do
      game_word = "sugar"
      game = game_word |> GameLogic.new()

      game = GameLogic.resolve(game, "sugar")
      assert game.state == :won
    end
  end
end
