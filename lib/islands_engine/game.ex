defmodule IslandsEngine.Game do
  use GenServer
  alias IslandsEngine.{Board, Guesses, Rules, Coordinate, Island}

  @players [:player1, :player2]

  def start_link(name) when is_binary(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def add_player2(game, name) when is_binary(name) do
    GenServer.call(game, {:add_player, name})
  end

  def position_island(game, player, key, row, col) when player in @players do
    GenServer.call(game, {:position_island, player,key, row, col })
  end

  def handle_call({:position_island, player,key, row, col }, _from, state) do
  with {:ok, rules} <- Rules.check(state.rules, :position_islands) do

  end

  end

  defp update_board(state, player, board) do
    put_in(state[player], board)
    """
    Map.update!(state, player, &(%{&1 | board: board}))
    """
  end

  defp player_board(state, player) do
    get_in(state, [player, :board])
    """
    Map.get(state_data, player).board
    """
  end

  def handle_call({:add_player, name}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player) do
      state
      |> update_player2(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state}
    end
  end

  def init(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    {:ok, %{player1: player1, player2: player2, rules: Rules.new()}}
  end

  defp reply_success(state, reply) do
    {:reply, reply, state}
  end

  defp update_rules(state, rules) do
    %{state | rules: rules}
  end

  defp update_player2(state, name) do
    put_in(state.player2.name, name)
  end


end
