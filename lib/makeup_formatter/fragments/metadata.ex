defmodule MakeupFormatter.Fragments.Metadata do
  defstruct number: nil, visible?: true, html_attributes: %{}

  @type t :: %__MODULE__{
          number: non_neg_integer() | nil,
          visible?: boolean(),
          html_attributes: map()
        }
end
