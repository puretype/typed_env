defmodule TypedEnv do
  @moduledoc """
  Typed environment variables for Config

  To use these functions, call `parse`. Typically you would have a list of environment variables and types, like:
    ```
    [
      {"TEST_VAR", :integer}
    ]
  |> Enum.map(fn {env, type} -> parse(:application, env, type) end)
  ```
  """

  import Config

  @spec parse(atom(), String.t(), :integer) :: :ok
  def parse(application, env_var, type) do
    var_name = env_var |> String.downcase() |> String.to_atom()

    case System.fetch_env(env_var) do
      :error ->
        :ok

      {:ok, value} ->
        case type do
          :integer -> parse_integer(application, var_name, value)
        end
    end
  end

  def parse_integer(application, var_name, value) do
    {integer, ""} = Integer.parse(value)
    config application, var_name, integer

    :ok
  end
end
