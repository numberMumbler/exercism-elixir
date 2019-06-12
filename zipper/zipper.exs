defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """

  @type t :: %BinTree{value: any, left: t() | nil, right: t() | nil}

  defstruct [:value, :left, :right]
end

defimpl Inspect, for: BinTree do
  import Inspect.Algebra

  # A custom inspect instance purely for the tests, this makes error messages
  # much more readable.
  #
  # BinTree[value: 3, left: BinTree[value: 5, right: BinTree[value: 6]]] becomes (3:(5::(6::)):)
  def inspect(%BinTree{value: value, left: left, right: right}, opts) do
    concat([
      "(",
      to_doc(value, opts),
      ":",
      if(left, do: to_doc(left, opts), else: ""),
      ":",
      if(right, do: to_doc(right, opts), else: ""),
      ")"
    ])
  end
end

defmodule Zipper do
  @type t :: %Zipper{focus: BinTree.t(), path: Enum.t()}

  defstruct [:focus, :path]

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree) do
    %Zipper{focus: bin_tree, path: []}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%Zipper{focus: focus, path: []}) do
    focus
  end

  def to_tree(%Zipper{path: [{parent, _} | ancestors]}) do
    to_tree(%Zipper{focus: parent, path: ancestors})
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%Zipper{focus: focus}) do
    focus.value
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%Zipper{focus: %BinTree{left: nil}}) do
    nil
  end

  def left(%Zipper{focus: focus, path: path}) do
    %Zipper{focus: focus.left, path: [{focus, :left} | path]}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%Zipper{focus: %BinTree{right: nil}}) do
    nil
  end

  def right(%Zipper{focus: focus, path: path}) do
    %Zipper{focus: focus.right, path: [{focus, :right} | path]}
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%Zipper{path: []}) do
    nil
  end

  def up(%Zipper{path: [{parent, _} | ancestors]}) do
    %Zipper{focus: parent, path: ancestors}
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(zipper, value) do
    update_focus(zipper, :value, value)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(zipper, left) do
    update_focus(zipper, :left, left)
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(zipper, right) do
    update_focus(zipper, :right, right)
  end

  # common functions to propagate node changes
  defp update_focus(zipper, field, value) do
    updated_node = update_field(zipper.focus, field, value)
    updated_path = update_path(updated_node, zipper.path)

    %Zipper{focus: updated_node, path: updated_path}
  end

  defp update_field(node, :value, value), do: %{node | value: value}
  defp update_field(node, :left, value), do: %{node | left: value}
  defp update_field(node, :right, value), do: %{node | right: value}

  defp update_path(_, []) do
    []
  end

  defp update_path(updated_node, [{parent_node, parent_direction} | ancestors]) do
    parent_zipper = %Zipper{focus: parent_node, path: ancestors}
    updated_zipper = update_focus(parent_zipper, parent_direction, updated_node)

    [{updated_zipper.focus, parent_direction} | updated_zipper.path]
  end
end
