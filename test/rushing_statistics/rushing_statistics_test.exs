defmodule RushingStatisticsTest do
  use ExUnit.Case, async: true

  describe "all/0" do
    test "get all rushing statistics" do
      assert [
               %{
                 "Player" => "Joe Banyard",
                 "1st" => 0,
                 "1st%" => 0,
                 "20+" => 0,
                 "40+" => 0,
                 "Att" => 2,
                 "Att/G" => 2,
                 "Avg" => 3.5,
                 "FUM" => 0,
                 "Lng" => "7",
                 "Pos" => "RB",
                 "TD" => 0,
                 "Team" => "JAX",
                 "Yds" => 7,
                 "Yds/G" => 7
               },
               %{
                 "Player" => "Shaun Hill",
                 "1st" => 0,
                 "1st%" => 0,
                 "20+" => 0,
                 "40+" => 0,
                 "Att" => 5,
                 "Att/G" => 1.7,
                 "Avg" => 1,
                 "FUM" => 0,
                 "Lng" => "9",
                 "Pos" => "QB",
                 "TD" => 0,
                 "Team" => "MIN",
                 "Yds" => 5,
                 "Yds/G" => 1.7
               }
             ] = RushingStatistics.all()
    end
  end

  describe "filter_by/2" do
    test "returns rushing statistics filtered by Player, Pos or Team" do
      rushing_statistics = RushingStatistics.all()

      assert [
               %{"Player" => "Joe Banyard", "Pos" => "RB"},
               %{"Player" => "Shaun Hill", "Pos" => "QB"}
             ] = rushing_statistics

      assert [%{"Player" => "Joe Banyard"}] =
               RushingStatistics.filter_by(rushing_statistics, "Joe Banyard")

      assert [%{"Player" => "Shaun Hill"}] = RushingStatistics.filter_by(rushing_statistics, "QB")

      assert [%{"Player" => "Shaun Hill"}] =
               RushingStatistics.filter_by(rushing_statistics, "MIN")
    end

    test """
    when the filter matches a part of the player name, position or team,
    returns filtered rushing statistics
    """ do
      rushing_statistics = RushingStatistics.all()

      assert [
               %{"Player" => "Joe Banyard", "Pos" => "RB"},
               %{"Player" => "Shaun Hill", "Pos" => "QB"}
             ] = rushing_statistics

      assert [%{"Player" => "Joe Banyard"}] =
               RushingStatistics.filter_by(rushing_statistics, "Joe")

      assert [
               %{"Player" => "Joe Banyard", "Pos" => "RB"},
               %{"Player" => "Shaun Hill", "Pos" => "QB"}
             ] = RushingStatistics.filter_by(rushing_statistics, "B")
    end

    test "when the filter does not match the player name, position or team, returns an empty list" do
      rushing_statistics = RushingStatistics.all()

      assert [
               %{"Player" => "Joe Banyard", "Pos" => "RB"},
               %{"Player" => "Shaun Hill", "Pos" => "QB"}
             ] = rushing_statistics

      assert [] = RushingStatistics.filter_by(rushing_statistics, "xpto")
    end
  end

  describe "get_translated_attributes/0" do
    test "returns a tuple list with the rushing_statistics attributes and its completed names " do
      [
        {"Player", "Player"},
        {"Team", "Team"},
        {"Pos", "Position"},
        {"Att/G", "Rushing Attempts Per Game Average"},
        {"Att", "Rushing Attempts"},
        {"Yds", "Total Rushing Yards"},
        {"Avg", "Rushing Average Yards Per Attempt"},
        {"Yds/G", "Rushing Yards Per Game"},
        {"TD", "Total Rushing Touchdowns"},
        {"Lng", "Longest Rush"},
        {"1st", "Rushing First Downs"},
        {"1st%", "Rushing First Down Percentage"},
        {"20+", "Rushing 20+ Yards Each"},
        {"40+", "Rushing 40+ Yards Each"},
        {"FUM", "Rushing Fumbles"}
      ] = RushingStatistics.get_translated_attributes()
    end
  end
end
