defmodule DaisyUIComponentsSiteWeb.AccessibilityLive do
  @moduledoc """
  Accessibility testing page for high-risk DaisyUI components.
  Tests contrast ratios against WCAG AA standards (4.5:1 normal, 3:1 large text).
  """
  use DaisyUIComponentsSiteWeb, :live_view

  import DaisyUIComponents.ThemeToggle
  import DaisyUIComponents.Alert
  import DaisyUIComponents.Badge
  import DaisyUIComponents.Button
  import DaisyUIComponents.Icon

    # Helper to generate unique test indices across all variants
  defp get_test_index(component_name, style, variant_index) do
    base_indices = %{
      {"Alert", "Standard"} => 0,
      {"Alert", "Soft"} => 10,
      {"Alert", "Outline"} => 20,
      {"Badge", "Standard"} => 30,
      {"Button", "High-Risk States"} => 40
    }

    base_index = Map.get(base_indices, {component_name, style}, 0)
    base_index + variant_index
  end

  # Simplified high-risk components for controlled testing
  @high_risk_components [
    %{
      component: "Alert",
      style: "Standard",
      variants: [
        %{
          name: "Default",
          class: "alert",
          test_element: "alert text content"
        },
        %{
          name: "Info",
          class: "alert alert-info",
          test_element: "alert text content"
        },
        %{
          name: "Success",
          class: "alert alert-success",
          test_element: "alert text content"
        },
        %{
          name: "Warning",
          class: "alert alert-warning",
          test_element: "alert text content"
        },
        %{
          name: "Error",
          class: "alert alert-error",
          test_element: "alert text content"
        }
      ],
      issue: "Alert color variants may have contrast issues with text content on colored backgrounds"
    },
    %{
      component: "Alert",
      style: "Soft",
      variants: [
        %{
          name: "Default",
          class: "alert-soft",
          test_element: "alert text content"
        },
        %{
          name: "Info",
          class: "alert-soft alert-info",
          test_element: "alert text content"
        },
        %{
          name: "Success",
          class: "alert-soft alert-success",
          test_element: "alert text content"
        },
        %{
          name: "Warning",
          class: "alert-soft alert-warning",
          test_element: "alert text content"
        },
        %{
          name: "Error",
          class: "alert-soft alert-error",
          test_element: "alert text content"
        }
      ],
      issue: "Alert soft variants use opacity/color-mix which may cause contrast issues with text content"
    },
    %{
      component: "Alert",
      style: "Outline",
      variants: [
        %{
          name: "Default",
          class: "alert-outline",
          test_element: "alert text content"
        },
        %{
          name: "Info",
          class: "alert-outline alert-info",
          test_element: "alert text content"
        },
        %{
          name: "Success",
          class: "alert-outline alert-success",
          test_element: "alert text content"
        },
        %{
          name: "Warning",
          class: "alert-outline alert-warning",
          test_element: "alert text content"
        },
        %{
          name: "Error",
          class: "alert-outline alert-error",
          test_element: "alert text content"
        }
      ],
      issue: "Alert outline variants may have insufficient contrast between border/text and background"
    },
    %{
      component: "Badge",
      style: "Standard",
      variants: [
        %{
          name: "Primary",
          class: "badge badge-primary",
          test_element: "badge text content"
        }
      ],
      issue: "Badge color variants may have contrast issues with text"
    },
    %{
      component: "Button",
      style: "Variants",
      variants: [
        %{
          name: "Default",
          class: "btn",
          test_element: "button text content"
        },
        %{
          name: "Default Soft",
          class: "btn btn-soft",
          test_element: "soft button text"
        },
        %{
          name: "Default Outline",
          class: "btn btn-outline",
          test_element: "button text content"
        },
        %{
          name: "Primary",
          class: "btn btn-primary",
          test_element: "button text content"
        },
        %{
          name: "Soft Primary",
          class: "btn btn-soft btn-primary",
          test_element: "soft button text"
        },
        %{
          name: "Outline",
          class: "btn btn-outline btn-primary",
          test_element: "button text content"
        },
        %{
          name: "Error",
          class: "btn btn-error",
          test_element: "button text content"
        },
        %{
          name: "Soft Error",
          class: "btn btn-soft btn-error",
          test_element: "soft button text"
        },
        %{
          name: "Outline Error",
          class: "btn btn-outline btn-error",
          test_element: "button text content"
        },
        %{
          name: "Success",
          class: "btn btn-success",
          test_element: "button text content"
        },
        %{
          name: "Soft Success",
          class: "btn btn-soft btn-success",
          test_element: "soft button text"
        },
        %{
          name: "Outline Success",
          class: "btn btn-outline btn-success",
          test_element: "button text content"
        },
        %{
          name: "Warning",
          class: "btn btn-warning",
          test_element: "button text content"
        },
        %{
          name: "Soft Warning",
          class: "btn btn-soft btn-warning",
          test_element: "soft button text"
        },
        %{
          name: "Outline Warning",
          class: "btn btn-outline btn-warning",
          test_element: "button text content"
        },
        %{
          name: "Info",
          class: "btn btn-info",
          test_element: "button text content"
        },
        %{
          name: "Soft Info",
          class: "btn btn-soft btn-info",
          test_element: "soft button text"
        },
        %{
          name: "Outline Info",
          class: "btn btn-outline btn-info",
          test_element: "button text content"
        },
        %{
          name: "Secondary",
          class: "btn btn-secondary",
          test_element: "button text content"
        },
        %{
          name: "Soft Secondary",
          class: "btn btn-soft btn-secondary",
          test_element: "soft button text"
        },
        %{
          name: "Outline Secondary",
          class: "btn btn-outline btn-secondary",
          test_element: "button text content"
        },
        %{
          name: "Accent",
          class: "btn btn-accent",
          test_element: "button text content"
        },
        %{
          name: "Soft Accent",
          class: "btn btn-soft btn-accent",
          test_element: "soft button text"
        },
        %{
          name: "Outline Accent",
          class: "btn btn-outline btn-accent",
          test_element: "button text content"
        },
        %{
          name: "Neutral",
          class: "btn btn-neutral",
          test_element: "button text content"
        },
        %{
          name: "Ghost",
          class: "btn btn-ghost",
          test_element: "button text content"
        },
        %{
          name: "Link",
          class: "btn btn-link",
          test_element: "button text content"
        }
      ],
      issue: "Button states (hover, active, disabled) often have insufficient contrast due to color/opacity changes"
    }
  ]

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100" phx-hook="AccessibilityChecker" id="accessibility-page">

      <!-- Header -->
      <div class="flex justify-between items-center p-6 mb-10 bg-base-200 shadow sticky top-0 z-50">
        <div>
          <.link navigate="/home" class="btn btn-ghost btn-sm">
            <.icon name="hero-arrow-left" class="h-4 w-4" /> Back to Demo
          </.link>
          <.link navigate="/colors" class="btn btn-ghost btn-sm">
            <.icon name="hero-swatch" class="h-4 w-4" /> Color Playground
          </.link>
        </div>
        <div class="flex items-center gap-4">

          <button class="btn btn-primary btn-sm" onclick="window.scanAllComponents()" id="scan-button">
              <.icon name="hero-magnifying-glass" class="h-4 w-4" />
              Scan All Components
            </button>
          <.theme_toggle />
        </div>
      </div>

      <!-- Test Results Summary -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 px-6 mb-8">
        <div class="stat bg-base-200 rounded-lg py-8">
          <div class="stat-title text-sm">Total Tests</div>
          <div class="stat-value text-2xl" id="total-tests">{Enum.sum(Enum.map(@high_risk_components, fn comp -> length(comp.variants) end))}</div>
          <div class="stat-desc">High-risk variants</div>
        </div>
        <div class="stat bg-success/10 rounded-lg py-8">
          <div class="stat-title text-sm text-success">Passing</div>
          <div class="stat-value text-2xl text-success" id="passing-count">-</div>
          <div class="stat-desc">WCAG AA compliant</div>
        </div>
        <div class="stat bg-warning/10 rounded-lg py-8">
          <div class="stat-title text-sm text-warning">Borderline</div>
          <div class="stat-value text-2xl text-warning" id="borderline-count">-</div>
          <div class="stat-desc">Close to threshold</div>
        </div>
        <div class="stat bg-error/10 rounded-lg py-8">
          <div class="stat-title text-sm text-error">Failing</div>
          <div class="stat-value text-2xl text-error" id="failing-count">-</div>
          <div class="stat-desc">Below WCAG AA</div>
        </div>
      </div>


                        <!-- Component Tests -->
      <div class="space-y-15 px-6">
        <div :for={{component, component_index} <- Enum.with_index(@high_risk_components)}>
          <div class="card bg-base-100">
            <div class="card-body bor">
              <!-- Component Header -->
              <div class="mb-6">
                <h3 class="text-base uppercase font-semibold">{component.component} - {component.style}</h3>
                <p class="text-xs text-base-content/70 mt-1">{component.issue}</p>
              </div>

              <!-- Variant Test Sections -->
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div :for={{variant, variant_index} <- Enum.with_index(component.variants)}
                     class="rounded-lg p-4 bg-base-100 shadow-sm">
                                  <!-- Class and Results Header -->
                <div class="flex justify-between items-center mb-4">
                  <code class="text-xs bg-base-300 px-3 py-2 rounded font-mono max-w-[50%] truncate" title={variant.class}>{variant.class}</code>
                    <div
                      class="contrast-result hidden"
                      id={"result-#{get_test_index(component.component, component.style, variant_index)}"}
                      data-component-index={get_test_index(component.component, component.style, variant_index)}
                    >
                      <div class="flex items-center gap-2">
                        <div class="contrast-status w-3 h-3 rounded-full"></div>
                        <span class="contrast-ratio text-sm font-mono"></span>
                        <span class="wcag-status text-xs font-medium px-2 py-1 rounded"></span>
                      </div>
                    </div>
                  </div>

                  <!-- Component Instance -->
                  <div
                    class="component-test"
                    id={"test-#{get_test_index(component.component, component.style, variant_index)}"}
                    data-component={"#{component.component}-#{component.style}"}
                    data-test-element={variant.test_element}
                    data-debug-index={get_test_index(component.component, component.style, variant_index)}
                  >
                    {component_instance(component.component, variant)}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Divider (not shown after last component) -->
          <div :if={component_index < length(@high_risk_components) - 1} class="w-full border-t border-base-content/20 my-15"></div>
        </div>
      </div>

      <!-- Export Section -->
      <div class="card bg-base-200 shadow-xl mt-8">
        <div class="card-body">
          <h2 class="card-title mb-4">Export Results</h2>
          <div class="flex gap-4">
            <button class="btn btn-outline" onclick="window.exportResults('summary')" disabled id="export-summary">
              <.icon name="hero-document-text" class="h-4 w-4" />
              Export Summary
            </button>
            <button class="btn btn-outline" onclick="window.exportResults('detailed')" disabled id="export-detailed">
              <.icon name="hero-clipboard-document-list" class="h-4 w-4" />
              Export Detailed Report
            </button>
            <button class="btn btn-outline btn-primary" onclick="console.log('Debug info:', document.querySelectorAll('.component-test'))">
              Debug Test Elements
            </button>
          </div>

          <!-- Debug Info -->
          <div class="mt-4 text-xs text-base-content/60">
            <details>
              <summary>Debug: Test Indices</summary>
              <div class="grid grid-cols-4 gap-2 mt-2 font-mono">
                <div :for={component <- @high_risk_components}>
                  <div class="font-semibold">{component.component} - {component.style}</div>
                  <div :for={{variant, idx} <- Enum.with_index(component.variants)} class="text-xs">
                    {variant.name}: #{get_test_index(component.component, component.style, idx)}
                  </div>
                </div>
              </div>
            </details>
          </div>
        </div>
      </div>
    </div>
    """
  end

      # Helper function to render different component instances
  defp component_instance("Alert", variant) do
    assigns = %{variant: variant}
    ~H"""
    <.alert class={@variant.class}>
      <.icon name="hero-information-circle" class="h-5 w-5" />
      <span>This is an alert with background that may affect text contrast</span>
    </.alert>
    """
  end

  defp component_instance("Badge", variant) do
    assigns = %{variant: variant, name: variant.name}
    ~H"""
    <.badge class={@variant.class}>{@name} Badge</.badge>
    """
  end

  defp component_instance("Button", variant) do
    assigns = %{variant: variant, is_disabled: variant.name == "Disabled"}
    ~H"""
    <.button class={@variant.class} disabled={@is_disabled}>
      Button
    </.button>
    """
  end

  defp component_instance(component_name, variant) do
    assigns = %{component_name: component_name, variant: variant}
    ~H"""
    <div class="p-4 bg-warning/10 rounded">
      <p class="text-warning">Component type "{@component_name}" not yet implemented</p>
      <code class="text-xs">{@variant.class}</code>
    </div>
    """
  end



  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:high_risk_components, @high_risk_components)
     |> push_event("setup-theme-switcher", %{})
     |> push_event("setup-accessibility-checker", %{})}
  end
end
