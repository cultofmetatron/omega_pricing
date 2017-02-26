defmodule PriceTracker.Headers do


  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      
    end

  end

  def transactor do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  @doc """
  # borrowed from some phoenix code
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
