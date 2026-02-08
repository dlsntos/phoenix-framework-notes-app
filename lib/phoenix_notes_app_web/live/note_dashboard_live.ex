defmodule PhoenixNotesAppWeb.NoteDashboardLive do
  use PhoenixNotesAppWeb, :live_view

  alias PhoenixNotesApp.Notes

  def mount(_params, %{"user_id" => user_id}, socket) do
    notes = Notes.get_all_notes_by_userid(user_id)
  {:ok,
   assign(socket,
     user_id: user_id,
     notes: notes,
     show_modal: false,
     show_create_note: false
   )}
end

  def handle_event("open-modal", _, socket) do
    {:noreply, assign(socket, show_modal: true)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, show_modal: false)}
  end

  def handle_event("open-create-note-modal", _, socket) do
    {:noreply, assign(socket, show_create_note: true)}
  end

  def handle_event("close-create-note-modal", _, socket) do
    {:noreply, assign(socket, show_create_note: false)}
  end

  def render(assigns) do
  ~H"""
  <header class="fixed top-0 left-0 flex flex-row justify-between items-center bg-cream h-16 w-full p-4 shadow-lg z-30">
    <div class="flex flex-row items-center">
      <div class="h-12 w-12 object-cover hover:scale-110 transition duration-300 cursor-pointer">
        <img
          src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
          alt="orange.png"
        />
      </div>

      <h1 class="ml-4 text-black text-2xl">Notes</h1>
    </div>

    <div class="flex flex-row justify-end w-full">
      <input
        type="text"
        placeholder="Search notes"
        class="mr-4 border border-slate-300 py-2 px-4 w-1/3 rounded-full transition focus:outline-orange-500"
      />
      <button class="bg-[var(--bg-lightorange)] text-white px-4 py-2 rounded-full cursor-pointer transition duration-200 hover:bg-orange-700">
        Logout
      </button>
    </div>
  </header>

  <main class="relative bg-white-1 min-h-screen pt-16 pl-8 z-0">
    <section class="mt-6 flex items-center">
      <h2 class="mx-auto py-5 text-5xl font-semibold font-[var(--font-delius-unicase)] drop-shadow-sm">
        <span class="text-orange-500"><%= @user_id %>User's </span>Notes
      </h2>
    </section>

    <section class="mt-10 grid grid-cols-[repeat(4,minmax(0,350px))] justify-center items-center auto-rows-[15rem] gap-5">
      <%= for note <- @notes do %>
        <div
          class="flex flex-col h-full max-h-[250px] bg-white rounded-xl drop-shadow-md cursor-pointer transition duration-300 hover:scale-105"
          phx-click="open-modal"
        >
          <section class="flex bg-[var(--bg-lightorange)] p-3 text-[var(--text-white-1)] rounded-t-2xl">
            <h2 class="mx-auto text-xl font-semibold font-[var(--font-montserrat)] drop-shadow-md">
              {note.title}
            </h2>
          </section>

          <section class="relative h-full max-h-[120px] py-5 text-center overflow-y-hidden">
            <p class="h-full max-h-[120px] text-lg text-gray-500 font-[var(--font-comme)] px-5 drop-shadow-sm">
              {note.content}
            </p>

            <div class="pointer-events-none absolute bottom-0 left-0 w-full h-10 bg-gradient-to-t from-white/100 to-white/0">
            </div>
          </section>

          <section class="flex justify-end p-3 rounded-b-xl z-40">
            <div class="h-10 w-10 py-2 bg-[var(--bg-lightorange)] rounded-full cursor-pointer transition duration-200 hover:bg-orange-700 hover:scale-110 cursor-pointer">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                viewBox="0 0 24 24"
                fill="currentColor"
                class="mx-auto size-6 text-[var(--text-white-1)]"
              >
                <path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-8.4 8.4a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32l8.4-8.4Z" />
                <path d="M5.25 5.25a3 3 0 0 0-3 3v10.5a3 3 0 0 0 3 3h10.5a3 3 0 0 0 3-3V13.5a.75.75 0 0 0-1.5 0v5.25a1.5 1.5 0 0 1-1.5 1.5H5.25a1.5 1.5 0 0 1-1.5-1.5V8.25a1.5 1.5 0 0 1 1.5-1.5h5.25a.75.75 0 0 0 0-1.5H5.25Z" />
              </svg>
            </div>
          </section>
        </div>
      <% end %>
    </section>

    <section class="absolute flex flex-row justify-end bottom-20 left-0 w-full p-5">
      <button
        class="flex flex-row justify-center items-center bg-[var(--bg-lightorange)] text-white p-5 mr-30 h-20 w-20 rounded-full cursor-pointer transition duration-300 hover:bg-orange-700 hover:scale-110"
        phx-click="open-create-note-modal"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="size-10"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
        </svg>
      </button>
    </section>
  </main>

  <%= if @show_modal do %>
    <.live_component
      module={PhoenixNotesAppWeb.ViewNoteComponent}
      id="view-note-modal"
    />
  <% end %>

  <%= if @show_create_note do %>
    <.live_component
      module={PhoenixNotesAppWeb.CreateNoteComponent}
      id="show-create-note-modal"
    />
  <% end %>
  """
  end
end
