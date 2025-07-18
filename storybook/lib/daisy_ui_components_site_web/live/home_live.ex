defmodule DaisyUIComponentsSiteWeb.HomeLive do
  @moduledoc false
  use DaisyUIComponentsSiteWeb, :live_view

      def render(assigns) do
      ~H"""
      <div class="flex flex-col justify-between h-screen w-56 bg-base-200">
        <div class="pt-6">
          <%!-- Added the Tailwind arbitrary selector [&_li>a]:w-full to force all anchor tags to be full width --%>
          <.menu class="bg-transparent w-full [&_li>a]:w-full">
            <:item class="menu-title text-base-content">Rose Johnson</:item>
            <:item><a><.icon name="hero-home" class="h-5 w-5" /> Home</a></:item>
            <:item><a><.icon name="hero-sun" class="h-5 w-5" /> Theme</a></:item>
            <:item class="menu-title text-base-content pt-8">Taxes</:item>
            <:item><a><.icon name="hero-building-storefront" class="h-5 w-5" /> Businesses</a></:item>
            <:item><a><.icon name="hero-currency-dollar" class="h-5 w-5" /> Payments</a></:item>
            <:item><a><.icon name="hero-folder-open" class="h-5 w-5" /> Records</a></:item>
            <:item><a><.icon name="hero-document-chart-bar" class="h-5 w-5" /> Reports</a></:item>
            <:item class="menu-title text-base-content pt-8">Configuration</:item>
            <:item><a><.icon name="hero-calendar" class="h-5 w-5" /> Calendars</a></:item>
            <:item><a><.icon name="hero-user-circle" class="h-5 w-5" /> Users</a></:item>
            <:item><a><.icon name="hero-cog-6-tooth" class="h-5 w-5" /> Configuration</a></:item>
          </.menu>
        </div>
        <div class="py-2">
          <%!-- Added the Tailwind arbitrary selector [&_li>a]:w-full to force all anchor tags to be full width --%>
          <.menu class="bg-transparent w-full [&_li>a]:w-full">
            <:item><a><.icon name="hero-arrow-right-on-rectangle" class="h-5 w-5" /> Log Out</a></:item>
          </.menu>
        </div>
      </div>
      """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
