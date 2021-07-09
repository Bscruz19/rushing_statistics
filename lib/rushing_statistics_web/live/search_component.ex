defmodule RushingStatisticsWeb.SearchComponent do
  use Phoenix.LiveComponent

  alias RushingStatisticsWeb.LayoutView

  @search_topic "search:search"

  @impl true
  def render(assigns), do: Phoenix.View.render(LayoutView, "search_component.html", assigns)

  @impl true
  def handle_event("search", %{"query" => ""}, socket) do
    message = {:search, %{query: "", rushing_statistics: RushingStatistics.all()}}

    Phoenix.PubSub.broadcast(RushingStatistics.PubSub, @search_topic, message)

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    message = query |> filter_rushing_statistics_by() |> build_message(query)

    Phoenix.PubSub.broadcast(RushingStatistics.PubSub, @search_topic, message)

    {:noreply, socket}
  end

  defp filter_rushing_statistics_by(query),
    do: RushingStatistics.filter_by(RushingStatistics.all(), query)

  defp build_message([_ | _] = rushing_statistics, query),
    do: {:search, %{query: query, rushing_statistics: rushing_statistics}}

  defp build_message(_rushing_statistics, query),
    do: {:error, %{message: "No players found matching \"#{query}\"", query: query}}
end
