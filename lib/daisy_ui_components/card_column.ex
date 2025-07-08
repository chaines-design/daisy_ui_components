defmodule DaisyUIComponents.CardColumn do
  @moduledoc """
  Card column component for displaying a list of workloads in a scrollable column layout.

  ## Examples

      <.card_column workloads={@workloads} />
  """

  use DaisyUIComponents, :component
  import DaisyUIComponents.Card
  import DaisyUIComponents.Badge

  attr :workloads, :list, default: []
  attr :class, :string, default: nil
  attr :rest, :global

  def card_column(assigns) do
    ~H"""
    <div
      class={
        classes([
          "bg-base-100 p-4 border border-base-300 rounded-lg flex flex-col gap-4 overflow-y-scroll [scrollbar-width:none] shadow-sm row-start-2 row-end-auto",
          @class
        ])
      }
      {@rest}
    >
      <%= for workload <- @workloads do %>
        <.card class="bg-base-100 border border-base-300">
          <.card_body>
            <.card_title label={workload.name} data-testid="workload-name" />
            <div class="flex flex-col gap-1">
              <div class="flex flex-row text-xs text-base-content/70 text-pretty">
                <div data-testid="workload-packet-count">
                  {workload.packet_count} Packets Collected
                </div>
              </div>
              <div class="flex flex-row justify-between items-center">
                <div class="text-xs text-base-content/60 text-pretty" data-testid="workload-status">
                  <%= if workload.status do %>
                    {workload.status}
                  <% end %>
                </div>
                <span class="flex justify-start items-end items-baseline justify-end grow" data-testid="workload-team">
                  <.badge color="primary">{workload.team}</.badge>
                </span>
              </div>
            </div>
          </.card_body>
        </.card>
      <% end %>
    </div>
    """
  end
end
