defmodule PhoenixNotesAppWeb.LoginHTML do
  use PhoenixNotesAppWeb, :html

  def login(assigns) do
    ~H"""
    <div class="flex flex-row items-center h-screen w-full">
      <section class="flex flex-row justify-between h-full max-h-[60vh] w-full max-w-xs md:max-w-3xl lg:max-w-4xl mx-auto border-1 border-gray-200 shadow-lg rounded-md">
        <div class="hidden md:block relative h-full w-full max-w-sm">
          <img
            src="https://images.unsplash.com/photo-1612367980327-7454a7276aa7?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
            alt="notebook and desk"
            class="w-full h-full object-cover brightness-60 rounded-tl-md rounded-bl-md grayscale-50"
          />
          <div class="absolute flex flex-col inset-0 h-full w-full bg-orange-300 mix-blend-multiply">
          </div>

          <div class="absolute flex flex-col inset-0 h-full w-full">
            <h2 class="mx-auto mt-5 text-3xl text-white text-show-sm">Notes App</h2>
          </div>
        </div>

        <div class="relative flex flex-col h-full w-full py-5 md:p-5 bg-white z-100">
          <section class="flex flex-row justify-center items-center z-40">
            <h1 class="mt-5 md:mt-0 text-3xl font-bold text-gray-700 text-shadow-sm">Sign up</h1>
          </section>

          <.form
            for={@form}
            action={~p"/login"}
            method="post"
            class="flex flex-col mt-10 px-10 z-50"
          >
            <section class="flex flex-col w-full">
              <.input
                field={@form[:email]}
                type="email"
                label="Email"
                placeholder="Email"
                class="p-2 w-full bg-white text-gray-600 border border-gray-300
                focus:outline-2 focus:outline-orange-500 rounded-sm"
                autocomplete="off"
              />
            </section>

            <section class="flex flex-col w-full">
              <.input
                field={@form[:password]}
                type="password"
                label="Password"
                placeholder="Password"
                class="p-2 w-full bg-white text-gray-600 border border-gray-300
                focus:outline-2 focus:outline-orange-500 rounded-sm"
                autocomplete="off"
              />
            </section>

            <button
              type="submit"
              class="mt-5 py-2 px-10 bg-orange-500 text-xl text-white
              shadow-sm font-semibold rounded-sm cursor-pointer
              transition duration-300 hover:bg-orange-700 hover:scale-105"
            >
              Login
            </button>
          </.form>

          <section class="absolute top-30 left-0 md:inset-0 h-auto md:h-full w-full">
            <img
              src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
              alt="orange"
              class="h-full w-full object-fit md:object-cover opacity-20 blur-md"
            />
          </section>
        </div>
      </section>
    </div>
    """
  end
end
