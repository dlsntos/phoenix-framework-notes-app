defmodule PhoenixNotesAppWeb.NoteDashboardLive.CreateNoteComponent do
  use PhoenixNotesAppWeb, :live_component
  alias PhoenixNotesApp.Notes
    @moduledoc """
      This is a live_component for creating a new note.
      It is used for creating a new note in real time
      without going to a separate page
    """

    @doc """
    this event handler is used for creating a new note
    """
    @impl true
    def handle_event("save_note", %{"note" => note_params}, socket) do
      note_params = Map.put(note_params, "user_id", socket.assigns.user_id)

      case Notes.create_note(note_params) do
        {:ok, note} ->
          PhoenixNotesAppWeb.Endpoint.broadcast("notes:#{socket.assigns.user_id}", "note_created", %{note: note})
          send(self(), {:note_created, note})

          {:noreply,
          socket
          |> assign(:note_params, %{})
          |> push_event("close_modal", %{})}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end

    @impl true
    def render(assigns) do
    ~H"""
    <div class="fixed top-0 left-0 h-screen w-full bg-black/50 z-50 flex justify-center items-center">
      <div class="relative h-full max-h-[80vh] w-full max-w-sm md:max-w-lg bg-white p-4 rounded-md">
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

        <!-- This section contains the label "Create a new note" -->
        <section>
          <h1 class="text-2xl text-center p-2">Create a new note</h1>
        </section>

        <!-- This section contains the forms for inputting note title and content -->
        <section class="h-auto">
          <form phx-submit="save_note" phx-target={@myself}>
            <div class="flex flex-row justify-between items-center gap-2">
              <label for="title" class="text-2xl">Title</label>
              <input
                type="text"
                name="note[title]"
                class="border-1 border-orange-400 w-full px-2 py-1 rounded-md focus:outline-1 focus:outline-orange-600"
                autocomplete="off"
              />
            </div>

            <div class="flex flex-col mt-3 h-full">
              <label for="content" class="text-xl">Content</label>
              <textarea
                name="note[content]"
                class="h-[55vh] p-3 border-1 border-orange-400 rounded-md focus:outline-1 focus:outline-orange-600 resize-none"
                autocomplete="off"
              ></textarea>
            </div>

            <section class="flex flex-row w-full mt-6">
              <button type="submit" class="py-2 px-4 ml-auto bg-[var(--bg-lightorange)] text-gray-100 font-semibold rounded-3xl cursor-pointer transition duration-300 hover:bg-orange-700 hover:scale-110">
                <span class="drop-shadow-md">Add note</span>
              </button>
            </section>
          </form>
        </section>
      </div>
    </div>
    """
    end
end
