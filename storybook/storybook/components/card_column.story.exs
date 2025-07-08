defmodule Storybook.Components.CardColumn do
  use PhoenixStorybook.Story, :component

  alias DaisyUIComponents.Badge
  alias DaisyUIComponents.Card
  alias DaisyUIComponents.CardColumn

  def function, do: &CardColumn.card_column/1

  def imports,
    do: [
      {Badge, [badge: 1]},
      {Card, [card: 1, card_body: 1, card_title: 1]},
      {CardColumn, [card_column: 1]}
    ]

  def variations do
    [
      %Variation{
        id: :empty_column,
        attributes: %{
          workloads: []
        }
      },
      %Variation{
        id: :single_workload,
        attributes: %{
          workloads: [
            %{
              name: "Web Frontend",
              packet_count: 1250,
              status: "Active",
              team: "Frontend"
            }
          ]
        }
      },
      %Variation{
        id: :multiple_workloads,
        attributes: %{
          workloads: [
            %{
              name: "API Gateway",
              packet_count: 3847,
              status: "Active",
              team: "Backend"
            },
            %{
              name: "User Authentication",
              packet_count: 892,
              status: "Monitoring",
              team: "Security"
            },
            %{
              name: "Payment Processing",
              packet_count: 2156,
              status: "Active",
              team: "FinTech"
            },
            %{
              name: "Data Analytics",
              packet_count: 5643,
              status: "Processing",
              team: "Data"
            },
            %{
              name: "Mobile App Backend",
              packet_count: 1789,
              status: "Inactive",
              team: "Mobile"
            }
          ]
        }
      },
      %Variation{
        id: :workloads_without_status,
        attributes: %{
          workloads: [
            %{
              name: "Legacy System",
              packet_count: 445,
              status: nil,
              team: "Legacy"
            },
            %{
              name: "Microservice Alpha",
              packet_count: 0,
              status: nil,
              team: "Experimental"
            }
          ]
        }
      },
      %Variation{
        id: :high_packet_counts,
        attributes: %{
          workloads: [
            %{
              name: "High Traffic API",
              packet_count: 250_000,
              status: "Active",
              team: "Infrastructure"
            },
            %{
              name: "CDN Edge Node",
              packet_count: 1_750_000,
              status: "Active",
              team: "CDN"
            },
            %{
              name: "Database Cluster",
              packet_count: 95_000,
              status: "Monitoring",
              team: "Database"
            }
          ]
        }
      },
      %Variation{
        id: :custom_styling,
        attributes: %{
          class: "h-96 w-80 border-2 border-primary",
          workloads: [
            %{
              name: "Styled Component Demo",
              packet_count: 1000,
              status: "Demo",
              team: "Design"
            },
            %{
              name: "Theme Showcase",
              packet_count: 500,
              status: "Active",
              team: "UX"
            }
          ]
        }
      }
    ]
  end
end
