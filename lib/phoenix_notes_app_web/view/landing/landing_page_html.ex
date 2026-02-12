defmodule PhoenixNotesAppWeb.NoteHTML do
  use PhoenixNotesAppWeb, :html
  def index(assigns) do
    ~H"""
    <header class="fixed flex flex-row justify-between items-center px-5 py-3 w-full bg-[var(--text-white-1)] drop-shadow-md z-10000">
      <.header_logo/>
      <.desktop_navigation />
      <.mobile_menu_button />
      <.mobile_navigation />
    </header>

    <main class="h-full">
      <section class="relative flex flex-row justify-center lg:justify-evenly h-full w-full gap-5">
        <img
          src="https://images.unsplash.com/photo-1542435503-956c469947f6?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
          class="absolute w-full h-full object-cover brightness-30"
        />
        <div class="flex flex-col justify-start items-center lg:items-start max-w-sm md:max-w-screen my-auto p-10 pb-40 ml-0 lg:ml-60 z-100 gap-5">
          <h1 class="text-4xl md:text-6xl text-[var(--text-white-1)] montserrat-bold font-bold drop-shadow-sm">
            Note<span class="text-orange-500">Orange</span>
          </h1>

          <p class="w-sm md:w-lg text-base md:text-lg text-[var(--text-white-1)] text-center md:text-start font-semibold drop-shadow-sm">
            Stay organized, capture ideas, and boost productivity with Note Orange
          </p>

          <p class="w-xs md:w-lg text-sm text-[var(--text-white-1)] text-justify montserrat-normal md:text-left drop-shadow-sm">
            The ultimate app for all your thoughts, lists, and inspirations. Jot notes, create checklists, and write your thoughts. With powerful search, folders, and cloud sync, your notes are always accessible on any device—perfect for staying organized effortlessly.
          </p>

          <button
            onclick="location.href='/register'"
            class="p-3 w-full bg-[var(--bg-lightorange)] text-[var(--text-white-1)] font-bold rounded-xl text-shadow-md shadow-md cursor-pointer transition duration-300
                  hover:bg-orange-600
            "
          >
            Start note taking now
          </button>
        </div>

        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 700 600"
          class="hidden xl:block z-60"
        >
          <defs>
            <pattern id="imgpattern" patternUnits="userSpaceOnUse" width="600" height="600">
              <image
                href="https://framerusercontent.com/images/Dp3F2zdheP1cKEBI6wjfu6mE380.jpg?width=1920&height=1080"
                x="0"
                y="0"
                width="600"
                height="600"
              />
            </pattern>
          </defs>

          <path
            d="M382.06808188073785 432.7225081358911C316.23038707686413 439.00522806590413 129.18848898523004 366.230352425035 105.62827780358941 315.70679158315676C82.06806662194879 265.1832307412786 174.86911998702038 135.86386301463435 240.7068147908941 129.58114308462132C306.5445095947678 123.29842315460832 477.094235445191 227.48691116120045 500.6544466268316 278.01047200307863C524.2146578084722 328.5340328449569 447.90577668461157 426.43978820587813 382.06808188073785 432.7225081358911C316.23038707686413 439.00522806590413 129.18848898523004 366.230352425035 105.62827780358941 315.70679158315676"
            fill="url(#imgpattern)"
            stroke-width="3"
            stroke="hsl(32, 77%, 43%)"
          />
        </svg>
      </section>
    </main>

    <footer class="h-auto relative">
      <section class="flex flex-col justify-between items-center px-10 mx-auto">
        <!-- Company Logo -->
        <div class="flex flex-col items-center">
          <div class="flex flex-row items-center">
            <div class="h-25 w-25 object-cover">
            <img
              src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
              alt="orange.png"
              />
            </div>

            <div class="ml-2 text-3xl md:text-5xl font-bold delius-unicase-bold">
              Note<span class="text-orange-500">Orange</span>
            </div>
          </div>
          <p class="w-auto text-base md:text-lg text-center md:text-start font-semibold">
              Stay organized, capture ideas, and boost productivity with Note Orange
          </p>
        </div>
        <!-- Footer Column Container-->
        <div class="flex flex-row md:justify-around justify-center w-full max-w-3xl my-10 ml-13 md:ml-20 gap-10 md:gap-0">
            <!-- About Column -->
          <div>
            <h3 class="mb-3 text-orange-600 font-bold">
              About
            </h3>
            <ul>
              <li>
                <.link navigate="/">About us</.link>
              </li>
              <li>
                <.link navigate="/">Guides</.link>
              </li>
            </ul>
          </div>

          <!-- Support Column -->
          <div>
            <h3 class="mb-3 text-orange-600 font-bold">
              Support
            </h3>
            <ul>
              <li>
                <.link navigate="/">Help Center</.link>
              </li>

              <li>
                <.link navigate="/">Contact</.link>
              </li>
            </ul>
          </div>

          <!-- Legal Column -->
          <div>
            <h3 class="mb-3 text-orange-600 font-bold">
              Legal
            </h3>
            <ul>
              <li>
                <.link navigate="/">Terms & Conditions</.link>
              </li>
              <li>
                <.link navigate="/">Privacy Policy</.link>
              </li>
            </ul>
          </div>
        </div>

      </section>
      <section class="flex flex-row p-2">
        <p class="mx-auto font-medium">©2026 NoteOrange. All rights reserved.</p>
      </section>
    </footer>
    """
  end

  #Header content components
  defp header_logo(assigns) do
  ~H"""
  <div class="flex flex-row items-center">
    <div class="h-12 w-12 object-cover hover:scale-110 transition duration-300 cursor-pointer">
      <img
      src="https://img.icons8.com/?size=100&id=hfNCM7e9VGca&format=png&color=000000"
      alt="orange.png"
      />
    </div>

    <div class="ml-2 text-xl font-bold delius-unicase-bold">
      Note<span class="text-orange-500">Orange</span>
    </div>
  </div>
  """
  end

  defp mobile_menu_button(assigns) do
    ~H"""
    <button
        id="hamburger-btn"
        phx-click={ JS.add_class("hidden", to: "#hamburger-btn")
                    |> JS.remove_class("hidden", to: "#mobile-menu")}
        class="md:hidden rounded-md cursor-pointer transition duration-200 hover:bg-gray-300"
      >
        <.icon name="hero-bars-3" class="size-10"/>
      </button>
    """
  end

  defp desktop_navigation(assigns) do
    ~H"""
    <nav>
        <ul class="hidden md:flex flex-row gap-2">
          <li>
            <.link
              navigate="/"
              class="py-2 px-3 text-orange-600 font-medium cursor-pointer rounded-md transition duration-200 hover:bg-orange-500 hover:text-[var(--text-white-1)]"
            >
              Home
            </.link>
          </li>

          <li>
            <.link
              navigate="/"
              class="py-2 px-3 text-orange-600 font-medium cursor-pointer rounded-md transition duration-200 hover:bg-orange-500 hover:text-[var(--text-white-1)]"
            >
              About
            </.link>
          </li>

          <li>
            <.link
              navigate="/login"
              class="py-2 px-10 bg-orange-500 text-white font-medium cursor-pointer rounded-full transition duration-200 hover:bg-orange-700 hover:text-[var(--text-white-1)]">
                Login
            </.link>
          </li>

          <li>
            <.link
              navigate="/register"
              class="py-2 px-10 bg-white text-orange-500 font-medium border-1 border-orange-500 cursor-pointer rounded-full transition duration-200 hover:bg-orange-500 hover:text-[var(--text-white-1)]">
                Register
            </.link>
          </li>
        </ul>
      </nav>
    """
  end

  defp mobile_navigation(assigns) do
    ~H"""
    <nav
        id="mobile-menu"
        class="absolute top-10 right-0 mr-2 hidden md:hidden h-auto min-w-[30vw] bg-white md:bg-transparent px-4 py-4 rounded-md"
      >
        <ul class="md:hidden h-full w-full">
          <li class="flex flex-row justify-end w-full">
            <button
              phx-click={ JS.add_class("hidden", to: "#mobile-menu")
                          |> JS.remove_class("hidden", to: "#hamburger-btn")}
              class="px-2 py-1 rounded-full cursor-pointer"
            >
              <.icon name="hero-x-mark"/>
            </button>
          </li>

          <.link
            navigate="/"
            class="block p-2 text-orange-500 font-medium rounded-md transtition duration-300 hover:bg-orange-500 hover:text-white"
            >
              Home
          </.link>

          <.link
            navigate="/about"
            class="block p-2 text-orange-500 font-medium rounded-md transtition duration-300 hover:bg-orange-500 hover:text-white"
            >
              About
          </.link>

          <.link
            navigate="/login"
            class="block p-2 text-orange-500 font-medium rounded-md transtition duration-300 hover:bg-orange-500 hover:text-white"
          >
            Login
          </.link>

          <.link
            navigate="/register"
            class="block p-2 text-orange-500 font-medium rounded-md transtition duration-300 hover:bg-orange-500 hover:text-white"
          >
            Register
          </.link>
        </ul>
      </nav>
    """
  end

end
