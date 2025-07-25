defmodule Storybook.Components.Alert do
  use PhoenixStorybook.Story, :component
  alias DaisyUIComponents.Alert

  def function, do: &Alert.alert/1

  def imports,
    do: [
      {DaisyUIComponents.Button, [button: 1]},
      {DaisyUIComponents.Utils, [show: 1]},
      {DaisyUIComponents.Icon, [icon: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :info,
        slots: [
          """
          <.icon name="hero-information-circle" class="text-primary"/>
          """,
          "12 unread messages. Tap to see."
        ]
      },
      %Variation{
        id: :info_color,
        attributes: %{
          color: "info"
        },
        slots: [
          """
          <.icon name="hero-information-circle" />
          """,
          "12 unread messages. Tap to see."
        ]
      },
      %Variation{
        id: :success_color,
        attributes: %{
          color: "success"
        },
        slots: [
          """
          <.icon name="hero-check-circle" />
          """,
          "12 files uploaded successfully."
        ]
      },
      %Variation{
        id: :warning_color,
        attributes: %{
          color: "warning"
        },
        slots: [
          """
          <.icon name="hero-exclamation-triangle" />
          """,
          "You're now in the danger zone."
        ]
      },
      %Variation{
        id: :error_color,
        attributes: %{
          color: "error"
        },
        slots: [
          """
          <.icon name="hero-exclamation-circle" />
          """,
          "Upload failed.  Please try again."
        ]
      },
      %Variation{
        id: :alert_with_buttons,
        slots: [
          """
          <.icon name="hero-information-circle" class="text-primary" />
          <span>we use cookies for no reason.</span>
          <div>
            <.button size="sm">Deny</.button>
            <.button color="primary" size="sm">Accept</.button>
          </div>
          """
        ]
      },
      %Variation{
        id: :alert_with_title_and_description,
        slots: [
          """
          <.icon name="hero-information-circle" class="text-primary" />
          <div>
            <h3 class="font-bold">New message!</h3>
            <div class="text-xs">You have 1 unread message</div>
          </div>
          <.button size="sm">See</.button>
          """
        ]
      }
    ]
  end
end
