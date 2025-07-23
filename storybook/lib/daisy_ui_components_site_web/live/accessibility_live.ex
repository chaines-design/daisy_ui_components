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
  import DaisyUIComponents.Checkbox
  import DaisyUIComponents.TextInput
  import DaisyUIComponents.Select
  import DaisyUIComponents.Radio
  import DaisyUIComponents.Range
  import DaisyUIComponents.Textarea
  import DaisyUIComponents.Toggle
  import DaisyUIComponents.Menu
  import DaisyUIComponents.Icon
  import DaisyUIComponents.Label

  # High-risk components data from CSV
  @high_risk_components [
    %{
      component: "Alert",
      class: "alert-soft alert-info",
      issue: "8% opacity background mix affects text contrast",
      test_element: "text content on soft alert background"
    },
    %{
      component: "Badge",
      class: "badge-soft badge-primary",
      issue: "8% opacity background mix affects text contrast",
      test_element: "badge text on soft background"
    },
    %{
      component: "Button",
      class: "btn btn-primary",
      issue: "Background changes on hover/active affect text contrast",
      test_element: "button text on hover state"
    },
    %{
      component: "Button (disabled)",
      class: "btn btn-disabled",
      issue: "Disabled button background + color-mix usage",
      test_element: "disabled button text"
    },
    %{
      component: "Button",
      class: "btn btn-active btn-primary",
      issue: "Background changes affect text contrast",
      test_element: "active button text"
    },
    %{
      component: "Button",
      class: "btn btn-soft btn-primary",
      issue: "Background changes affect text contrast",
      test_element: "soft button text"
    },
    %{
      component: "Checkbox (disabled)",
      class: "checkbox opacity-20",
      issue: "20% opacity affects form control visibility",
      test_element: "disabled checkbox visibility"
    },
    %{
      component: "Input (disabled)",
      class: "input input-bordered text-base-content/40",
      issue: "Disabled input text 40% + placeholder 20% opacity",
      test_element: "disabled input text and placeholder"
    },
    %{
      component: "Link",
      class: "link link-primary",
      issue: "Text color changes on hover - 80%/20% mix",
      test_element: "link text on hover"
    },
    %{
      component: "Menu (disabled)",
      class: "menu text-base-content/20",
      issue: "20% opacity affects readability",
      test_element: "disabled menu item text"
    },
    %{
      component: "Radio (disabled)",
      class: "radio opacity-20",
      issue: "20% opacity affects form control visibility",
      test_element: "disabled radio button visibility"
    },
    %{
      component: "Range (disabled)",
      class: "range opacity-30",
      issue: "30% opacity affects form control visibility",
      test_element: "disabled range slider visibility"
    },
    %{
      component: "Select (disabled)",
      class: "select select-bordered text-base-content/40",
      issue: "Disabled select text 40% + placeholder 20% opacity",
      test_element: "disabled select text and placeholder"
    },
    %{
      component: "Textarea (disabled)",
      class: "textarea textarea-bordered text-base-content/40",
      issue: "Disabled textarea text 40% + placeholder 20% opacity",
      test_element: "disabled textarea text and placeholder"
    },
    %{
      component: "Toggle (disabled)",
      class: "toggle opacity-30",
      issue: "30% opacity affects form control visibility",
      test_element: "disabled toggle visibility"
    }
  ]

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100 p-6" phx-hook="AccessibilityChecker" id="accessibility-page">
      <!-- Header -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h1 class="text-4xl font-bold text-base-content">Accessibility Testing</h1>
          <p class="text-base-content/70 mt-2">WCAG AA Contrast Ratio Analysis for High-Risk Components</p>
        </div>
        <div class="flex items-center gap-4">
          <.link navigate="/colors" class="btn btn-outline btn-sm">
            <.icon name="hero-swatch" class="h-4 w-4" /> Color Playground
          </.link>
          <.link navigate="/home" class="btn btn-outline btn-sm">
            <.icon name="hero-arrow-left" class="h-4 w-4" /> Back to Demo
          </.link>
          <.theme_toggle />
        </div>
      </div>

      <!-- Test Results Summary -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
        <div class="stat bg-base-200 rounded-lg">
          <div class="stat-title text-sm">Total Tests</div>
          <div class="stat-value text-2xl" id="total-tests">{length(@high_risk_components)}</div>
          <div class="stat-desc">High-risk components</div>
        </div>
        <div class="stat bg-success/10 rounded-lg">
          <div class="stat-title text-sm">Passing</div>
          <div class="stat-value text-2xl text-success" id="passing-count">-</div>
          <div class="stat-desc">WCAG AA compliant</div>
        </div>
        <div class="stat bg-warning/10 rounded-lg">
          <div class="stat-title text-sm">Borderline</div>
          <div class="stat-value text-2xl text-warning" id="borderline-count">-</div>
          <div class="stat-desc">Close to threshold</div>
        </div>
        <div class="stat bg-error/10 rounded-lg">
          <div class="stat-title text-sm">Failing</div>
          <div class="stat-value text-2xl text-error" id="failing-count">-</div>
          <div class="stat-desc">Below WCAG AA</div>
        </div>
      </div>

      <!-- Scan Controls -->
      <div class="card bg-base-200 shadow-xl mb-8">
        <div class="card-body">
          <div class="flex justify-between items-center">
            <div>
              <h2 class="card-title">Contrast Testing</h2>
              <p class="text-base-content/70">WCAG AA: 4.5:1 normal text, 3:1 large text (18pt+ or 14pt+ bold)</p>
            </div>
            <button class="btn btn-primary" onclick="window.scanAllComponents()" id="scan-button">
              <.icon name="hero-magnifying-glass" class="h-4 w-4" />
              Scan All Components
            </button>
          </div>
        </div>
      </div>

      <!-- Component Tests -->
      <div class="space-y-8">
        <div :for={{component, index} <- Enum.with_index(@high_risk_components)} class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <div class="flex justify-between items-start mb-4">
              <div>
                <h3 class="text-xl font-semibold">{component.component}</h3>
                <p class="text-sm text-base-content/70 mt-1">{component.issue}</p>
                <code class="text-xs bg-base-300 px-2 py-1 rounded mt-2 inline-block">{component.class}</code>
              </div>
              <div class="flex items-center gap-2">
                <div
                  class="contrast-result hidden"
                  id={"result-#{index}"}
                  data-component-index={index}
                >
                  <div class="flex items-center gap-2">
                    <div class="contrast-status w-3 h-3 rounded-full"></div>
                    <span class="contrast-ratio text-sm font-mono"></span>
                    <span class="wcag-status text-xs font-medium px-2 py-1 rounded"></span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Component Instance -->
            <div class="border border-base-300 rounded-lg p-6 bg-base-100">
              <div
                class="component-test"
                id={"test-#{index}"}
                data-component={component.component}
                data-test-element={component.test_element}
              >
                {component_instance(component, index)}
              </div>
            </div>

            <!-- Remediation Suggestions -->
            <div class="remediation-suggestions hidden mt-4 p-4 bg-warning/10 rounded-lg" id={"remediation-#{index}"}>
              <h4 class="font-medium text-warning mb-2">⚠️ Remediation Suggestions</h4>
              <div class="remediation-content text-sm space-y-2"></div>
            </div>
          </div>
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
          </div>
        </div>
      </div>
    </div>
    """
  end

  # Helper function to render different component instances
  defp component_instance(%{component: "Alert"} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <.alert class={@component.class}>
      <.icon name="hero-information-circle" class="h-5 w-5" />
      <span>This is a soft alert with background opacity that may affect text contrast</span>
    </.alert>
    """
  end

  defp component_instance(%{component: "Badge"} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <.badge class={@component.class}>Primary Badge</.badge>
    """
  end

  defp component_instance(%{component: "Button" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <.button class={@component.class} disabled={String.contains?(@component.component, "disabled")}>
      {if String.contains?(@component.component, "disabled"), do: "Disabled Button", else: "Button Text"}
    </.button>
    """
  end

  defp component_instance(%{component: "Checkbox" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <label class="flex items-center gap-2">
      <.checkbox class={@component.class} disabled={String.contains?(@component.component, "disabled")} />
      <span class={["label-text", if(String.contains?(@component.component, "disabled"), do: "text-base-content/40", else: "")]}>
        {if String.contains?(@component.component, "disabled"), do: "Disabled Checkbox", else: "Checkbox Label"}
      </span>
    </label>
    """
  end

  defp component_instance(%{component: "Input" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div>
      <.label class="label-text font-medium text-sm text-base-content block">Input Field</.label>
      <.text_input
        class={@component.class}
        placeholder="Placeholder text with reduced opacity"
        value={if String.contains?(@component.component, "disabled"), do: "Disabled input text"}
        disabled={String.contains?(@component.component, "disabled")}
      />
    </div>
    """
  end

  defp component_instance(%{component: "Link"} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div class="space-y-2">
      <a href="#" class={@component.class}>Primary Link (hover to test)</a>
      <a href="#" class="link link-secondary">Secondary Link</a>
      <a href="#" class="link link-accent">Accent Link</a>
    </div>
    """
  end

  defp component_instance(%{component: "Menu" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <.menu class="bg-base-200 w-56">
      <:item><a>Regular Menu Item</a></:item>
      <:item><a class={@component.class}>Disabled Menu Item</a></:item>
      <:item><a>Another Regular Item</a></:item>
    </.menu>
    """
  end

  defp component_instance(%{component: "Radio" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div class="space-y-2">
      <label class="flex items-center gap-2">
        <.radio name={"radio-#{@index}"} class="radio radio-primary" />
        <span class="label-text">Regular Radio</span>
      </label>
      <label class="flex items-center gap-2">
        <.radio name={"radio-#{@index}"} class={@component.class} disabled={String.contains?(@component.component, "disabled")} />
        <span class={["label-text", if(String.contains?(@component.component, "disabled"), do: "text-base-content/40", else: "")]}>
          {if String.contains?(@component.component, "disabled"), do: "Disabled Radio", else: "Radio Label"}
        </span>
      </label>
    </div>
    """
  end

  defp component_instance(%{component: "Range" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div class="space-y-4">
      <div>
        <.label class="label-text font-medium text-sm text-base-content block">Regular Range</.label>
        <.range class="range range-primary" />
      </div>
      <div>
        <.label class="label-text font-medium text-sm text-base-content/40 block">Disabled Range</.label>
        <.range class={@component.class} disabled={String.contains?(@component.component, "disabled")} />
      </div>
    </div>
    """
  end

  defp component_instance(%{component: "Select" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div>
      <.label class="label-text font-medium text-sm text-base-content block">Select Field</.label>
      <.select class={@component.class} disabled={String.contains?(@component.component, "disabled")}>
        <option disabled selected>
          {if String.contains?(@component.component, "disabled"), do: "Disabled placeholder", else: "Choose option"}
        </option>
        <option>Option 1</option>
        <option>Option 2</option>
      </.select>
    </div>
    """
  end

  defp component_instance(%{component: "Textarea" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div>
      <.label class="label-text font-medium text-sm text-base-content block">Textarea Field</.label>
      <.textarea
        class={@component.class}
        placeholder="Placeholder text with reduced opacity"
        disabled={String.contains?(@component.component, "disabled")}
      >
        {if String.contains?(@component.component, "disabled"), do: "Disabled textarea content"}
      </.textarea>
    </div>
    """
  end

  defp component_instance(%{component: "Toggle" <> _} = component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div class="space-y-2">
      <label class="flex items-center gap-2">
        <.toggle class="toggle toggle-primary" />
        <span class="label-text">Regular Toggle</span>
      </label>
      <label class="flex items-center gap-2">
        <.toggle class={@component.class} disabled={String.contains?(@component.component, "disabled")} />
        <span class={["label-text", if(String.contains?(@component.component, "disabled"), do: "text-base-content/40", else: "")]}>
          {if String.contains?(@component.component, "disabled"), do: "Disabled Toggle", else: "Toggle Label"}
        </span>
      </label>
    </div>
    """
  end

  defp component_instance(component, index) do
    assigns = %{component: component, index: index}
    ~H"""
    <div class="p-4 bg-warning/10 rounded">
      <p class="text-warning">Component type "{@component.component}" not yet implemented</p>
      <code class="text-xs">{@component.class}</code>
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
