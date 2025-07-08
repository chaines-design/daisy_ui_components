defmodule DaisyUIComponentsSiteWeb.HomeLive do
  @moduledoc false
  use DaisyUIComponentsSiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
    <.alert id="alert-single-info">
  <.icon name="hero-exclamation-circle" />
  12 unread messages. Tap to see.
</.alert>
<.card class="bg-base-200 w-96 shadow-xl">
  <figure>
    <img
      src="https://img.daisyui.com/images/stock/photo-1606107557195-0e29a4b5b4aa.webp"
      alt="Shoes" />
  </figure>
  <:card_title>Shoes!</:card_title>
  <:card_body>
    <p>If a dog chews shoes whose shoes does he choose?</p>
  </:card_body>
  <:card_actions class="justify-end">
    <button class="btn btn-primary">Buy Now</button>
  </:card_actions>
</.card>
<.hero class="bg-base-200">
  <:content class="text-center">
    <div class="max-w-md">
      <h1 class="text-5xl font-bold">Hello there</h1>
      <p class="py-6">
        Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda excepturi exercitationem
        quasi. In deleniti eaque aut repudiandae et a id nisi.
      </p>
      <.button color="primary">Get Started</.button>
    </div>
  </:content>
</.hero>

      <h1>Home</h1>
      <.button class="btn btn-primary">Click me</.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
