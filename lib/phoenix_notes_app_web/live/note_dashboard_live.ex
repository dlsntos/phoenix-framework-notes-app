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

  def handle_event("open-modal", %{"id" => id}, socket) do
    note = Notes.get_note_by_id(id)
    {:noreply, assign(socket, show_modal: true, selected_note: note)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, show_modal: false, selected_note: nil)}
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
        <span class="text-orange-500"><%= @user_id.name %></span> Notes
      </h2>
    </section>

    <section class="mt-10 grid grid-cols-[repeat(4,minmax(0,350px))] justify-center items-center auto-rows-[15rem] gap-5">
      <%= for note <- @notes do %>
        <div
          class="flex flex-col h-full max-h-[250px] bg-white rounded-xl drop-shadow-md cursor-pointer transition duration-300 hover:scale-105"
          phx-click="open-modal"
          phx-value-id={note.id}
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
      module={PhoenixNotesAppWeb.NoteDashboardLive.ViewNoteComponent}
      id="view-note-modal"
      note={@selected_note}
    />
  <% end %>

  <%= if @show_create_note do %>
    <.live_component
      module={PhoenixNotesAppWeb.NoteDashboardLive.CreateNoteComponent}
      id="show-create-note-modal"
    />
  <% end %>
  """
  end

  defmodule CreateNoteComponent do
  use PhoenixNotesAppWeb, :live_component
    def render(assigns) do
    ~H"""
    <div class="fixed top-0 left-0 h-screen w-full bg-black/50 z-50 flex justify-center items-center">
      <div class="relative h-full max-h-[80vh] w-full max-w-lg bg-white p-4 rounded-md">
        <section class="absolute flex flex-row justify-between items-center top-0 left-0 p-2 w-full">
          <div class="h-12 w-12 object-cover hover:scale-110 transition duration-300 cursor-pointer">
            <img
              src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
              alt="orange.png"
            />
          </div>

          <button
            class="flex flex-row items-center h-7 w-7 bg-red-500 text-white rounded-full drop-shadow-sm cursor-pointer transition duration-300 hover:bg-red-700 hover:scale-110"
            phx-click="close-create-note-modal"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 20 20"
              fill="currentColor"
              class="size-5 mx-auto"
            >
              <path d="M6.28 5.22a.75.75 0 0 0-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 1 0 1.06 1.06L10 11.06l3.72 3.72a.75.75 0 1 0 1.06-1.06L11.06 10l3.72-3.72a.75.75 0 0 0-1.06-1.06L10 8.94 6.28 5.22Z" />
            </svg>
          </button>
        </section>

        <section>
          <h1 class="text-2xl text-center p-2">Create a new note</h1>
        </section>

        <section class="h-auto">
          <form action="">
            <div class="flex flex-row justify-between items-center gap-2">
              <label for="" class="text-2xl">Title</label>
              <input
                type="text"
                class="border-1 border-orange-400 w-full px-2 py-1 rounded-md focus:outline-1 focus:outline-orange-600"
              />
            </div>

            <div class="flex flex-col mt-3 h-full">
              <label for="" class="text-xl">Content</label> <textarea
                name=""
                id=""
                class="h-[55vh] p-3 border-1 border-orange-400 rounded-md focus:outline-1 focus:outline-orange-600 resize-none"
              ></textarea>
            </div>
          </form>
        </section>

        <section class="flex flex-row w-full mt-6">
          <button class="py-2 px-4 ml-auto bg-[var(--bg-lightorange)] text-gray-100 font-semibold rounded-3xl cursor-pointer transition duration-300 hover:bg-orange-700 hover:scale-110">
            <span class="drop-shadow-md">Add note</span>
          </button>
        </section>
      </div>
    </div>
    """
    end
  end

  defmodule ViewNoteComponent do
  use PhoenixNotesAppWeb, :live_component

  def render(assigns) do
  ~H"""
  <div class="fixed top-0 left-0 flex flex-row justify-center items-center h-screen w-full bg-black/70 z-10000 overflow-y-hidden">
    <section class="h-full max-h-[80vh] w-full max-w-3xl rounded-3xl bg-white drop-shadow-2xl">
      <div class="flex flex-col h-auto w-full p-2 bg-[var(--bg-lightorange)] rounded-t-3xl drop-shadow-sm">
        <div
          class="flex flex-row self-end items-center h-10 w-10 bg-red-500 rounded-full cursor-pointer transition duration-200 hover:bg-red-700 hover:scale-110"
          phx-click="close-modal"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6 mx-auto"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
          </svg>
        </div>

        <div class="text-center">
          <h1 class="text-4xl text-white font-bold text-gray-800 text-shadow-sm">
            <%= @note.title%>
          </h1>
        </div>

        <div class="flex flex-row justify-between px-5 py-2">
          <p class="text-lg text-white text-shadow-sm">Created at <%= @note.inserted_at%></p>

          <p class="text-lg text-white text-shadow-sm">Last updated at <%= @note.updated_at%></p>
        </div>
      </div>
      <!-- Text area readonly attribute to false if user decideds to edit a note-->
      <div class="h-[55vh] p-5">
        <textarea
          name="note"
          id="note"
          placeholder="Add a note"
          class="w-full h-full outline-none text-xl text-justify resize-none px-10"
          readonly
        >
        <%= @note.content%>
        </textarea>
      </div>

      <div class="flex justify-end items-center px-15 space-x-5">
        <button class="flex flex-row justify-center items-center px-8 py-3 gap-2 w-auto bg-red-600 text-[var(--text-white-1)] rounded-3xl cursor-pointer hover:bg-red-800 hover:scale-105 transition duration-200">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m14.74 9-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 0 1-2.244 2.077H8.084a2.25 2.25 0 0 1-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 0 0-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 0 1 3.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 0 0-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 0 0-7.5 0"
            />
          </svg> <span class="font-semibold drop-shadow-md">Delete Note</span>
        </button>
        <button class="flex flex-row justify-center items-center px-8 py-3 gap-2 w-auto bg-[var(--bg-lightorange)] text-[var(--text-white-1)] rounded-3xl cursor-pointer hover:bg-orange-800 hover:scale-105 transition duration-200">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="m16.862 4.487 1.687-1.688a1.875 1.875 0 1 1 2.652 2.652L10.582 16.07a4.5 4.5 0 0 1-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 0 1 1.13-1.897l8.932-8.931Zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0 1 15.75 21H5.25A2.25 2.25 0 0 1 3 18.75V8.25A2.25 2.25 0 0 1 5.25 6H10"
            />
          </svg> <span class="font-semibold drop-shadow-md">Edit Note</span>
        </button>
      </div>
    </section>
  </div>

  """
  end
  end
end
