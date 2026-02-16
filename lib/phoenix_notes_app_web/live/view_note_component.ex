defmodule PhoenixNotesAppWeb.NoteDashboardLive.ViewNoteComponent do
  use PhoenixNotesAppWeb, :live_component
  import PhoenixNotesAppWeb.Helpers.LiveViewHelper
  alias PhoenixNotesApp.Notes
  @moduledoc """
  ViewNoteComponent

  ## Purpose
  Modal UI for viewing, editing, and deleting a note.

  ## Assigns
  - `:note` - note being viewed or edited.
  - `:user_id` - authenticated user id for PubSub topic.

  ## Events
  - `"enable-edit"` - enter edit mode.
  - `"cancel-edit"` - exit edit mode without saving.
  - `"save-note"` - update note and broadcast `"note_updated"`.
  - `"delete-note"` - delete note and broadcast `"note_deleted"`.
  - `"close-view_note-modal"` - close the modal.
  """

  @impl true
  def update(%{note: note} = assigns, socket) do
    socket = assign(socket, assigns)
    edit_mode = Map.get(socket.assigns, :edit_mode, false)

    form =
      if edit_mode do
        socket.assigns[:form] || to_form(Notes.change_note(note))
      else
        to_form(Notes.change_note(note))
      end

    {:ok, assign(socket, edit_mode: edit_mode, form: form)}
  end

  @impl true
  def handle_event("enable-edit", _, socket) do
    {:noreply,
     assign(socket,
       edit_mode: true,
       form: to_form(Notes.change_note(socket.assigns.note))
     )}
  end

  @impl true
  def handle_event("cancel-edit", _, socket) do
    {:noreply,
     assign(socket,
       edit_mode: false,
       form: to_form(Notes.change_note(socket.assigns.note))
     )}
  end

  @impl true
  def handle_event("save-note", %{"note" => note_params}, socket) do
    case Notes.update_note(socket.assigns.note, note_params) do
      {:ok, note} ->
        PhoenixNotesAppWeb.Endpoint.broadcast("notes:#{note.user_id}", "note_updated", %{note: note})

        {:noreply,
         assign(socket,
           edit_mode: false,
           note: note,
           form: to_form(Notes.change_note(note))
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("delete-note", %{"id" => id}, socket) do
    note_id = String.to_integer(id)

    case Notes.delete_note(note_id) do
      {:ok, _note} ->
        PhoenixNotesAppWeb.Endpoint.broadcast(
          "notes:#{socket.assigns.user_id}",
          "note_deleted",
          %{id: id}
        )

        {:noreply,
        socket
        |> assign(show_modal: false, selected_note: nil)
        |> notify_parent(__MODULE__, :note_deleted)}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("close-view_note-modal", _, socket) do
    {:noreply, notify_parent(socket, __MODULE__,:close_modal)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed top-0 left-0 flex flex-row justify-center items-center h-screen w-full bg-black/70 z-10000 overflow-y-hidden">
      <section class="h-full max-h-[80vh] w-full max-w-sm md:max-w-3xl rounded-3xl bg-white drop-shadow-2xl">
        <div class="flex flex-col h-auto w-full p-2 bg-[var(--bg-lightorange)] rounded-t-3xl drop-shadow-sm">
          <div
            class="flex flex-row self-end items-center h-10 w-10 bg-red-500 rounded-full cursor-pointer transition duration-200 hover:bg-red-700 hover:scale-110"
            phx-click="close-view_note-modal"
            phx-target={@myself}
          >
            <.icon name="hero-x-mark" class="text-white size-6 mx-auto"/>
          </div>

          <div class="text-center">
            <h1 class="text-2xl md:text-4xl text-white font-bold text-gray-800 text-shadow-sm">
              <%= if @edit_mode do %>
                Editing note
              <% else %>
                {@note.title}
              <% end %>
            </h1>
          </div>

          <div class="flex flex-row justify-between px-5 py-2">
            <p class="text-xs md:text-lg text-white text-left text-shadow-sm">Created at {@note.inserted_at |> NaiveDateTime.to_date() |> Date.to_string()}</p>

            <p class="text-xs md:text-lg text-white text-right text-shadow-sm">Last updated at {@note.updated_at |> NaiveDateTime.to_date()|> Date.to_string() }</p>
          </div>
        </div>

        <%= if @edit_mode do %>
          <.edit_note
            note={@note}
            form={@form}
            myself={@myself}
          />
        <% else %>
          <.view_note_content
            note={@note}
            myself={@myself}
          />
        <% end %>
      </section>
    </div>
    """
  end

  defp edit_note(assigns) do
    ~H"""
      <div class="h-[55vh] p-0 px-5 md:p-5">
        <.form
          for={@form}
          id={"edit-note-form-#{@note.id}"}
          phx-submit="save-note"
          phx-target={@myself}
          class="h-full"
        >
          <div class="flex flex-col gap-3 h-full">

            <div class="flex flex-row items-center h-auto w-full gap-2">
              <p class="text-base md:text-xl font-semibold">Title</p>
              <.input
                field={@form[:title]}
                type="text"
                label=""
                class="w-full max-w-lg p-2 text-base md:text-xl border-1 border-orange-500 outline-orange-500 rounded-sm"
              />
            </div>

            <div>
              <p class="text-base md:text-xl font-semibold">Content</p>
              <.input
                field={@form[:content]}
                type="textarea"
                label=""
                class="h-full min-h-[30vh] w-full p-2 text-base md:text-xl border-1 border-orange-500 outline-orange-500 resize-none rounded-sm"
              />
            </div>

          </div>
        </.form>
      </div>

      <div class="flex justify-center md:justify-end items-center px-15 space-x-5">
        <button
          type="button"
          phx-click="cancel-edit"
          phx-target={@myself}
          class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-full bg-gray-200 text-xs md:text-base text-gray-700 rounded-lg md:rounded-3xl cursor-pointer hover:bg-gray-300 hover:scale-105 transition duration-200"
        >
          <span class="font-semibold drop-shadow-md">Cancel</span>
        </button>

        <button
          type="submit"
          form={"edit-note-form-#{@note.id}"}
          class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-full bg-[var(--bg-lightorange)] text-xs md:text-base text-[var(--text-white-1)] rounded-lg md:rounded-3xl cursor-pointer hover:bg-orange-800 hover:scale-105 transition duration-200"
        >
          <span class="font-semibold drop-shadow-md">Save</span>
        </button>
      </div>
    """
  end

  defp view_note_content(assigns) do
    ~H"""
      <div class="h-[55vh] p-0 md:p-5">
        <textarea
          name="note"
          id="note"
          placeholder="Add a note"
          class="w-full h-full outline-none py-5 text-base md:text-xl text-justify resize-none px-10"
          readonly
        >{@note.content}</textarea>
      </div>

      <div class="flex justify-center md:justify-end items-center px-15 space-x-5">
        <button
          phx-click="delete-note"
          phx-value-id={@note.id}
          phx-target={@myself}
          class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-auto bg-red-600 text-xs md:text-base text-[var(--text-white-1)] rounded-lg md:rounded-3xl cursor-pointer hover:bg-red-800 hover:scale-105 transition duration-200">
          <.icon name="hero-trash" class="size-6"/><span class="font-semibold drop-shadow-md">Delete Note</span>
        </button>

        <button
          phx-click="enable-edit"
          phx-target={@myself}
          class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-auto bg-[var(--bg-lightorange)] text-xs md:text-base text-[var(--text-white-1)] rounded-lg md:rounded-3xl cursor-pointer hover:bg-orange-800 hover:scale-105 transition duration-200">
          <.icon name="hero-pencil-square" class="size-6"/> <span class="font-semibold drop-shadow-md">Edit Note</span>
        </button>
      </div>
    """
  end
end
