defmodule DaisyUIComponentsSiteWeb.Router do
  use DaisyUIComponentsSiteWeb, :router
  import PhoenixStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DaisyUIComponentsSiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", DaisyUIComponentsSiteWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/home", HomeLive, :home
    live "/colors", ColorThemeLive, :colors
    live "/accessibility", AccessibilityLive, :accessibility
    live_storybook("/storybook", backend_module: DaisyUIComponentsSiteWeb.Storybook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", DaisyUIComponentsSiteWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:daisy_ui_components_site, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DaisyUIComponentsSiteWeb.Telemetry
    end
  end
end
