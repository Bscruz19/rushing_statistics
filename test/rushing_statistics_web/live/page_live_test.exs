defmodule RushingStatisticsWeb.PageLiveTest do
  use RushingStatisticsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    cols = RushingStatistics.get_translated_attributes()
    rushing_statistics = RushingStatistics.all()

    assert {:ok, page_live, disconnected_html} = live(conn, "/")

    page_live = render(page_live)

    Enum.each(rushing_statistics, fn rushing_statistic ->
      Enum.each(cols, fn {attr, title} ->
        assert page_live =~ to_string(title)
        assert page_live =~ to_string(rushing_statistic[attr])
        assert disconnected_html =~ to_string(title)
        assert disconnected_html =~ to_string(rushing_statistic[attr])
      end)
    end)
  end

  describe "handle_info/2" do
    test """
         when the search topic receives a succesful message,
         re renders the page with filtered rushing statistics
         """,
         %{conn: conn} do
      [rushing_statistic, rushing_statistic2] = RushingStatistics.all()
      message = {:search, %{query: "Joe", rushing_statistics: [rushing_statistic]}}

      assert {:ok, page_live, _html} = live(conn, "/")

      page_html = render(page_live)

      assert page_html =~ rushing_statistic["Player"]
      assert page_html =~ rushing_statistic2["Player"]

      assert :ok = Phoenix.PubSub.broadcast(RushingStatistics.PubSub, "search:search", message)

      page_html = render(page_live)

      assert page_html =~ rushing_statistic["Player"]
      refute page_html =~ rushing_statistic2["Player"]
    end

    test """
         when the sort by topic receives a message,
         re renders the page with the sorted rushing_statistics
         """,
         %{conn: conn} do
      [rushing_statistic, rushing_statistic2] = RushingStatistics.all()
      message = {:sort_by, %{rushing_statistics: [rushing_statistic2, rushing_statistic]}}

      assert {:ok, page_live, _html} = live(conn, "/")

      page_html = render(page_live)
      {index1, _length} = :binary.match(page_html, rushing_statistic["Player"])
      {index2, _length} = :binary.match(page_html, rushing_statistic2["Player"])

      assert index1 < index2
      assert :ok = Phoenix.PubSub.broadcast(RushingStatistics.PubSub, "search:search", message)

      page_html = render(page_live)
      {index1, _length} = :binary.match(page_html, rushing_statistic["Player"])
      {index2, _length} = :binary.match(page_html, rushing_statistic2["Player"])

      refute index1 < index2
    end

    test """
         when a topic receives an error message,
         re renders the page with a flash message error
         """,
         %{conn: conn} do
      query = "Father of Family"
      error_message = "No players found matching \"#{query}\""
      message = {:error, %{message: error_message, query: query}}

      assert {:ok, page_live, _html} = live(conn, "/")
      assert :ok = Phoenix.PubSub.broadcast(RushingStatistics.PubSub, "search:search", message)
      assert render(page_live) =~ "No players found matching"
    end
  end
end
