defmodule RushingStatisticsWeb.PageLive do
  use RushingStatisticsWeb, :live_view

  @event_topics ["search:search", "table:sort_by"]

  @impl true
  def mount(_params, _session, socket) do
    subscribe_topics()

    {
      :ok,
      assign(socket, query: "", columns: cols(), rushing_statistics: RushingStatistics.all())
    }
  end

  @impl true
  def handle_params(%{"download" => _rushing_statistics}, _uri, socket) do
    {:noreply, assign(socket, rushing_statistics: RushingStatistics.all())}
  end

  def handle_params(_params, _uri, socket),
    do: {:noreply, assign(socket, rushing_statistics: RushingStatistics.all())}

  @impl true
  def handle_info({:search, %{query: query, rushing_statistics: rushing_statistics}}, socket) do
    {:noreply, assign(socket, query: query, rushing_statistics: rushing_statistics)}
  end

  def handle_info({:sort_by, %{rushing_statistics: rushing_statistics}}, socket) do
    {:noreply, assign(socket, rushing_statistics: rushing_statistics)}
  end

  def handle_info({:error, %{message: message_error, query: query}}, socket) do
    socket = socket |> put_flash(:error, message_error) |> assign(query: query)

    {:noreply, socket}
  end

  defp subscribe_topics,
    do: Enum.each(@event_topics, &Phoenix.PubSub.subscribe(RushingStatistics.PubSub, &1))

  defp cols, do: RushingStatistics.get_translated_attributes()
end
