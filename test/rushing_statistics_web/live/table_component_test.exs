defmodule RushingStatisticsWeb.TableComponentTest do
  use RushingStatisticsWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias RushingStatisticsWeb.TableComponent

  describe "render/1" do
    test "renders table component" do
      cols = RushingStatistics.get_translated_attributes()
      rushing_statistics = RushingStatistics.all()

      template =
        render_component(TableComponent,
          query: "",
          columns: cols,
          rushing_statistics: rushing_statistics,
          id: :table
        )

      Enum.each(rushing_statistics, fn rushing_statistic ->
        Enum.each(cols, fn {attr, title} ->
          assert template =~ title
          assert template =~ to_string(rushing_statistic[attr])
        end)
      end)
    end
  end

  describe "handle_event/3" do
    test "sends a message in the sort_by topic with rushing statistics sorted by an attribute" do
      assert [
               %{"Player" => "Joe Banyard", "Pos" => "RB"},
               %{"Player" => "Shaun Hill", "Pos" => "QB"}
             ] = rushing_statistics = RushingStatistics.all()

      socket = %{assigns: %{rushing_statistics: rushing_statistics}}

      assert :ok = Phoenix.PubSub.subscribe(RushingStatistics.PubSub, "table:sort_by")

      assert {:noreply, ^socket} = TableComponent.handle_event("Pos", %{}, socket)

      assert_receive {:sort_by,
                      %{
                        rushing_statistics: [
                          %{"Player" => "Shaun Hill", "Pos" => "QB"},
                          %{"Player" => "Joe Banyard", "Pos" => "RB"}
                        ]
                      }}
    end
  end
end
