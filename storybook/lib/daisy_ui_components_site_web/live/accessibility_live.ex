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
      {"Alert", "Variants"} => 0,
      {"Badge", "Standard"} => 20,
      {"Button", "Variants"} => 50,
      {"Disabled", "Variants"} => 80
    }

    base_index = Map.get(base_indices, {component_name, style}, 0)
    base_index + variant_index
  end

  # Simplified high-risk components for controlled testing
  @high_risk_components [
    %{
      component: "Alert",
      style: "Variants",
      variants: [
        # Default color variants
        %{
          name: "Default",
          class: "alert",
          test_element: "alert text content"
        },
        %{
          name: "Default Soft",
          class: "alert-soft",
          test_element: "alert text content"
        },
        %{
          name: "Default Outline",
          class: "alert-outline",
          test_element: "alert text content"
        },
        # Info color variants
        %{
          name: "Info",
          class: "alert alert-info",
          test_element: "alert text content"
        },
        %{
          name: "Info Soft",
          class: "alert-soft alert-info",
          test_element: "alert text content"
        },
        %{
          name: "Info Outline",
          class: "alert-outline alert-info",
          test_element: "alert text content"
        },
        # Success color variants
        %{
          name: "Success",
          class: "alert alert-success",
          test_element: "alert text content"
        },
        %{
          name: "Success Soft",
          class: "alert-soft alert-success",
          test_element: "alert text content"
        },
        %{
          name: "Success Outline",
          class: "alert-outline alert-success",
          test_element: "alert text content"
        },
        # Warning color variants
        %{
          name: "Warning",
          class: "alert alert-warning",
          test_element: "alert text content"
        },
        %{
          name: "Warning Soft",
          class: "alert-soft alert-warning",
          test_element: "alert text content"
        },
        %{
          name: "Warning Outline",
          class: "alert-outline alert-warning",
          test_element: "alert text content"
        },
        # Error color variants
        %{
          name: "Error",
          class: "alert alert-error",
          test_element: "alert text content"
        },
        %{
          name: "Error Soft",
          class: "alert-soft alert-error",
          test_element: "alert text content"
        },
        %{
          name: "Error Outline",
          class: "alert-outline alert-error",
          test_element: "alert text content"
        }
      ],
      issue: "Alert variants (standard, soft, outline) across different colors may have contrast issues due to color-mix and opacity usage"
    },
    %{
      component: "Badge",
      style: "Standard",
      variants: [
        %{
          name: "Default",
          class: "badge",
          test_element: "badge text content"
        },
        %{
          name: "Default Soft",
          class: "badge badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Default Outline",
          class: "badge badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Primary",
          class: "badge badge-primary",
          test_element: "badge text content"
        },
        %{
          name: "Primary Soft",
          class: "badge badge-primary badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Primary Outline",
          class: "badge badge-primary badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Error",
          class: "badge badge-error",
          test_element: "badge text content"
        },
        %{
          name: "Error Soft",
          class: "badge badge-error badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Error Outline",
          class: "badge badge-error badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Success",
          class: "badge badge-success",
          test_element: "badge text content"
        },
        %{
          name: "Success Soft",
          class: "badge badge-success badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Success Outline",
          class: "badge badge-success badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Warning",
          class: "badge badge-warning",
          test_element: "badge text content"
        },
        %{
          name: "Warning Soft",
          class: "badge badge-warning badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Warning Outline",
          class: "badge badge-warning badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Info",
          class: "badge badge-info",
          test_element: "badge text content"
        },
        %{
          name: "Info Soft",
          class: "badge badge-info badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Info Outline",
          class: "badge badge-info badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Secondary",
          class: "badge badge-secondary",
          test_element: "badge text content"
        },
        %{
          name: "Secondary Soft",
          class: "badge badge-secondary badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Secondary Outline",
          class: "badge badge-secondary badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Accent",
          class: "badge badge-accent",
          test_element: "badge text content"
        },
        %{
          name: "Accent Soft",
          class: "badge badge-accent badge-soft",
          test_element: "badge text content"
        },
        %{
          name: "Accent Outline",
          class: "badge badge-accent badge-outline",
          test_element: "badge text content"
        },
        %{
          name: "Neutral",
          class: "badge badge-neutral",
          test_element: "badge text content"
        },
        %{
          name: "Ghost",
          class: "badge badge-ghost",
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
    },
    %{
      component: "Disabled",
      style: "Variants",
      variants: [
        %{
          name: "Disabled Button",
          class: "btn btn-disabled",
          test_element: "button text content"
        },
        %{
          name: "Disabled Input",
          class: "input input-disabled",
          test_element: "input placeholder or value"
        },
        %{
          name: "Disabled Select",
          class: "select select-disabled",
          test_element: "select placeholder or options"
        },
        %{
          name: "Disabled Checkbox",
          class: "checkbox checkbox-disabled",
          test_element: "checkbox label text"
        },
        %{
          name: "Disabled Radio",
          class: "radio radio-disabled",
          test_element: "radio label text"
        },
        %{
          name: "Disabled Toggle",
          class: "toggle toggle-disabled",
          test_element: "toggle label text"
        },
        %{
          name: "Disabled Checkbox (Checked)",
          class: "checkbox checkbox-disabled checkbox-checked",
          test_element: "checkbox label text"
        },
        %{
          name: "Disabled Radio (Checked)",
          class: "radio radio-disabled radio-checked",
          test_element: "radio label text"
        },
        %{
          name: "Disabled Toggle (Checked)",
          class: "toggle toggle-disabled toggle-checked",
          test_element: "toggle label text"
        }
      ],
      issue: "Disabled components often fail contrast requirements due to reduced opacity or faded colors"
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
        <div class="flex items-center gap-3">
          <button class="btn btn-ghost btn-sm hidden" onclick="window.resetScanResults()" id="reset-button">
            <.icon name="hero-arrow-path" class="h-4 w-4" />
            Reset
          </button>
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
    assigns = %{variant: variant}
    ~H"""
    <.badge class={@variant.class}>Badge</.badge>
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

  defp component_instance("Disabled", variant) do
    assigns = %{variant: variant}
    ~H"""
    <div :if={String.contains?(@variant.class, "btn")}>
      <.button class={@variant.class} disabled={true}>
        Disabled Button
      </.button>
    </div>
    <div :if={String.contains?(@variant.class, "input")}>
      <.input class={@variant.class} disabled={true} placeholder="Disabled input field" />
    </div>
    <div :if={String.contains?(@variant.class, "select")}>
      <select class={@variant.class} disabled={true}>
        <option>Choose option...</option>
        <option>Option 1</option>
        <option>Option 2</option>
      </select>
    </div>
    <div :if={String.contains?(@variant.class, "checkbox")}>
      <label class="label cursor-pointer justify-start gap-3">
        <input
          type="checkbox"
          class={String.replace(@variant.class, "checkbox-checked", "")}
          disabled={true}
          checked={String.contains?(@variant.class, "checked")}
        />
        <span class="label-text">{if String.contains?(@variant.class, "checked"), do: "Disabled checkbox (checked)", else: "Disabled checkbox"}</span>
      </label>
    </div>
    <div :if={String.contains?(@variant.class, "radio")}>
      <label class="label cursor-pointer justify-start gap-3">
        <input
          type="radio"
          class={String.replace(@variant.class, "radio-checked", "")}
          disabled={true}
          checked={String.contains?(@variant.class, "checked")}
        />
        <span class="label-text">{if String.contains?(@variant.class, "checked"), do: "Disabled radio (checked)", else: "Disabled radio"}</span>
      </label>
    </div>
    <div :if={String.contains?(@variant.class, "toggle")}>
      <label class="label cursor-pointer justify-start gap-3">
        <input
          type="checkbox"
          class={String.replace(@variant.class, "toggle-checked", "")}
          disabled={true}
          checked={String.contains?(@variant.class, "checked")}
        />
        <span class="label-text">{if String.contains?(@variant.class, "checked"), do: "Disabled toggle (checked)", else: "Disabled toggle"}</span>
      </label>
    </div>
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
