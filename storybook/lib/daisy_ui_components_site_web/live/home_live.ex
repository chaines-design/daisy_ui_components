defmodule DaisyUIComponentsSiteWeb.HomeLive do
  @moduledoc false
  use DaisyUIComponentsSiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Home</h1>
      <.button class="btn btn-primary">Click me</.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
