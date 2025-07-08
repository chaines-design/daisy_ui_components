defmodule Storybook.Components.Sheet do
  use PhoenixStorybook.Story, :component

  alias DaisyUIComponents.Button
  alias DaisyUIComponents.Input
  alias DaisyUIComponents.Label
  alias DaisyUIComponents.Sheet

  def function, do: &Sheet.sheet/1

  def imports,
    do: [
      {Button, [button: 1]},
      {Input, [input: 1]},
      {Label, [label: 1]},
      {Sheet,
       [
         sheet_trigger: 1,
         sheet_content: 1,
         sheet_header: 1,
         sheet_title: 1,
         sheet_description: 1,
         sheet_footer: 1,
         sheet_close: 1
       ]}
    ]

  def variations do
    [
      %Variation{
        id: :edit_profile_bottom,
        slots: [
          """
          <.sheet_trigger target="sheet-bottom">
            <.button variant="outline">Edit Profile (Bottom)</.button>
          </.sheet_trigger>
          <.sheet_content id="sheet-bottom" side="bottom">
            <.sheet_header>
              <.sheet_title>Edit profile</.sheet_title>
              <.sheet_description>
                Make changes to your profile here. Click save when you're done.
              </.sheet_description>
            </.sheet_header>
            <div class="grid gap-4 py-4">
              <div class="grid grid-cols-4 items-center gap-4">
                <.label for="name" class="text-right">
                  Name
                </.label>
                <.input id="name" name="name" value="pedro duarte" class="col-span-3" />
              </div>
              <div class="grid grid-cols-4 items-center gap-4">
                <.label for="username" class="text-right">
                  Username
                </.label>
                <.input id="username" name="username" value="@peduarte" class="col-span-3" />
              </div>
            </div>
            <.sheet_footer>
              <.sheet_close target="sheet-bottom">
                <.button type="submit" phx-click="save">Save changes</.button>
              </.sheet_close>
            </.sheet_footer>
          </.sheet_content>
          """
        ]
      },
      %Variation{
        id: :navigation_left,
        slots: [
          """
          <.sheet_trigger target="sheet-left">
            <.button variant="outline">Navigation (Left)</.button>
          </.sheet_trigger>
          <.sheet_content id="sheet-left" side="left">
            <.sheet_header>
              <.sheet_title>Navigation Menu</.sheet_title>
              <.sheet_description>
                Navigate through the application sections.
              </.sheet_description>
            </.sheet_header>
            <div class="py-4">
              <nav class="space-y-2">
                                 <a href="#" class="block px-4 py-2 text-sm hover:bg-base-200 rounded">Home</a>
                 <a href="#" class="block px-4 py-2 text-sm hover:bg-base-200 rounded">Products</a>
                 <a href="#" class="block px-4 py-2 text-sm hover:bg-base-200 rounded">About</a>
                 <a href="#" class="block px-4 py-2 text-sm hover:bg-base-200 rounded">Contact</a>
              </nav>
            </div>
          </.sheet_content>
          """
        ]
      },
      %Variation{
        id: :settings_right,
        slots: [
          """
          <.sheet_trigger target="sheet-right">
            <.button variant="outline">Settings (Right)</.button>
          </.sheet_trigger>
          <.sheet_content id="sheet-right" side="right">
            <.sheet_header>
              <.sheet_title>Settings</.sheet_title>
              <.sheet_description>
                Configure your application preferences.
              </.sheet_description>
            </.sheet_header>
            <div class="py-4 space-y-4">
              <div class="flex items-center justify-between">
                <label class="text-sm font-medium">Dark Mode</label>
                <input type="checkbox" class="toggle toggle-sm" />
              </div>
              <div class="flex items-center justify-between">
                <label class="text-sm font-medium">Notifications</label>
                <input type="checkbox" class="toggle toggle-sm" checked />
              </div>
              <div class="flex items-center justify-between">
                <label class="text-sm font-medium">Auto-save</label>
                <input type="checkbox" class="toggle toggle-sm" />
              </div>
            </div>
            <.sheet_footer>
              <.sheet_close target="sheet-right">
                <.button variant="outline">Cancel</.button>
              </.sheet_close>
              <.sheet_close target="sheet-right">
                <.button>Save Settings</.button>
              </.sheet_close>
            </.sheet_footer>
          </.sheet_content>
          """
        ]
      },
      %Variation{
        id: :notifications_top,
        slots: [
          """
          <.sheet_trigger target="sheet-top">
            <.button variant="outline">Notifications (Top)</.button>
          </.sheet_trigger>
          <.sheet_content id="sheet-top" side="top">
            <.sheet_header>
              <.sheet_title>Recent Notifications</.sheet_title>
              <.sheet_description>
                Stay updated with your latest notifications.
              </.sheet_description>
            </.sheet_header>
            <div class="py-4">
                             <div class="space-y-3">
                 <div class="p-3 bg-base-200 rounded-lg">
                   <p class="text-sm font-medium">New message received</p>
                   <p class="text-xs text-base-content/70">2 minutes ago</p>
                 </div>
                 <div class="p-3 bg-base-200 rounded-lg">
                   <p class="text-sm font-medium">Profile updated successfully</p>
                   <p class="text-xs text-base-content/70">1 hour ago</p>
                 </div>
                 <div class="p-3 bg-base-200 rounded-lg">
                   <p class="text-sm font-medium">New follower</p>
                   <p class="text-xs text-base-content/70">3 hours ago</p>
                 </div>
               </div>
            </div>
            <.sheet_footer>
              <.sheet_close target="sheet-top">
                <.button variant="outline">Mark all as read</.button>
              </.sheet_close>
            </.sheet_footer>
          </.sheet_content>
          """
        ]
      }
    ]
  end
end
