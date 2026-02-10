defmodule PhoenixNotesAppWeb.RegisterHTML do
  use PhoenixNotesAppWeb, :html

  def register(assigns) do
    ~H"""
      <div class="flex flex-row justify-center items-center h-full w-full">
      <section class="relative px-5 pt-10 pb-20  h-auto w-full max-w-xs md:max-w-md bg-white border-1 border-gray-200 drop-shadow-md">
        <div class="flex flex-col items-center">
          <h1 class="text-3xl text-orange-600 font-semibold z-20">Create an account</h1>

          <p class="text-sm z-60">Sign up and to start note taking right away</p>
        </div>

        <.form
          for={@form}
          action={~p"/register"}
          method="post"
          class="flex flex-col mt-10"
        >
          <div class=" z-30">
            <label for="">Username</label>
            <.input
              field={@form[:username]}
              type="text"
              placeholder="Username"
              class="p-3 w-full bg-white text-gray-600 rounded-sm border-1 border-gray-400 focus:outline-2 focus:outline-orange-700"
            />
          </div>

          <div class=" z-30">
            <label for="">Email</label>
            <.input
              field={@form[:email]}
              type="email"
              placeholder="Email"
              class="p-3 w-full bg-white text-gray-600 rounded-sm border-1 border-gray-400 focus:outline-2 focus:outline-orange-700"
            />
          </div>

          <div class=" z-40">
            <label for="">Password</label>
            <.input
              field={@form[:hashed_password]}
              type="password"
              placeholder="Password"
              class="p-3 w-full bg-white text-gray-600 rounded-sm border-1 border-gray-400 focus:outline-2 focus:outline-orange-700"
            />
          </div>

          <div class="z-50">
            <button
              type="submit"
              class="p-3 mt-5 w-full bg-orange-500 text-white font-semibold rounded-sm transition duration-500 shadow-sm cursor-pointer hover:bg-orange-700 hover:scale-105"
            >
              Register
            </button>
            <p class="mt-5 text-center z-30">
              Already have an account? click
              <a href="/login" class="text-orange-700 font-medium underline">here</a>
              to login
            </p>
          </div>
        </.form>

        <div class="absolute top-30 md:top-0 left-0 h-auto md:h-full w-full p-10 z-10">
          <img
            src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
            alt="orange"
            class="h-full w-full object-fit md:object-cover opacity-30 blur-md"
          />
        </div>
      </section>
    </div>
    """
  end
end
