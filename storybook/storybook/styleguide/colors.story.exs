defmodule Storybook.Components.Colors do
  @moduledoc false

  use PhoenixStorybook.Story, :example

  @colors [
    %{
      name: "primary",
      class: "bg-primary",
      css_var: "--color-primary",
      description: "Primary brand color, The main color of your brand"
    },
    %{
      name: "primary-content",
      class: "bg-primary-content",
      css_var: "--color-primary-content",
      description: "Foreground content color to use on primary color"
    },
    %{
      name: "secondary",
      class: "bg-secondary",
      css_var: "--color-secondary",
      description: "Secondary brand color, The optional, secondary color of your brand"
    },
    %{
      name: "secondary-content",
      class: "bg-secondary-content",
      css_var: "--color-secondary-content",
      description: "Foreground content color to use on secondary color"
    },
    %{
      name: "accent",
      class: "bg-accent",
      css_var: "--color-accent",
      description: "Accent brand color, The optional, accent color of your brand"
    },
    %{
      name: "accent-content",
      class: "bg-accent-content",
      css_var: "--color-accent-content",
      description: "Foreground content color to use on accent color"
    },
    %{
      name: "neutral",
      class: "bg-neutral",
      css_var: "--color-neutral",
      description: "Neutral dark color, For not-saturated parts of UI"
    },
    %{
      name: "neutral-content",
      class: "bg-neutral-content",
      css_var: "--color-neutral-content",
      description: "Foreground content color to use on neutral color"
    },
    %{
      name: "base-100",
      class: "bg-base-100",
      css_var: "--color-base-100",
      description: "Base surface color of page, used for blank backgrounds"
    },
    %{
      name: "base-200",
      class: "bg-base-200",
      css_var: "--color-base-200",
      description: "Base color, darker shade, to create elevations"
    },
    %{
      name: "base-300",
      class: "bg-base-300",
      css_var: "--color-base-300",
      description: "Base color, even more darker shade, to create elevations"
    },
    %{
      name: "base-content",
      class: "bg-base-content",
      css_var: "--color-base-content",
      description: "Foreground content color to use on base color"
    },
    %{
      name: "info",
      class: "bg-info",
      css_var: "--color-info",
      description: "Info color, For informative/helpful messages"
    },
    %{
      name: "info-content",
      class: "bg-info-content",
      css_var: "--color-info-content",
      description: "Foreground content color to use on info color"
    },
    %{
      name: "success",
      class: "bg-success",
      css_var: "--color-success",
      description: "Success color, For success/safe messages"
    },
    %{
      name: "success-content",
      class: "bg-success-content",
      css_var: "--color-success-content",
      description: "Foreground content color to use on success color"
    },
    %{
      name: "warning",
      class: "bg-warning",
      css_var: "--color-warning",
      description: "Warning color, For warning/caution messages"
    },
    %{
      name: "warning-content",
      class: "bg-warning-content",
      css_var: "--color-warning-content",
      description: "Foreground content color to use on warning color"
    },
    %{
      name: "error",
      class: "bg-error",
      css_var: "--color-error",
      description: "Error color, For error/danger/destructive messages"
    },
    %{
      name: "error-content",
      class: "bg-error-content",
      css_var: "--color-error-content",
      description: "Foreground content color to use on error color"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, colors: @colors)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-7xl mx-auto space-y-8">
      <div class="text-center">
        <h1 class="text-4xl font-bold mb-4">Mechanical Orchard Colors</h1>
        <p class="text-lg text-base-content/70">
          Mechanical Orchard color palette with light and dark mode variants<br />
          <a
            href="https://daisyui.com/docs/colors/#list-of-all-daisyui-color-names"
            class="link link-primary"
            target="_blank"
          >
            Reference: daisyUI color docs
          </a>
        </p>
      </div>

      <div class="overflow-x-auto">
        <table class="table w-full">
          <thead>
            <tr>
              <th class="text-center" data-theme="light">Light</th>
              <th class="text-center" data-theme="dark">Dark</th>
              <th class="text-left">Color name</th>
              <th class="text-left">CSS variable</th>
              <th class="text-left">Where to use</th>
            </tr>
          </thead>
          <tbody>
            <%= for color <- @colors do %>
              <tr>
                <td class="text-center" data-theme="light">
                  <.color_swatch color={color} theme="light" />
                </td>
                <td class="text-center" data-theme="dark">
                  <.color_swatch color={color} theme="dark" />
                </td>
                <td class="font-mono text-sm">{color.name}</td>
                <td class="font-mono text-xs">{color.class}</td>
                <td class="text-xs text-base-content/70">{color.description}</td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  attr :color, :map, required: true, doc: "Color map containing name, class, and css_var fields"
  attr :theme, :string, required: true, doc: "Theme context - either 'light' or 'dark'"

  defp color_swatch(assigns) do
    ~H"""
    <div class={"w-56 h-16 rounded-lg " <> @color.class <> " border border-base-300 mx-auto flex items-center justify-center"}>
      <a
        class={"text-xs font-mono " <> @color.class <> " px-1 rounded whitespace-nowrap no-underline hover:underline"}
        id={"oklch-" <> @theme <> "-" <> @color.name}
        phx-hook="OklchColorValue"
        data-theme={@theme}
        data-css-var={@color.css_var}
        href="#"
        rel="noopener noreferrer"
      >
        Loading...
      </a>
    </div>
    """
  end
end
