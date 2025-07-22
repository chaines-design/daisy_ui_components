defmodule DaisyUIComponentsSiteWeb.HomeLive do
  @moduledoc false
  use DaisyUIComponentsSiteWeb, :live_view

      def render(assigns) do
      ~H"""
      <div class="flex h-screen">
        <!-- Sidebar Navigation -->
        <div class="flex flex-col justify-between w-56 bg-primary">
        <div class="pt-6">
          <%!-- Added the Tailwind arbitrary selector [&_li>a]:w-full to force all anchor tags to be full width --%>
          <.menu class="bg-transparent text-primary-content w-full [&_li>a]:w-full">
            <:item class="menu-title text-primary-content/70">Rose Johnson</:item>
            <:item><a><.icon name="hero-home" class="h-5 w-5" /> Home</a></:item>
            <:item><a><.icon name="hero-sun" class="h-5 w-5" /> Theme</a></:item>
            <:item class="menu-title text-primary-content/70 pt-8">Taxes</:item>
            <:item><a><.icon name="hero-building-storefront" class="h-5 w-5" /> Businesses</a></:item>
            <:item><a><.icon name="hero-currency-dollar" class="h-5 w-5" /> Payments</a></:item>
            <:item><a><.icon name="hero-folder-open" class="h-5 w-5" /> Records</a></:item>
            <:item><a><.icon name="hero-document-chart-bar" class="h-5 w-5" /> Reports</a></:item>
            <:item class="menu-title text-primary-content/70 pt-8">Configuration</:item>
            <:item><a><.icon name="hero-calendar" class="h-5 w-5" /> Calendars</a></:item>
            <:item><a><.icon name="hero-user-circle" class="h-5 w-5" /> Users</a></:item>
            <:item><a><.icon name="hero-cog-6-tooth" class="h-5 w-5" /> Configuration</a></:item>
          </.menu>
        </div>
        <div class="py-2">
          <%!-- Added the Tailwind arbitrary selector [&_li>a]:w-full to force all anchor tags to be full width --%>
          <.menu class="bg-transparent text-primary-content w-full [&_li>a]:w-full">
            <:item><a><.icon name="hero-arrow-right-on-rectangle" class="h-5 w-5" /> Log Out</a></:item>
          </.menu>
        </div>
        </div>

        <!-- Main Content Area -->
        <div class="flex-1 bg-base-200 p-6">
          <%!-- Nav Breadcrumbs --%>
          <.breadcrumbs class="text-xs pt-5 px-6">
            <:item class="text-primary/70" path="/">Taxes</:item>
            <:item path="/businesses">Businesses</:item>
            <:item path="/newbusiness">Register a Business</:item>
          </.breadcrumbs>

          <!-- Business Registration Form -->
          <div class="flex flex-col gap-4 pt-8">

           <!-- Content Container with Stepper and Form -->
           <div class="flex gap-6">
             <!-- Stepper -->
                <div class="flex justify-start gap-4 p-4 bg-base-200 rounded-lg h-fit w-60">
                <.steps class="steps-vertical text-sm">
                 <.step class="step-primary">Business Info</.step>
                 <.step class="step-primary">Ownership Info</.step>
                 <.step class="step-primary">Activities</.step>
                 <.step class="step-primary">Taxes & Fees</.step>
                 <.step class="step-primary">Locations</.step>
                 <.step>Review & Submit</.step>
                </.steps>
              </div>

              <!-- Form Container -->
                <div class="flex-1 bg-base-200 px-6 py-8 rounded-lg max-w-4xl">
                 <h2 class="text-3xl font-light mb-1">Add a Location</h2>
                 <p class="text-base-content/70 text-sm mb-12">Each location name, FBN (fictitious business name) or DBA (doing business as) name should be listed as a separate location.</p>

                 <!-- Form -->
                 <form class="space-y-8">
                   <!-- Location Section -->
                   <div class="grid grid-cols-3 gap-2">
                     <div class="col-span-1">
                       <h3 class="text-base font-medium py-1">Location</h3>
                     </div>
                     <div class="col-span-2 space-y-4">
                       <!-- Name Field -->
                       <div>
                         <.label class="label-text font-medium text-sm text-base-content block">Location Name</.label>
                         <.text_input class="input input-bordered w-full mt-1" placeholder="Enter location name" />
                       </div>

                       <!-- Start Date Field -->
                       <div>
                         <.label class="label-text font-medium text-sm text-base-content block">Start Date</.label>
                         <.text_input type="date" class="input input-bordered w-60 mt-1" />
                       </div>
                     </div>
                   </div>

                   <!-- Divider -->
                   <div class="divider"></div>

                   <!-- Address Section -->
                   <div class="grid grid-cols-3 gap-2">
                     <div class="col-span-1">
                       <h3 class="text-base font-medium py-1">Address</h3>
                     </div>
                     <div class="col-span-2 space-y-4">
                       <!-- Address Line 1 -->
                       <div>
                         <.label class="label-text font-medium text-sm text-base-content block">Address Line 1</.label>
                         <.text_input class="input input-bordered w-full mt-1" placeholder="Street address" />
                       </div>

                       <!-- Address Line 2 -->
                       <div>
                         <.label class="label-text font-medium text-sm text-base-content block">Address Line 2 <span class="text-base-content/50">(Optional)</span></.label>
                         <.text_input class="input input-bordered w-full mt-1" placeholder="Apartment, suite, etc." />
                       </div>

                       <!-- City, State, Zip Row -->
                       <div class="grid grid-cols-3 gap-4">
                         <div>
                           <.label class="label-text font-medium text-sm text-base-content block">City</.label>
                           <.text_input class="input input-bordered w-full mt-1" placeholder="City" />
                         </div>
                         <div>
                           <.label class="label-text font-medium text-sm text-base-content block">State</.label>
                           <.select class="select select-bordered w-full mt-1">
                             <option disabled selected>Select state</option>
                             <option>CA</option>
                             <option>NY</option>
                             <option>TX</option>
                             <option>FL</option>
                           </.select>
                         </div>
                         <div>
                           <.label class="label-text font-medium text-sm text-base-content block">Zip Code</.label>
                           <.text_input class="input input-bordered w-full mt-1" placeholder="12345" />
                         </div>
                       </div>
                     </div>
                   </div>

                   <!-- Divider -->
                   <div class="divider"></div>

                   <!-- Details Section -->
                   <div class="grid grid-cols-3 gap-2">
                     <div class="col-span-1">
                       <h3 class="text-base font-medium py-1">Details</h3>
                     </div>
                     <div class="col-span-2 space-y-6">
                       <!-- Radio Set 1 -->
                       <div class="space-y-3">
                         <h4 class="text-sm">Is this a <a class="text-primary cursor-pointer">commercial use</a> location?</h4>
                         <div class="flex gap-6">
                           <label class="flex items-center gap-2 cursor-pointer">
                             <.radio name="question1" value="yes" class="radio-sm" />
                             <span class="label-text text-sm">Yes</span>
                           </label>
                           <label class="flex items-center gap-2 cursor-pointer">
                             <.radio name="question1" value="no" class="radio-sm " />
                             <span class="label-text text-sm">No</span>
                           </label>
                         </div>
                       </div>

                       <!-- Radio Set 2 -->
                       <div class="space-y-3">
                         <h4 class="text-sm">Will this location be operated from a <a class="text-primary cursor-pointer">home or other residential location?</a></h4>
                         <div class="flex gap-6">
                           <label class="flex items-center gap-2 cursor-pointer">
                             <.radio name="question2" value="yes" class="radio-sm" />
                             <span class="label-text text-sm">Yes</span>
                           </label>
                           <label class="flex items-center gap-2 cursor-pointer">
                             <.radio name="question2" value="no" class="radio-sm" />
                             <span class="label-text text-sm">No</span>
                           </label>
                         </div>
                       </div>
                     </div>
                   </div>

                   <!-- Form Actions -->
                   <div class="flex justify-between items-center pt-8">
                     <.button class="btn btn-ghost"><.icon name="hero-arrow-left" class="h-4 w-4" /> All Locations</.button>
                     <div class="flex gap-2">
                       <.button class="btn btn-outline">Cancel</.button>
                       <.button class="btn btn-primary">Save Location</.button>
                     </div>
                   </div>
                 </form>
                </div>
            </div>
          </div>
        </div>
      </div>
      """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
