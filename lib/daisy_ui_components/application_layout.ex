defmodule DaisyUIComponents.ApplicationLayout do
  @moduledoc """
  Application layout component

  """

  use DaisyUIComponents, :component
  import DaisyUIComponents.Alert
  import DaisyUIComponents.Icon
  import DaisyUIComponents.Navbar
  import DaisyUIComponents.NavPanel
  import DaisyUIComponents.ThemeToggle

  @doc """
  Renders the app layout

  ## Examples

      <.app flash={@flash}>
        <h1>Content</h1>
      </.app>

  """
  attr :class, :any, default: nil

  attr :current_nav_name, :string,
    default: "Navigation",
    doc: "the name of the current navigation panel, used for accessibility"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :current_url, :string,
    default: nil,
    doc: "the current URL, used to highlight the active navigation item"

  attr :current_user, :map,
    default: nil,
    doc: "the current user, if logged in, used to display user-specific information"

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :logo_image, :string, default: nil, doc: "The logo image to display in the navigation panel"
  attr :nav_items, :list, required: true, doc: "A list of navigation items in the format `{name, url}`"
  attr :nav_panel_id, :string, default: nil, doc: "The ID of the navigation panel"
  attr :show_theme_toggle, :boolean, default: false, doc: "Whether to show the theme toggle button"

  slot :inner_block, required: true

  def app(assigns) do
    assigns =
      assigns
      |> assign_new(:nav_panel_id, fn -> "nav-panel" end)
      |> assign(
        :class,
        classes([
          "flex relative overflow-hidden",
          assigns.class
        ])
      )

    ~H"""
    <div class={@class}>
      <.flash_group flash={@flash} />

      <.nav_panel id={@nav_panel_id} current_url={@current_url} nav_items={@nav_items} logo_image={@logo_image} />
      <div class="flex flex-col grow relative overflow-hidden">
        <header class="px-4 border-b border-base-300 shadow-sm z-10">
          <div :if={@show_theme_toggle} class="flex items-center justify-end pt-6 text-sm">
            <.theme_toggle />
          </div>
          <.navbar class="min-h-20 flex items-center justify-between py-3 text-sm">
            <:navbar_start>
              <div class="flex items-center">
                <.nav_trigger
                  aria-label="Toggle navigation menu"
                  target={@nav_panel_id}
                  class="bg-base-200 text-base-content cursor-pointer"
                >
                  <.icon name="hero-bars-2" />
                </.nav_trigger>

                <span class="ml-3 text-lg">
                  {@current_nav_name}
                </span>
              </div>
            </:navbar_start>
            <:navbar_end>
              <%= if @current_user do %>
                <div class="min-h-20 flex items-center justify-between py-3 text-sm">
                  <span class="mr-4 text-base">Hello, {@current_user.name}</span>
                  <.link
                    role="button"
                    class="py-2.5 px-5 mb-2 text-sm text-base focus:outline-hidden rounded-lg border border-base-300 hover:bg-background-inverse-primary hover:text-content-inverse-primary focus:z-10 focus:ring-4 focus:ring-base-200"
                    href="/logout"
                  >
                    Logout
                  </.link>
                </div>
              <% end %>
            </:navbar_end>
          </.navbar>
        </header>
        <main class="bg-background-secondary h-[calc(100vh-64px)] w-full overflow-hidden">
          <div class="h-full w-full flex flex-col">
            <div class="flex flex-col px-4 py-4 h-full">
              {render_slot(@inner_block)}
            </div>
          </div>
        </main>
      </div>
    </div>
    """
  end
end
