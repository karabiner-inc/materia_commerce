defmodule MateriaCommerce.ProjectsTest do
  use MateriaCommerce.DataCase

  doctest MateriaCommerce.Projects
  alias MateriaCommerce.Projects

  describe "projects" do
    alias MateriaCommerce.Projects.Project

    @valid_attrs %{accuracy: "some accuracy", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", lock_version: 42, note1: "some note1", note2: "some note2", note3: "some note3", note4: "some note4", project_date1: "2010-04-17 14:00:00.000000Z", project_date2: "2010-04-17 14:00:00.000000Z", project_date3: "2010-04-17 14:00:00.000000Z", project_date4: "2010-04-17 14:00:00.000000Z", project_date5: "2010-04-17 14:00:00.000000Z", project_date6: "2010-04-17 14:00:00.000000Z", project_key1: "some project_key1", project_key2: "some project_key2", project_key3: "some project_key3", project_key4: "some project_key4", project_name: "some project_name", project_number: "some project_number", quantity1: 42, quantity2: 42, quantity3: 42, quantity4: 42, quantity5: 42, quantity6: 42, start_datetime: "2010-04-17 14:00:00.000000Z", status: 42, inserted_id: 1}
    @update_attrs %{accuracy: "some updated accuracy", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", lock_version: 43, note1: "some updated note1", note2: "some updated note2", note3: "some updated note3", note4: "some updated note4", project_date1: "2011-05-18 15:01:01.000000Z", project_date2: "2011-05-18 15:01:01.000000Z", project_date3: "2011-05-18 15:01:01.000000Z", project_date4: "2011-05-18 15:01:01.000000Z", project_date5: "2011-05-18 15:01:01.000000Z", project_date6: "2011-05-18 15:01:01.000000Z", project_key1: "some updated project_key1", project_key2: "some updated project_key2", project_key3: "some updated project_key3", project_key4: "some updated project_key4", project_name: "some updated project_name", project_number: "some updated project_number", quantity1: 43, quantity2: 43, quantity3: 43, quantity4: 43, quantity5: 43, quantity6: 43, start_datetime: "2011-05-18 15:01:01.000000Z", status: 43, inserted_id: 2}
    @invalid_attrs %{accuracy: nil, description: nil, end_datetime: nil, lock_version: nil, note1: nil, note2: nil, note3: nil, note4: nil, project_date1: nil, project_date2: nil, project_date3: nil, project_date4: nil, project_date5: nil, project_date6: nil, project_key1: nil, project_key2: nil, project_key3: nil, project_key4: nil, project_name: nil, project_number: nil, quantity1: nil, quantity2: nil, quantity3: nil, quantity4: nil, quantity5: nil, quantity6: nil, start_datetime: nil, status: nil, inserted_id: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects()
             |> Enum.filter(fn p -> p.id == project.id end)
             |> Enum.map(
                  fn x ->
                    x
                    |> Map.delete(:user)
                    |> Map.delete(:inserted)
                  end
                )
             |> List.first == project
                              |> Map.delete(:user)
                              |> Map.delete(:inserted)
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id)
             |> Map.delete(:inserted)
             |> Map.delete(:user) == project
                                     |> Map.delete(:inserted)
                                     |> Map.delete(:user)
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Projects.create_project(@valid_attrs)
      assert project.accuracy == "some accuracy"
      assert project.description == "some description"
      assert project.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.lock_version == 42
      assert project.note1 == "some note1"
      assert project.note2 == "some note2"
      assert project.note3 == "some note3"
      assert project.note4 == "some note4"
      assert project.project_date1 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_date2 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_date3 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_date4 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_date5 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_date6 == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.project_key1 == "some project_key1"
      assert project.project_key2 == "some project_key2"
      assert project.project_key3 == "some project_key3"
      assert project.project_key4 == "some project_key4"
      assert project.project_name == "some project_name"
      assert project.project_number == "some project_number"
      assert project.quantity1 == 42
      assert project.quantity2 == 42
      assert project.quantity3 == 42
      assert project.quantity4 == 42
      assert project.quantity5 == 42
      assert project.quantity6 == 42
      assert project.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project.status == 42
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Projects.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.accuracy == "some updated accuracy"
      assert project.description == "some updated description"
      assert project.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.lock_version == 43
      assert project.note1 == "some updated note1"
      assert project.note2 == "some updated note2"
      assert project.note3 == "some updated note3"
      assert project.note4 == "some updated note4"
      assert project.project_date1 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_date2 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_date3 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_date4 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_date5 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_date6 == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.project_key1 == "some updated project_key1"
      assert project.project_key2 == "some updated project_key2"
      assert project.project_key3 == "some updated project_key3"
      assert project.project_key4 == "some updated project_key4"
      assert project.project_name == "some updated project_name"
      assert project.project_number == "some updated project_number"
      assert project.quantity1 == 43
      assert project.quantity2 == 43
      assert project.quantity3 == 43
      assert project.quantity4 == 43
      assert project.quantity5 == 43
      assert project.quantity6 == 43
      assert project.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project.status == 43
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project
             |> Map.delete(:inserted)
             |> Map.delete(:user) == Projects.get_project!(project.id)
                                     |> Map.delete(:inserted)
                                     |> Map.delete(:user)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end

    test "get_current_project_history/2 " do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      result = MateriaCommerce.Projects.get_current_project_history(base_datetime, keywords)
      assert result.project_number == "PJ-01"
      assert result.status == 1
    end

    test "delete_future_project_histories/2 delete status2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      {result, _} = MateriaCommerce.Projects.delete_future_project_histories(base_datetime, keywords)
      lists = MateriaCommerce.Projects.list_projects()
      assert result == 1
      assert !Enum.any?(lists, fn(list)-> list.status == 2 end)
    end

    test "get_recent_project_history/2 no result" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result == nil
    end

    test "get_recent_project_history/2 boundary values" do
      keywords = [{:project_number, "PJ-01"}]

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 0

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 0

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")
      result = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
      assert result.status == 2
    end

    test "create_new_project_history/5 error parameters lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attr = %{
        "project_number" => "PJ-01",
        "status" => 4,
      }
      assert_raise(KeyError, fn -> MateriaCommerce.Projects.create_new_project_history(%{}, base_datetime, keywords, attr, 1) end)
    end

    test "create_new_project_history/5 error different lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attr = %{
        "project_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 99,
      }
      assert_raise(KeyError, fn -> MateriaCommerce.Projects.create_new_project_history(%{}, base_datetime, keywords, attr, 1) end)
    end

    test "create_new_project_history/5 create data all delete" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attr = %{
        "project_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 2,
      }
      {:ok, result} = MateriaCommerce.Projects.create_new_project_history(%{}, base_datetime, keywords, attr, 1)
      lists = MateriaCommerce.Projects.list_projects() |> Enum.filter(fn(x) -> x.project_number == "PJ-01" end)
      list = lists |> Enum.filter(fn(x) -> x.id == result.id end) |> Enum.at(0)
      assert list.id == result.id
      assert list.project_number == "PJ-01"
      assert list.status == 4
      assert list.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00.000000Z], "Etc/UTC")
      assert list.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59.000000Z], "Etc/UTC")
      assert Enum.count(lists) == 1
    end

    test "create_new_project_history/5 create latest history data" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attr = %{
        "project_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 2,
      }
      {:ok, result} = MateriaCommerce.Projects.create_new_project_history(%{}, base_datetime, keywords, attr, 1)
      lists = MateriaCommerce.Projects.list_projects() |> Enum.filter(fn(x) -> x.project_number == "PJ-01" end)
      list = lists |> Enum.filter(fn(x) -> x.id == result.id end) |> Enum.at(0)
      assert list.id == result.id
      assert list.project_number == "PJ-01"
      assert list.status == 4
      assert list.start_datetime == DateTime.from_naive!(~N[2019-01-02 09:00:00.000000Z], "Etc/UTC")
      assert list.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59.000000Z], "Etc/UTC")
    end
  end

  describe "project_appendices" do
    alias MateriaCommerce.Projects.ProjectAppendix

    @valid_attrs %{appendix_category: "some appendix_category", appendix_date: "2010-04-17 14:00:00.000000Z", appendix_description: "some appendix_description", appendix_name: "some appendix_name", appendix_number: "120.5", appendix_status: 42, end_datetime: "2010-04-17 14:00:00.000000Z", lock_version: 42, project_key1: "some project_key1", project_key2: "some project_key2", project_key3: "some project_key3", project_key4: "some project_key4", project_number: "some project_number", start_datetime: "2010-04-17 14:00:00.000000Z", inserted_id: 1}
    @update_attrs %{appendix_category: "some updated appendix_category", appendix_date: "2011-05-18 15:01:01.000000Z", appendix_description: "some updated appendix_description", appendix_name: "some updated appendix_name", appendix_number: "456.7", appendix_status: 43, end_datetime: "2011-05-18 15:01:01.000000Z", lock_version: 43, project_key1: "some updated project_key1", project_key2: "some updated project_key2", project_key3: "some updated project_key3", project_key4: "some updated project_key4", project_number: "some updated project_number", start_datetime: "2011-05-18 15:01:01.000000Z", inserted_id: 2}
    @invalid_attrs %{appendix_category: nil, appendix_date: nil, appendix_description: nil, appendix_name: nil, appendix_number: nil, appendix_status: nil, end_datetime: nil, lock_version: nil, project_key1: nil, project_key2: nil, project_key3: nil, project_key4: nil, project_number: nil, start_datetime: nil, inserted_id: nil}

    def project_appendix_fixture(attrs \\ %{}) do
      {:ok, project_appendix} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_project_appendix()

      project_appendix
    end

    test "list_project_appendices/0 returns all project_appendices" do
      project_appendix = project_appendix_fixture()
      assert Projects.list_project_appendices()
             |> Enum.filter(fn appendix -> appendix.id == project_appendix.id end)
             |> List.first()
             |> Map.delete(:inserted) == project_appendix
                                         |> Map.delete(:inserted)
    end

    test "get_project_appendix!/1 returns the project_appendix with given id" do
      project_appendix = project_appendix_fixture()
      assert Projects.get_project_appendix!(project_appendix.id)
             |> Map.delete(:inserted) == project_appendix
                                         |> Map.delete(:inserted)
    end

    test "create_project_appendix/1 with valid data creates a project_appendix" do
      assert {:ok, %ProjectAppendix{} = project_appendix} = Projects.create_project_appendix(@valid_attrs)
      assert project_appendix.appendix_category == "some appendix_category"
      assert project_appendix.appendix_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project_appendix.appendix_description == "some appendix_description"
      assert project_appendix.appendix_name == "some appendix_name"
      assert project_appendix.appendix_number == Decimal.new("120.5")
      assert project_appendix.appendix_status == 42
      assert project_appendix.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert project_appendix.lock_version == 42
      assert project_appendix.project_key1 == "some project_key1"
      assert project_appendix.project_key2 == "some project_key2"
      assert project_appendix.project_key3 == "some project_key3"
      assert project_appendix.project_key4 == "some project_key4"
      assert project_appendix.project_number == "some project_number"
      assert project_appendix.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_project_appendix/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project_appendix(@invalid_attrs)
    end

    test "update_project_appendix/2 with valid data updates the project_appendix" do
      project_appendix = project_appendix_fixture()
      assert {:ok, project_appendix} = Projects.update_project_appendix(project_appendix, @update_attrs)
      assert %ProjectAppendix{} = project_appendix
      assert project_appendix.appendix_category == "some updated appendix_category"
      assert project_appendix.appendix_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project_appendix.appendix_description == "some updated appendix_description"
      assert project_appendix.appendix_name == "some updated appendix_name"
      assert project_appendix.appendix_number == Decimal.new("456.7")
      assert project_appendix.appendix_status == 43
      assert project_appendix.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert project_appendix.lock_version == 43
      assert project_appendix.project_key1 == "some updated project_key1"
      assert project_appendix.project_key2 == "some updated project_key2"
      assert project_appendix.project_key3 == "some updated project_key3"
      assert project_appendix.project_key4 == "some updated project_key4"
      assert project_appendix.project_number == "some updated project_number"
      assert project_appendix.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_project_appendix/2 with invalid data returns error changeset" do
      project_appendix = project_appendix_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project_appendix(project_appendix, @invalid_attrs)
      assert project_appendix
             |> Map.delete(:inserted) == Projects.get_project_appendix!(project_appendix.id)
                                         |> Map.delete(:inserted)
    end

    test "delete_project_appendix/1 deletes the project_appendix" do
      project_appendix = project_appendix_fixture()
      assert {:ok, %ProjectAppendix{}} = Projects.delete_project_appendix(project_appendix)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project_appendix!(project_appendix.id) end
    end

    test "change_project_appendix/1 returns a project_appendix changeset" do
      project_appendix = project_appendix_fixture()
      assert %Ecto.Changeset{} = Projects.change_project_appendix(project_appendix)
    end

    test "get_current_project_appendix_history/2 get status2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      result = MateriaCommerce.Projects.get_current_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 3

      result
      |> Enum.map(
           fn x ->
             assert x.project_number == "PJ-01"
             cond do
               x.appendix_category == "Category1" ->
                 assert x.appendix_status == 0
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
               x.appendix_category == "Category2" ->
                 assert x.appendix_status == 1
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
               x.appendix_category == "Category3" ->
                 assert x.appendix_status == 2
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
             end
           end
         )
    end

    test "delete_future_project_appendix_histories/2 delete status3" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      {result, _} = MateriaCommerce.Projects.delete_future_project_appendix_histories(base_datetime, keywords)
      details = MateriaCommerce.Projects.list_project_appendices() |> Enum.filter(fn x -> x.project_number == "PJ-01" end)
      assert result == 2
      assert Enum.count(details) == 3

      details
      |> Enum.map(
           fn x ->
             assert x.project_number == "PJ-01"
             cond do
               x.appendix_category == "Category1" ->
                 assert x.appendix_status == 0
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
               x.appendix_category == "Category2" ->
                 assert x.appendix_status == 1
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
               x.appendix_category == "Category3" ->
                 assert x.appendix_status == 2
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
             end
           end
         )
    end

    test "get_recent_project_appendix_history/2 no result" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      result = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 0
    end

    test "get_recent_project_appendix_history/2 boundary values" do
      keywords = [{:project_number, "PJ-01"}]

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
      result = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 3
      assert Enum.any?(result, fn x -> x.appendix_status == 0 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 1 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 2 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      result = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 3
      assert Enum.any?(result, fn x -> x.appendix_status == 0 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 1 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 2 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")
      result = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.appendix_status == 3 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 4 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")
      result = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.appendix_status == 3 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 4 end)
    end

    test "create_new_project_appendix_history/5 error parameters lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      keywords = [{:project_number, "PJ-01"}]
      attrs = [
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "99",
          "id" => 1,
          "lock_version" => 0,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category2",
          "appendix_status" => "99",
          "id" => 2,
          #"lock_version" => 1,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category5"
        }
      ]
      assert_raise(KeyError, fn -> MateriaCommerce.Projects.create_new_project_appendix_history(%{}, base_datetime, keywords, attrs, 1) end)
    end

    test "create_new_project_appendix_history/5 error parameters error different lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      keywords = [{:project_number, "PJ-01"}]
      attrs = [
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "99",
          "id" => 1,
          "lock_version" => 0,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category2",
          "appendix_status" => "99",
          "id" => 2,
          "lock_version" => 99,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category5"
        }
      ]
      assert_raise(KeyError, fn -> MateriaCommerce.Projects.create_new_project_appendix_history(%{}, base_datetime, keywords, attrs, 1) end)
    end

    test "create_new_project_appendix_history/5 create data all delete" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attrs = [
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category90",
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category91",
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category92",
        }
      ]
      {:ok, result} = Projects.create_new_project_appendix_history(%{}, base_datetime, keywords, attrs, 1)
      assert Enum.count(result) == 3
      result
      |> Enum.map(
           fn x ->
             assert x.project_number == "PJ-01"
             assert x.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
           end
         )

      details = MateriaCommerce.Projects.list_project_appendices()
                |> Enum.filter(fn x -> x.project_number == "PJ-01" end)
      assert Enum.count(details) == 3
    end

    test "create_new_project_appendix_history/5 create latest history data" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")
      keywords = [{:project_number, "PJ-01"}]
      attrs = [
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "90",
          "id" => 4,
          "lock_version" => 1,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category4",
          "appendix_status" => "91",
          "id" => 5,
          "lock_version" => 0,
        },
        %{
          "project_number" => "PJ-01",
          "appendix_category" => "Category5",
          "appendix_status" => "92",
        }
      ]
      {:ok, result} = MateriaCommerce.Projects.create_new_project_appendix_history(%{}, base_datetime, keywords, attrs, 1)
      assert Enum.count(result) == 3
      result
      |> Enum.map(
           fn x ->
             assert x.project_number == "PJ-01"
             assert x.start_datetime == DateTime.from_naive!(~N[2019-01-02 09:00:00Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
             cond do
               x.appendix_category == "Category1" ->
                 assert x.appendix_status == 90
               x.appendix_category == "Category4" ->
                 assert x.appendix_status == 91
               x.appendix_category == "Category5" ->
                 assert x.appendix_status == 92
             end
           end
         )
      details = MateriaCommerce.Projects.list_project_appendices()
                |> Enum.filter(fn x -> x.project_number == "PJ-01" end)
      assert Enum.count(details) == 8
    end
  end
end
