defmodule PhoenixNotesAppWeb.NoteDashboardLive.CreateNoteComponent do
  use PhoenixNotesAppWeb, :live_component
  import PhoenixNotesAppWeb.Helpers.LiveViewHelper
  alias PhoenixNotesApp.Notes
    @moduledoc """
    CreateNoteComponent

    ## Purpose
    Modal UI for creating a new note.

    ## Assigns
    - `:user_id` - authenticated user id used for note ownership.

    ## Events
    - `"close-create-note-modal"` - closes the modal.
    - `"save_note"` - creates the note and broadcasts `"note_created"`.
    """

    @impl true
    def handle_event("close-create-note-modal", _, socket) do
      {:noreply, notify_parent(socket, __MODULE__, :close_create_note_modal)}
    end

    @impl true
    def handle_event("save_note", %{"note" => note_params}, socket) do
      note_params = Map.put(note_params, "user_id", socket.assigns.user_id)

      case Notes.create_note(note_params) do
        {:ok, note} ->
          PhoenixNotesAppWeb.Endpoint.broadcast("notes:#{socket.assigns.user_id}", "note_created", %{note: note})

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
      <!-- This section is the main container -->
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
            phx-target={@myself}
          >
            <.icon name="hero-x-mark" class="ml-1 size-5"/>
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
