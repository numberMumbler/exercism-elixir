defmodule RobotSimulator do
  defguardp is_valid_direction(direction) when direction in [:north, :east, :south, :west]

  defguardp is_valid_position(position)
            when is_tuple(position) and
                   tuple_size(position) == 2 and
                   is_integer(elem(position, 0)) and
                   is_integer(elem(position, 1))

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  def create(direction, _) when not is_valid_direction(direction) do
    {:error, "invalid direction"}
  end

  def create(_, position) when not is_valid_position(position) do
    {:error, "invalid position"}
  end

  @spec create(direction :: atom, position :: {integer, integer}) :: any
  def create(direction \\ :north, position \\ {0, 0}) do
    %{direction: direction, position: position}
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.upcase()
    |> String.graphemes()
    |> Enum.reduce(robot, &update/2)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot), do: robot.position

  # Update the robot with the result of the instruction
  defp update(_, {:error, message}), do: {:error, message}

  defp update("R", %{direction: direction, position: position}) do
    %{direction: turn_right(direction), position: position}
  end

  defp update("L", %{direction: direction, position: position}) do
    %{direction: turn_left(direction), position: position}
  end

  defp update("A", %{direction: direction, position: position}) do
    %{direction: direction, position: advance(direction, position)}
  end

  defp update(_, _), do: {:error, "invalid instruction"}

  # Get the result of the instructions
  defp turn_right(:north), do: :east
  defp turn_right(:east), do: :south
  defp turn_right(:south), do: :west
  defp turn_right(:west), do: :north

  defp turn_left(:north), do: :west
  defp turn_left(:east), do: :north
  defp turn_left(:south), do: :east
  defp turn_left(:west), do: :south

  defp advance(:north, {x, y}), do: {x, y + 1}
  defp advance(:east, {x, y}), do: {x + 1, y}
  defp advance(:south, {x, y}), do: {x, y - 1}
  defp advance(:west, {x, y}), do: {x - 1, y}
end
