defmodule WeatherApp.Weather do
  @api_url "http://api.openweathermap.org/data/2.5/weather"
  @api_key "" # Hardcoded API key not recommended for production

  @doc """
    Fetches weather data for the provided city.

    ## Parameters
      - `city` (String): The city name.

    ## Returns
      - Weather data as a map on success.
      - An error map on failure.

    ## Examples
        iex> get_weather("Nairobi")
        %{"main" => %{"temp" => 15.0}, ...}

        iex> get_weather("InvalidCity")
        %{error: "API error", status: 404, message: "city not found"}

        iex> get_weather(nil)
        %{error: "Failed to fetch weather data", details: :invalid_url}

  """
  def get_weather(city) do
    url = "#{@api_url}?q=#{URI.encode(city)}&appid=#{@api_key}&units=metric"

    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        Jason.decode!(body)

      {:ok, %{status_code: status, body: body}} when status >= 400 ->
        %{error: "API error", status: status, message: parse_error(body)}

      {:error, %{reason: reason}} ->
        %{error: "Failed to fetch weather data", details: reason}
    end
  end

  defp parse_error(body) do
    case Jason.decode(body) do
      {:ok, %{"message" => message}} -> message
      _ -> "Unknown error"
    end
  end
end
