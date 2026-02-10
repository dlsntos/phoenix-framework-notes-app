defmodule PhoenixNotesAppWeb.NoteDashboardLive.NoteItemComponent do
  use PhoenixNotesAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <div
        class="flex flex-col h-full max-h-[250px] bg-white rounded-xl drop-shadow-md transition duration-300 hover:scale-105"
      >
        <section class="flex bg-[var(--bg-lightorange)] p-3 text-[var(--text-white-1)] rounded-t-2xl">
          <h2 class="mx-auto text-xl font-semibold font-[var(--font-montserrat)] drop-shadow-md">
            {@note.title}
          </h2>
        </section>

        <section class="relative h-full max-h-[120px] py-5 text-center overflow-hidden">
          <p class="h-full max-h-[100px] w-full max-w-md md:max-w-xs text-lg text-justify text-gray-500 font-[var(--font-comme)] px-5 drop-shadow-sm break-words overflow-hidden">
            {@note.content}
          </p>
          <div class="pointer-events-none absolute bottom-0 left-0 w-full h-10 bg-gradient-to-t from-white/100 to-white/0"></div>
        </section>

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

end
