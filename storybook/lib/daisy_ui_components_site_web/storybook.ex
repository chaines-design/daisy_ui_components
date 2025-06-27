defmodule DaisyUIComponentsSiteWeb.Storybook do
  use PhoenixStorybook,
    otp_app: :daisy_ui_components_site_web,
    content_path: Path.expand("../../storybook", __DIR__),
    # assets path are remote path, not local file-system paths
    css_path: "/assets/storybook.css",
    js_path: "/assets/storybook.js",
    title: "Phoenix + DaisyUI",
    sandbox_class: "daisy-ui-components-site-web",
    #
    # Show the color mode toggle in the top right corner of the storybook
    # https://hexdocs.pm/phoenix_storybook/color_modes.html#setup
    color_mode: true
end
