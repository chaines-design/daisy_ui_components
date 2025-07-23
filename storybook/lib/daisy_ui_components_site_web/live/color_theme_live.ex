defmodule DaisyUIComponentsSiteWeb.ColorThemeLive do
  @moduledoc false
  use DaisyUIComponentsSiteWeb, :live_view

  import DaisyUIComponents.ThemeToggle
  import DaisyUIComponents.Button
  import DaisyUIComponents.TextInput
  import DaisyUIComponents.Select
  import DaisyUIComponents.Checkbox
  import DaisyUIComponents.Radio
  import DaisyUIComponents.Toggle
  import DaisyUIComponents.Alert
  import DaisyUIComponents.Icon
  import DaisyUIComponents.Label

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100 p-6">
      <!-- Header with Theme Toggle -->
      <div class="flex justify-between items-center mb-8">
        <div>
          <h1 class="text-4xl font-bold text-base-content">Color & Theme Playground</h1>
          <p class="text-base-content/70 mt-2">Experiment with DaisyUI colors and themes</p>
        </div>
        <div class="flex items-center gap-4">
          <.link navigate="/accessibility" class="btn btn-outline btn-sm">
            <.icon name="hero-eye" class="h-4 w-4" /> Accessibility
          </.link>
          <.link navigate="/home" class="btn btn-outline btn-sm">
            <.icon name="hero-arrow-left" class="h-4 w-4" /> Back to Demo
          </.link>
          <.theme_toggle />
        </div>
      </div>

      <!-- Color Palette Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Brand Colors -->
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title text-2xl mb-4">Brand Colors</h2>
            <div class="grid grid-cols-2 gap-4">
              <div class="p-4 bg-primary rounded-lg">
                <div class="text-primary-content font-medium">Primary</div>
                <div class="text-primary-content/70 text-sm">Main brand color</div>
              </div>
              <div class="p-4 bg-secondary rounded-lg">
                <div class="text-secondary-content font-medium">Secondary</div>
                <div class="text-secondary-content/70 text-sm">Secondary brand</div>
              </div>
              <div class="p-4 bg-accent rounded-lg">
                <div class="text-accent-content font-medium">Accent</div>
                <div class="text-accent-content/70 text-sm">Accent color</div>
              </div>
              <div class="p-4 bg-neutral rounded-lg">
                <div class="text-neutral-content font-medium">Neutral</div>
                <div class="text-neutral-content/70 text-sm">Neutral tone</div>
              </div>
            </div>
          </div>
        </div>

        <!-- State Colors -->
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title text-2xl mb-4">State Colors</h2>
            <div class="grid grid-cols-2 gap-4">
              <div class="p-4 bg-info rounded-lg">
                <div class="text-info-content font-medium">Info</div>
                <div class="text-info-content/70 text-sm">Information</div>
              </div>
              <div class="p-4 bg-success rounded-lg">
                <div class="text-success-content font-medium">Success</div>
                <div class="text-success-content/70 text-sm">Success state</div>
              </div>
              <div class="p-4 bg-warning rounded-lg">
                <div class="text-warning-content font-medium">Warning</div>
                <div class="text-warning-content/70 text-sm">Warning state</div>
              </div>
              <div class="p-4 bg-error rounded-lg">
                <div class="text-error-content font-medium">Error</div>
                <div class="text-error-content/70 text-sm">Error state</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Base Colors Section -->
      <div class="card bg-base-200 shadow-xl mb-8">
        <div class="card-body">
          <h2 class="card-title text-2xl mb-4">Base Colors</h2>
          <div class="grid grid-cols-3 gap-4">
            <div class="p-4 bg-base-100 border border-base-300 rounded-lg">
              <div class="text-base-content font-medium">Base 100</div>
              <div class="text-base-content/70 text-sm">Page background</div>
            </div>
            <div class="p-4 bg-base-200 rounded-lg">
              <div class="text-base-content font-medium">Base 200</div>
              <div class="text-base-content/70 text-sm">Elevated background</div>
            </div>
            <div class="p-4 bg-base-300 rounded-lg">
              <div class="text-base-content font-medium">Base 300</div>
              <div class="text-base-content/70 text-sm">Borders & dividers</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Interactive Components -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Buttons -->
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title text-2xl mb-4">Button Variations</h2>
            <div class="space-y-4">
              <div class="flex gap-2 flex-wrap">
                <.button class="btn btn-primary">Primary</.button>
                <.button class="btn btn-secondary">Secondary</.button>
                <.button class="btn btn-accent">Accent</.button>
              </div>
              <div class="flex gap-2 flex-wrap">
                <.button class="btn btn-info">Info</.button>
                <.button class="btn btn-success">Success</.button>
                <.button class="btn btn-warning">Warning</.button>
                <.button class="btn btn-error">Error</.button>
              </div>
              <div class="flex gap-2 flex-wrap">
                <.button class="btn btn-outline btn-primary">Outline</.button>
                <.button class="btn btn-ghost">Ghost</.button>
                <.button class="btn btn-link">Link</.button>
              </div>
            </div>
          </div>
        </div>

        <!-- Form Elements -->
        <div class="card bg-base-200 shadow-xl">
          <div class="card-body">
            <h2 class="card-title text-2xl mb-4">Form Elements</h2>
            <div class="space-y-4">
              <div>
                <.label class="label-text font-medium text-sm text-base-content block">Text Input</.label>
                <.text_input class="input input-bordered w-full mt-1" placeholder="Type something..." />
              </div>
              <div>
                <.label class="label-text font-medium text-sm text-base-content block">Primary Input</.label>
                <.text_input class="input input-bordered input-primary w-full mt-1" placeholder="Primary style" />
              </div>
              <div>
                <.label class="label-text font-medium text-sm text-base-content block">Select</.label>
                <.select class="select select-bordered w-full mt-1">
                  <option disabled selected>Choose an option</option>
                  <option>Option 1</option>
                  <option>Option 2</option>
                </.select>
              </div>
              <div class="flex items-center gap-4">
                <label class="flex items-center gap-2 cursor-pointer">
                  <.checkbox class="checkbox checkbox-primary" />
                  <span class="label-text">Checkbox</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer">
                  <.radio name="demo" class="radio radio-primary" />
                  <span class="label-text">Radio</span>
                </label>
                <label class="flex items-center gap-2 cursor-pointer">
                  <.toggle class="toggle toggle-primary" />
                  <span class="label-text">Toggle</span>
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Alerts & Feedback -->
      <div class="card bg-base-200 shadow-xl mb-8">
        <div class="card-body">
          <h2 class="card-title text-2xl mb-4">Alerts & Feedback</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <.alert class="alert alert-info">
              <.icon name="hero-information-circle" class="h-6 w-6" />
              <span>This is an info alert</span>
            </.alert>
            <.alert class="alert alert-success">
              <.icon name="hero-check-circle" class="h-6 w-6" />
              <span>This is a success alert</span>
            </.alert>
            <.alert class="alert alert-warning">
              <.icon name="hero-exclamation-triangle" class="h-6 w-6" />
              <span>This is a warning alert</span>
            </.alert>
            <.alert class="alert alert-error">
              <.icon name="hero-x-circle" class="h-6 w-6" />
              <span>This is an error alert</span>
            </.alert>
          </div>
        </div>
      </div>

      <!-- Typography Showcase -->
      <div class="card bg-base-200 shadow-xl">
        <div class="card-body">
          <h2 class="card-title text-2xl mb-4">Typography</h2>
          <div class="space-y-4">
            <div>
              <h1 class="text-4xl font-bold text-base-content">Heading 1</h1>
              <h2 class="text-3xl font-bold text-base-content">Heading 2</h2>
              <h3 class="text-2xl font-bold text-base-content">Heading 3</h3>
              <h4 class="text-xl font-bold text-base-content">Heading 4</h4>
            </div>
            <div class="space-y-2">
              <p class="text-base-content">This is regular body text that adapts to the current theme.</p>
              <p class="text-base-content/70">This is muted text at 70% opacity.</p>
              <p class="text-base-content/50">This is very muted text at 50% opacity.</p>
            </div>
            <div class="flex gap-4 flex-wrap">
              <span class="text-primary">Primary text</span>
              <span class="text-secondary">Secondary text</span>
              <span class="text-accent">Accent text</span>
              <span class="text-info">Info text</span>
              <span class="text-success">Success text</span>
              <span class="text-warning">Warning text</span>
              <span class="text-error">Error text</span>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> push_event("setup-theme-switcher", %{})}
  end
end
