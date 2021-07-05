defmodule RushingStatistics do
  @moduledoc "This module is responsible for handling Rushing Statistics logic."

  @filter_attributes ~w(Player Team Pos)

  @doc "This function is responsible for get all rushing_statistics."
  @spec all() :: list()
  def all do
    file_path = Application.get_env(:rushing_statistics, :file_path)

    file_path
    |> File.read!()
    |> Jason.decode!()
  end

  @doc """
    This function is responsible for filtering a rushing statistic list by player name, team or position.
    It's possible to filter with partial values.

    ## Examples
    iex> filter_by(rushing_statistics, "Joe Banyard")
    [%{"Player" => "Joe Banyard"}]

    iex> filter_by(rushing_statistics, "JAX")
    [%{"Player" => "Joe Banyard"}, %{"Player" => "Denard Robinson"}]

    iex> filter_by(rushing_statistics, "RB")
    [%{"Player" => "Joe Banyard"}, %{"Player" => "Denard Robinson"}]

    iex> filter_by(rushing_statistics, "Jailson")
    [%{"Player" => "Jailson Fernandez"}, %{"Player" => "Jailson Mendes"}]

    iex> filter_by(rushing_statistics, "xpto")
    []
  """
  @spec filter_by(list(), binary()) :: list()
  def filter_by(rushing_statistics, attr) do
    filter = format_attribute(attr)

    Enum.filter(rushing_statistics, fn statistic ->
      @filter_attributes
      |> Enum.map(&Map.get(statistic, &1))
      |> Enum.any?(&(format_attribute(&1) =~ filter))
    end)
  end

  @doc """
  This function is responsible for returning a tuple list with the rushings statistics attributes
  and its completed names
  """
  @spec get_translated_attributes() :: list(tuple())
  def get_translated_attributes do
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
    ]
  end

  defp format_attribute(attribute) do
    attribute
    |> to_string()
    |> String.downcase()
  end
end
