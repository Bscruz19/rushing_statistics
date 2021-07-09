defmodule RushingStatisticsWeb.SearchComponentTest do
  use RushingStatisticsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias RushingStatisticsWeb.SearchComponent

  describe "render/1" do
    test "renders search component" do
      template = render_component(SearchComponent, query: "", id: :search)

      assert template =~ "form"
      assert template =~ "phx-change=\"search\""
      assert template =~ "phx-submit=\"search\""
      assert template =~ "placeholder=\"Player, Team or Position\"\n"

      assert template =~
               "<button class=\"p-2\" type=\"submit\" phx-disable-with=\"Searching...\">Search</button>\n</form>\n"
    end
  end

  describe "handle_event/3" do
    test """
    when the query param is empty, sends a sucessful message in the search topic
    with all rushing statistics and the empty query
    """ do
      query = ""
      assert :ok = Phoenix.PubSub.subscribe(RushingStatistics.PubSub, "search:search")

      assert {:noreply, _socket} =
               SearchComponent.handle_event("search", %{"query" => query}, %{})

      assert_receive {:search,
                      %{
                        query: ^query,
                        rushing_statistics: [
                          %{"Player" => "Joe Banyard"},
                          %{"Player" => "Shaun Hill"}
                        ]
                      }}
    end

    test """
    when the query param is valid, sends a sucessful message in the search topic
    with filtered rushing statistics and the query used
    """ do
      query = "Joe"
      assert :ok = Phoenix.PubSub.subscribe(RushingStatistics.PubSub, "search:search")

      assert {:noreply, _socket} =
               SearchComponent.handle_event("search", %{"query" => query}, %{})

      assert_receive {:search,
                      %{query: ^query, rushing_statistics: [%{"Player" => "Joe Banyard"}]}}
    end

    test """
    when the query param is invalid, sends an error message in the search topic
    with feedback and the query used
    """ do
      query = "xpto"
      error_message = "No players found matching \"#{query}\""
      assert :ok = Phoenix.PubSub.subscribe(RushingStatistics.PubSub, "search:search")

      assert {:noreply, _socket} =
               SearchComponent.handle_event("search", %{"query" => query}, %{})

      assert_receive {:error, %{query: ^query, message: ^error_message}}
    end
  end
end
