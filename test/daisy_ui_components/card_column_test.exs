defmodule DaisyUIComponents.CardColumnTest do
  use DaisyUIComponents.ComponentCase

  import Phoenix.Component
  import DaisyUIComponents.CardColumn

  alias Floki

  describe "card_column/1" do
    test "renders empty card column" do
      assigns = %{workloads: []}

      ~H"""
      <.card_column workloads={@workloads} />
      """
      |> parse_component()
      |> assert_component("div")
      |> assert_class(
        "bg-base-100 p-4 border border-base-300 rounded-lg flex flex-col gap-4 overflow-y-scroll [scrollbar-width:none] shadow-sm row-start-2 row-end-auto"
      )
    end

    test "renders card column with workloads" do
      workloads = [
        %{
          name: "Test Workload 1",
          packet_count: 100,
          status: "Active",
          team: "Engineering"
        },
        %{
          name: "Test Workload 2",
          packet_count: 50,
          status: "Inactive",
          team: "DevOps"
        }
      ]

      assigns = %{workloads: workloads}

      ~H"""
      <.card_column workloads={@workloads} />
      """
      |> parse_component()
      |> assert_component("div")
      |> assert_class(
        "bg-base-100 p-4 border border-base-300 rounded-lg flex flex-col gap-4 overflow-y-scroll [scrollbar-width:none] shadow-sm row-start-2 row-end-auto"
      )

      # Check that workload names appear in card titles
      workload_1_card =
        ~H"""
        <.card_column workloads={@workloads} />
        """
        |> parse_component()
        |> Floki.find(".card-title")
        |> Enum.find(fn element -> Floki.text(element) =~ "Test Workload 1" end)

      assert workload_1_card != nil

      workload_2_card =
        ~H"""
        <.card_column workloads={@workloads} />
        """
        |> parse_component()
        |> Floki.find(".card-title")
        |> Enum.find(fn element -> Floki.text(element) =~ "Test Workload 2" end)

      assert workload_2_card != nil
    end

    test "renders with custom class" do
      assigns = %{workloads: [], class: "custom-class"}

      ~H"""
      <.card_column workloads={@workloads} class={@class} />
      """
      |> parse_component()
      |> assert_component("div")
      |> assert_class(
        "bg-base-100 p-4 border border-base-300 rounded-lg flex flex-col gap-4 overflow-y-scroll [scrollbar-width:none] shadow-sm row-start-2 row-end-auto custom-class"
      )
    end

    test "handles workloads without status" do
      workloads = [
        %{
          name: "Test Workload",
          packet_count: 75,
          status: nil,
          team: "QA"
        }
      ]

      assigns = %{workloads: workloads}

      ~H"""
      <.card_column workloads={@workloads} />
      """
      |> parse_component()
      |> assert_component("div")

      # Verify the workload appears in the component
      component_text =
        ~H"""
        <.card_column workloads={@workloads} />
        """
        |> parse_component()
        |> text()

      assert component_text =~ "Test Workload"
      assert component_text =~ "75 Packets Collected"
      assert component_text =~ "QA"
    end
  end
end
