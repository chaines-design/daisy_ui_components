defmodule Storybook.Components.ApplicationLayout do
  use PhoenixStorybook.Story, :component
  alias DaisyUIComponents.ApplicationLayout
  alias DaisyUIComponents.Alert
  alias DaisyUIComponents.Icon
  alias DaisyUIComponents.Navbar
  alias DaisyUIComponents.NavPanel
  alias DaisyUIComponents.ThemeToggle

  def function, do: &ApplicationLayout.app/1

  def imports,
    do: [
      {Alert, flash_group: 1},
      {Icon, icon: 1},
      {Navbar, navbar: 1},
      {NavPanel, nav_panel: 1},
      {ThemeToggle, theme_toggle: 1}
    ]

  def variations do
    [
      %Variation{
        id: :simple_app,
        attributes: %{
          class: "bg-base-200 shadow-xl rounded-box",
          current_nav_name: "Navigation",
          current_url: "/some-url",
          current_user: %{name: "John Doe", email: "jdoe@email.edu"},
          flash: %{},
          nav_panel_id: "nav-panel",
          nav_items: [
            {"Navigation Item 1", "/some-url"},
            {"Navigation Item 2", "/another-url"}
          ]
        },
        slots: [
          """
            <h1>Content</h1>
          """
        ]
      },
      %Variation{
        id: :app_with_logo,
        attributes: %{
          class: "bg-base-200 shadow-xl rounded-box",
          current_nav_name: "Navigation",
          current_url: "/some-url",
          current_user: %{name: "John Doe", email: "jdoe@email.edu"},
          flash: %{},
          logo_image: "/images/logo.svg",
          nav_panel_id: "nav-panel-with-logo",
          nav_items: [
            {"Navigation Item 1", "/some-url"},
            {"Navigation Item 2", "/another-url"}
          ]
        },
        slots: [
          """
            <h1>Content</h1>
          """
        ]
      }
    ]
  end
end
