defmodule PhoenixNotesAppWeb.NoteDashboardLive do
  use PhoenixNotesAppWeb, :live_view

  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Notes

  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: PhoenixNotesAppWeb.Endpoint.subscribe("notes:#{user_id}")
    users = Users.get_user(user_id)
    notes = Notes.get_all_notes_by_userid(user_id)
    {:ok,
    assign(socket,
      user_id: user_id,
      user: users,
      notes: notes,
      show_modal: false,
      show_create_note: false
    )}
  end

  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: "/login")}
  end

  def handle_info(%{event: "note_created", payload: %{note: note}}, socket) do
    {:noreply, update(socket, :notes, fn notes -> [note | notes] end)}
  end

  def handle_info(%{event: "note_updated", payload: %{note: note}}, socket) do
    updated_notes =
      Enum.map(socket.assigns.notes, fn existing_note ->
        if existing_note.id == note.id, do: note, else: existing_note
      end)

    socket =
      if socket.assigns[:selected_note] && socket.assigns.selected_note.id == note.id do
        assign(socket, selected_note: note)
      else
        socket
      end

    {:noreply, assign(socket, notes: updated_notes)}
  end

  @doc """
    The event handlers consists of 5 events which is the
      1.open-model - event for opening the view note modal
      2.close-modal - event for closing the view note modal
      3.open-create-note-modal - event for opening the create note modal
      4.close-create-note-modal - event for closing the create note modal
      5.delete-note - event for deleting a note
  """
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

  def handle_event("delete-note", %{"id" => id}, socket) do
    note_id = String.to_integer(id)
    case Notes.delete_note(note_id) do
      {:ok, _note} ->
        PhoenixNotesAppWeb.Endpoint.broadcast("notes:#{socket.assigns.user_id}", "note_deleted", %{id: id})

        updated_notes = Enum.reject(socket.assigns.notes, fn note -> note.id == note_id end)
        {:noreply, assign(socket, notes: updated_notes, show_modal: false, selected_note: nil)}

      {:error, _reason} ->
        {:noreply, socket}
    end
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

      <h1 class="ml-4 text-black text-2xl delius-unicase-bold">Note<span class="text-orange-500">Orange</span></h1>
    </div>

    <div class="flex flex-row justify-end w-full">
      <input
        type="text"
        placeholder="Search notes"
        class="mr-4 border border-slate-300 py-2 px-4 w-1/3 rounded-full transition focus:outline-orange-500"
      />
      <form action={~p"/logout"} method="post" class="inline">
        <input type="hidden" name="_method" value="delete" />
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />
        <button
          class="bg-[var(--bg-lightorange)] text-white px-4 py-2 rounded-full cursor-pointer transition duration-200 hover:bg-orange-700"
          type="submit"
        >
          Logout
        </button>
      </form>
    </div>
  </header>

  <main class="relative bg-white-1 min-h-screen pt-16 px-8 md:pl-8 md:pr-0 z-0">
    <section class="mt-6 flex items-center">
      <h2 class="mx-auto py-5 text-5xl font-semibold font-[var(--font-delius-unicase)] drop-shadow-sm">
        <span class="text-orange-500"><%= @user.username %>'s</span> Notes
      </h2>
    </section>

    <section class="mt-10 grid grid-cols-1 sm:grid-cols-[repeat(2,minmax(0,250px))] md:grid-cols-[repeat(3,minmax(0,300px))] lg:grid-cols-[repeat(4,minmax(0,350px))] justify-center items-center auto-rows-[15rem] gap-5">
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

          <section class="relative h-full max-h-[120px] py-5 text-center overflow-hidden">
            <p class="h-full max-h-[100px] w-full max-w-md md:max-w-xs text-lg text-justify text-gray-500 font-[var(--font-comme)] px-5 drop-shadow-sm break-words overflow-hidden">
              {note.content}
            </p>

            <div class="pointer-events-none absolute bottom-0 left-0 w-full h-10 bg-gradient-to-t from-white/100 to-white/0">
            </div>
          </section>

          <section class="flex justify-end p-3 rounded-b-xl z-40">
            <div class="h-10 w-10 py-2 bg-[var(--bg-lightorange)] rounded-full cursor-pointer transition duration-200 hover:bg-orange-700 hover:scale-110 cursor-pointer">
              <.icon name="hero-pencil-square" class="ml-2 mb-1 size-6 text-[var(--text-white-1)]"/>
            </div>
          </section>
        </div>
      <% end %>
    </section>

    <section class="absolute flex flex-row justify-end bottom-20 left-0 w-full p-5">
      <button
        class="flex flex-row justify-center items-center bg-[var(--bg-lightorange)] text-white p-5 mr-0 md:mr-30 h-20 w-20 rounded-full cursor-pointer transition duration-300 hover:bg-orange-700 hover:scale-110"
        phx-click="open-create-note-modal"
      >
        <.icon name="hero-plus" class="size-10"/>
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
      user_id={@user_id}
    />
  <% end %>
  """
  end

  defmodule CreateNoteComponent do
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

        <section>
          <h1 class="text-2xl text-center p-2">Create a new note</h1>
        </section>

        <section class="h-auto">
          <form phx-submit="save_note" phx-target={@myself}>
            <div class="flex flex-row justify-between items-center gap-2">
              <label for="title" class="text-2xl">Title</label>
              <input
                type="text"
                name="note[title]"
                class="border-1 border-orange-400 w-full px-2 py-1 rounded-md focus:outline-1 focus:outline-orange-600"
              />
            </div>

            <div class="flex flex-col mt-3 h-full">
              <label for="content" class="text-xl">Content</label>
              <textarea
                name="note[content]"
                class="h-[55vh] p-3 border-1 border-orange-400 rounded-md focus:outline-1 focus:outline-orange-600 resize-none"
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


  defmodule ViewNoteComponent do
  use PhoenixNotesAppWeb, :live_component
  alias PhoenixNotesApp.Notes
  @moduledoc """
    This is a live_component for viewing a note. It is used to display, update, and delete notes in real time.
    without going to a separate page.
  """

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

  def handle_event("enable-edit", _, socket) do
    {:noreply,
     assign(socket,
       edit_mode: true,
       form: to_form(Notes.change_note(socket.assigns.note))
     )}
  end

  def handle_event("cancel-edit", _, socket) do
    {:noreply,
     assign(socket,
       edit_mode: false,
       form: to_form(Notes.change_note(socket.assigns.note))
     )}
  end

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
  def render(assigns) do
    ~H"""
    <div class="fixed top-0 left-0 flex flex-row justify-center items-center h-screen w-full bg-black/70 z-10000 overflow-y-hidden">
      <section class="h-full max-h-[80vh] w-full max-w-sm md:max-w-3xl rounded-3xl bg-white drop-shadow-2xl">
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
              <%= if @edit_mode do %>
                Editing note
              <% else %>
                {@note.title}
              <% end %>
            </h1>
          </div>

          <div class="flex flex-row justify-between px-5 py-2">
            <p class="text-sm md:text-lg text-white text-shadow-sm">Created at <%= @note.inserted_at%></p>

            <p class="text-sm md:text-lg text-white text-shadow-sm">Last updated at <%= @note.updated_at%></p>
          </div>
        </div>

        <%= if @edit_mode do %>
          <div class="h-[55vh] p-0 md:p-5">
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
              class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-auto bg-gray-200 text-xs md:text-base text-gray-700 rounded-lg md:rounded-3xl cursor-pointer hover:bg-gray-300 hover:scale-105 transition duration-200"
            >
              <span class="font-semibold drop-shadow-md">Cancel</span>
            </button>
            <button
              type="submit"
              form={"edit-note-form-#{@note.id}"}
              class="flex flex-row justify-center items-center px-2 md:px-8 py-3 gap-2 w-auto bg-[var(--bg-lightorange)] text-xs md:text-base text-[var(--text-white-1)] rounded-lg md:rounded-3xl cursor-pointer hover:bg-orange-800 hover:scale-105 transition duration-200"
            >
              <span class="font-semibold drop-shadow-md">Save</span>
            </button>
          </div>
        <% else %>
          <div class="h-[55vh] p-0 md:p-5">
            <textarea
              name="note"
              id="note"
              placeholder="Add a note"
              class="w-full h-full outline-none text-base md:text-xl text-justify resize-none px-10"
              readonly
            >{@note.content}</textarea>
          </div>

          <div class="flex justify-center md:justify-end items-center px-15 space-x-5">
            <button
              phx-click="delete-note"
              phx-value-id={@note.id}
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
        <% end %>
      </section>
    </div>

    """
    end
  end
end
