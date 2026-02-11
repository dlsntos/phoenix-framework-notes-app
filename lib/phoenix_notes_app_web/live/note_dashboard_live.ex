defmodule PhoenixNotesAppWeb.NoteDashboardLive do
  use PhoenixNotesAppWeb, :live_view

  alias PhoenixNotesApp.Users
  alias PhoenixNotesApp.Notes

  @moduledoc """
  NoteDashboardLive LiveView

  ## Purpose
  This page provides a Visual Interface for users to create, view, search,
  edit, and delete their notes.

  ## State
  - `:user_id` - gets the user_id.
  - `":user"` - gets a single user.
  - `":search_query"` - represents what the user searches.
  - `":search_form"` -
  - `":show_modal"` - boolean value to show the modal.
  - `":show_create_note"` - boolean value to show the create-note modal.

  ## Mount
  - Auth mount fetches the data if the user_id is correct
  - otherwise it will proceed to the fall back mount that will redirect the user to the login page

  ## Info (handle_info/2)


  ## Events
  - `"open-modal"` - opens view_note modal.
  - `"close-modal"` - closes view_note modal.
  - `"open-create-note-modal"` - opens create-note-modal.
  - `"close-create-note-modal"` - closes create-note modal.
  - `"search"` - searches for the note using the query given by the user.
  - `"delete"` - deletes a note.
  """


  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: PhoenixNotesAppWeb.Endpoint.subscribe("notes:#{user_id}")
    users = Users.get_user(user_id)
    notes = Notes.get_all_notes_by_userid(user_id)
    search_query = ""
    search_form = to_form(%{"query" => search_query}, as: :search)

    {:ok,
    assign(socket,
      user_id: user_id,
      user: users,
      notes: notes,
      search_query: search_query,
      search_form: search_form,
      show_modal: false,
      show_create_note: false
    )}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, redirect(socket, to: "/login")}
  end

  @impl true
  def handle_info(%{event: "note_created", payload: %{note: _note}}, socket) do
    {:noreply,
      socket
    |> assign(show_create_note: false)
    |> refresh_notes()}
  end

  @impl true
  def handle_info(%{event: "note_updated", payload: %{note: note}}, socket) do
    socket =
      if socket.assigns[:selected_note] && socket.assigns.selected_note.id == note.id do
        assign(socket, selected_note: note)
      else
        socket
      end

    {:noreply, refresh_notes(socket)}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{event: "note_deleted", payload: %{id: _id}}, socket) do
    {:noreply,
    socket
    |> assign(show_modal: false, selected_note: nil)
    |> refresh_notes()}
  end

  @impl true
  def handle_event("open-modal", %{"id" => id}, socket) do
    note = Notes.get_note_by_id(id)
    {:noreply, assign(socket, show_modal: true, selected_note: note)}
  end

  @impl true
  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, show_modal: false, selected_note: nil)}
  end

  @impl true
  def handle_event("open-create-note-modal", _, socket) do
    {:noreply, assign(socket, show_create_note: true)}
  end

  @impl true
  def handle_event("close-create-note-modal", _, socket) do
    {:noreply, assign(socket, show_create_note: false)}
  end

  @impl true

  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    query = query |> to_string() |> String.trim()

    notes =
      if query == "" do
        Notes.get_all_notes_by_userid(socket.assigns.user_id)
      else
        Notes.search_notes_by_title(socket.assigns.user_id, query)
      end

    {:noreply,
      assign(socket,
        notes: notes,
        search_query: query,
        search_form: to_form(%{"query" => query}, as: :search)
      )}
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
        |> refresh_notes()}

      {:error, _reason} ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
  ~H"""
  <Layouts.app flash={@flash} current_scope={@current_scope}>
    <header class="fixed top-0 left-0 flex flex-row justify-between items-center bg-cream h-16 w-full p-4 shadow-lg z-30">
      <div class="flex flex-row items-center">
        <div class="h-12 w-12 object-cover hover:scale-110 transition duration-300 cursor-pointer">
          <img
            src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
            alt="orange.png"
          />
        </div>

        <h1 class="hidden md:block ml-4 text-black text-2xl delius-unicase-bold transition duration-300 hover:scale-105">Note<span class="text-orange-500">Orange</span></h1>
      </div>

      <div class="flex flex-row justify-end items-center w-full">
        <!-- This form container contains the search bar input for searching notes -->
        <.form
          for={@search_form}
          id="note-search-form"
          phx-change="search"
          autocomplete="off"
          class="w-full sm:w-auto mr-4"
        >
          <.input
            field={@search_form[:query]}
            type="text"
            placeholder="Search notes"
            phx-debounce="300"
            class="mt-2  w-full sm:w-auto mr-4 border border-slate-300 py-2 px-4 w-1/3 rounded-full transition focus:outline-orange-500"
          />

        </.form>
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
      <!-- Username Label -->
      <section class="mt-6 flex items-center">
        <h2 class="mx-auto py-5 text-5xl font-semibold font-[var(--font-delius-unicase)] drop-shadow-sm">
          <span class="text-orange-500">{@user.username |> String.capitalize()}'s</span> Notes
        </h2>
      </section>

      <!-- Grid container that contains the notes list -->
      <section class="mt-10 grid grid-cols-1 sm:grid-cols-[repeat(2,minmax(0,250px))] md:grid-cols-[repeat(3,minmax(0,300px))] lg:grid-cols-[repeat(4,minmax(0,350px))] justify-center items-center auto-rows-[15rem] gap-5">
        <%= for note <- @notes do %>
          <.note_item_component
            id={"note-item-#{note.id}"}
            note={note}
          />
        <% end %>
      </section>

      <!-- absolute container that contains the create/add note button -->
      <section class="absolute flex flex-row justify-end bottom-20 left-0 w-full p-5">
        <button
          class="flex flex-row justify-center items-center bg-[var(--bg-lightorange)] text-white p-5 mr-0 md:mr-30 h-20 w-20 rounded-full cursor-pointer transition duration-300 hover:bg-orange-700 hover:scale-110"
          phx-click="open-create-note-modal"
        >
          <.icon name="hero-plus" class="size-10"/>
        </button>
      </section>
    </main>

    <!--Conditional logic for rendering view note modal-->
    <%= if @show_modal do %>
      <.live_component
        module={PhoenixNotesAppWeb.NoteDashboardLive.ViewNoteComponent}
        id="view-note-modal"
        note={@selected_note}
      />
    <% end %>

    <!--Conditional logic for rendering create note modal-->
    <%= if @show_create_note do %>
      <.live_component
        module={PhoenixNotesAppWeb.NoteDashboardLive.CreateNoteComponent}
        id="show-create-note-modal"
        user_id={@user_id}
      />
    <% end %>
  </Layouts.app>
  """
  end

  @doc false
  defp note_item_component(assigns) do
  ~H"""
    <div
      class="flex flex-col h-full max-h-[250px] bg-white rounded-xl drop-shadow-md transition duration-300 hover:scale-105"
    >
      <!--Note title section-->
      <section class="flex bg-[var(--bg-lightorange)] p-3 text-[var(--text-white-1)] rounded-t-2xl">
      <h2 class="mx-auto text-xl font-semibold font-[var(--font-montserrat)] drop-shadow-md">
        {@note.title}
      </h2>
      </section>

      <!--Note content section-->
      <section class="relative h-full max-h-[120px] py-5 text-center overflow-hidden">
        <p class="h-full max-h-[100px] w-full max-w-md md:max-w-xs text-lg text-justify text-gray-500 font-[var(--font-comme)] px-5 drop-shadow-sm break-words overflow-hidden">
          {@note.content}
        </p>
        <div class="pointer-events-none absolute bottom-0 left-0 w-full h-10 bg-gradient-to-t from-white/100 to-white/0"></div>
      </section>

      <!--Open note button section-->
      <section class="flex justify-end p-3 rounded-b-xl z-40">
        <div
          phx-click="open-modal"
          phx-value-id={@note.id}
          class="h-10 w-10 py-2 bg-[var(--bg-lightorange)] rounded-full cursor-pointer transition duration-200 hover:bg-orange-700 hover:scale-110 cursor-pointer">
          <.icon name="hero-arrows-pointing-out" class="ml-2 mb-1 size-6 text-[var(--text-white-1)]"/>
        </div>
      </section>
    </div>
  """
  end

  @doc false
  defp refresh_notes(socket) do
    query = socket.assigns.search_query || ""

    notes =
      if query == "" do
        Notes.get_all_notes_by_userid(socket.assigns.user_id)
      else
        Notes.search_notes_by_title(socket.assigns.user_id, query)
      end

    assign(socket, notes: notes)
  end
end
