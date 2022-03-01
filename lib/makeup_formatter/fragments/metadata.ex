defmodule MakeupFormatter.Fragments.Metadata do
  defstruct line_number: nil, visible?: true, html_attributes: %{}

  @type t :: %__MODULE__{
          line_number: non_neg_integer() | nil,
          visible?: boolean(),
          html_attributes: map()
        }
end
