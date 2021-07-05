defmodule RushingStatisticsWeb.TableComponent do
  use Phoenix.LiveComponent

  alias RushingStatisticsWeb.LayoutView

  @sort_by_topic "table:sort_by"

  @impl true
  def render(assigns), do: Phoenix.View.render(LayoutView, "table_component.html", assigns)

  @impl true
  def handle_event(sort_by, _params, socket) do
    rushing_statistics = Enum.sort_by(socket.assigns.rushing_statistics, & &1[sort_by])
    message = {:sort_by, %{rushing_statistics: rushing_statistics}}

    Phoenix.PubSub.broadcast(RushingStatistics.PubSub, @sort_by_topic, message)

    {:noreply, socket}
  end
end
