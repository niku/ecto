defmodule Ecto.Query.BuilderUtil do
  @moduledoc false

  def find_vars({ var, _, context }, vars) when is_atom(var) and is_atom(context) do
    if var in vars, do: var
  end

  def find_vars({ left, _, right }, vars) do
    find_vars(left, vars) || find_vars(right, vars)
  end

  def find_vars({ left, right }, vars) do
    find_vars(left, vars) || find_vars(right, vars)
  end

  def find_vars(list, vars) when is_list(list) do
    Enum.find_value(list, find_vars(&1, vars))
  end

  def find_vars(_, _vars) do
    nil
  end
end