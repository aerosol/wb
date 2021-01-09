defmodule WB.Resources.Document.Link do
  defstruct match: nil,
            target: nil,
            title: nil,
            type: nil,
            ref: nil

  def new(attrs) do
    struct(__MODULE__, attrs)
  end

  def set_ref(%__MODULE__{} = link, ref) do
    %{link | ref: ref}
  end
end
