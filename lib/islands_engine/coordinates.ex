defmodule IslandsEngine.Coordinate do
  alias __MODULE__


  @enforce_keys [:row, :coll]
  defstruct [:row, :coll]

  @board_range 1..10
  def new(row, coll) when row in(@board_range) and coll in(@board_range) do
    {:ok, %Coordinate{row: row, coll: coll}}
  end


  def new(_row, _coll) do
    {:error, :invalid_coordinate}
  end

end



