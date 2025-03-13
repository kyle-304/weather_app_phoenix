defmodule WeatherAppWeb.WeatherLive do
  use WeatherAppWeb, :live_view
  alias WeatherApp.Weather

  def mount(_params, _session, socket) do
    {:ok, assign(socket, weather: %{}, city: nil, loading: false)}
  end

  def handle_event("get_weather", %{"city" => city}, socket) do
    socket = assign(socket, loading: true, city: city)
    weather = Weather.get_weather(city)

    IO.inspect(weather, label: "🌍 Weather Data")  # Debugging API response

    {:noreply, assign(socket, weather: ensure_valid_weather(weather), loading: false)}
  end

  defp ensure_valid_weather(%{"weather" => _} = data), do: data
  defp ensure_valid_weather(_), do: %{"weather" => [%{"description" => "No weather data available"}]}
end
