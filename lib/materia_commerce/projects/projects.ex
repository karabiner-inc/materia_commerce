defmodule MateriaCommerce.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias MateriaCommerce.Repo

  alias MateriaCommerce.Projects.Project
  alias MateriaCommerce.Projects.ProjectAppendix

  alias MateriaUtils.Ecto.EctoUtil
  alias MateriaUtils.Calendar.CalendarUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of projects.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Projects.list_projects
  iex(3)> view = MateriaCommerceWeb.ProjectView.render("index.json", %{projects: results})
  iex(4)> view = view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end)
  iex(5)> view |> Enum.count()
  4
  """
  def list_projects do
    Project
    |> @repo.all()
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Gets a single project.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Projects.get_project!(1)
  iex(3)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(4)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_appendices: [],
  project_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History1",
  project_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def get_project!(id) do
    Project
    |> @repo.get!(id)
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Creates a project.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> attrs = %{"project_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Projects.create_project(attrs)
  iex(6)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); end) |> List.first
  %{
  accuracy: nil,
  description: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 0,
  note1: nil,
  note2: nil,
  note3: nil,
  note4: nil,
  project_appendices: [],
  project_date1: "",
  project_date2: "",
  project_date3: "",
  project_date4: "",
  project_date5: "",
  project_date6: "",
  project_key1: nil,
  project_key2: nil,
  project_key3: nil,
  project_key4: nil,
  project_name: nil,
  project_number: "1",
  quantity1: nil,
  quantity2: nil,
  quantity3: nil,
  quantity4: nil,
  quantity5: nil,
  quantity6: nil,
  status: 0,
  user: nil
  }
  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a project.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(3)> results = MateriaCommerce.Projects.get_project!(1)
  iex(4)> attrs = %{"project_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Projects.update_project(results, attrs)
  iex(6)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_appendices: [],
  project_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History1",
  project_number: "1",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Project.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Projects.get_project!(1)
  iex(3)> {:ok, results} = MateriaCommerce.Projects.delete_project(results)
  iex(4)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(5)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_appendices: [],
  project_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History1",
  project_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def delete_project(%Project{} = project) do
    @repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  iex(1)> attrs = %MateriaCommerce.Projects.Project{} |> Map.put(:project_number, "1") |> Map.put(:start_datetime, "1") |> Map.put(:end_datetime, "1") |> Map.put(:inserted_id, "1")
  iex(2)> change_set = MateriaCommerce.Projects.change_project(attrs)
  iex(3)> change_set.valid?
  true
  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  @doc """
  Returns the list of project_appendices.

  iex(1)> MateriaCommerce.Projects.list_project_appendices() |> Enum.count()
  6
  """
  def list_project_appendices do
    ProjectAppendix
    |> @repo.all()
    |> @repo.preload([:inserted])
  end

  @doc """
  Gets a single project_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Projects.get_project_appendix!(1)
  iex(3)> view = MateriaCommerceWeb.ProjectAppendixView.render("show.json", %{project_appendix: results})
  iex(4)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_number: "PJ-01"
  }
  """
  def get_project_appendix!(id) do
    ProjectAppendix
    |> @repo.get!(id)
    |> @repo.preload([:inserted])
  end

  @doc """
  Creates a project_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> attrs = %{"project_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Projects.create_project_appendix(attrs)
  iex(6)> view = MateriaCommerceWeb.ProjectAppendixView.render("show.json", %{project_appendix: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));end) |> List.first
  %{
  appendix_category: nil,
  appendix_date: "",
  appendix_description: nil,
  appendix_name: nil,
  appendix_number: "",
  appendix_status: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 0,
  project_key1: nil,
  project_key2: nil,
  project_key3: nil,
  project_key4: nil,
  project_number: "1"
  }
  """
  def create_project_appendix(attrs \\ %{}) do
    %ProjectAppendix{}
    |> ProjectAppendix.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a project_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> results = MateriaCommerce.Projects.get_project_appendix!(1)
  iex(5)> attrs = %{"project_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(6)> {:ok, results} = MateriaCommerce.Projects.update_project_appendix(results, attrs)
  iex(7)> view = MateriaCommerceWeb.ProjectAppendixView.render("show.json", %{project_appendix: results})
  iex(8)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_number: "1"
  }
  """
  def update_project_appendix(%ProjectAppendix{} = project_appendix, attrs) do
    project_appendix
    |> ProjectAppendix.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ProjectAppendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> results = MateriaCommerce.Projects.get_project_appendix!(1)
  iex(6)> {:ok, results} = MateriaCommerce.Projects.delete_project_appendix(results)
  iex(7)> view = MateriaCommerceWeb.ProjectAppendixView.render("show.json", %{project_appendix: results})
  iex(8)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_number: "PJ-01"
  }
  """
  def delete_project_appendix(%ProjectAppendix{} = project_appendix) do
    @repo.delete(project_appendix)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_appendix changes.

  iex(1)> attrs = %MateriaCommerce.Projects.ProjectAppendix{} |> Map.put(:project_number, "1") |> Map.put(:start_datetime, "1") |> Map.put(:end_datetime, "1") |> Map.put(:inserted_id, "1")
  iex(2)> change_set = MateriaCommerce.Projects.change_project_appendix(attrs)
  iex(3)> change_set.valid?
  true
  """
  def change_project_appendix(%ProjectAppendix{} = project_appendix) do
    ProjectAppendix.changeset(project_appendix, %{})
  end

  @doc """

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_current_project_history(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 2,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_appendices: [],
  project_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History3",
  project_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user: nil
  }
  """
  def get_current_project_history(base_datetime, keywords) do
    projects = EctoUtil.list_current_history(@repo, Project, base_datetime, keywords)
    if projects == [] do
      nil
    else
      [project] = projects
      project
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_recent_project_history(base_datetime, keywords)
  iex(5)> view = results
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2999-12-31 23:59:59Z",
  inserted_id: 1,
  lock_version: 2,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_date1: "2999-12-31 23:59:59Z",
  project_date2: "2999-12-31 23:59:59Z",
  project_date3: "2999-12-31 23:59:59Z",
  project_date4: "2999-12-31 23:59:59Z",
  project_date5: "2999-12-31 23:59:59Z",
  project_date6: "2999-12-31 23:59:59Z",
  project_key1: "key1",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History3",
  project_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user_id: 1
  }
  """
  def get_recent_project_history(base_datetime, keywords) do
    projects = EctoUtil.list_recent_history(@repo, Project, base_datetime, keywords)
    if projects == [] do
      nil
    else
      [project] = projects
      project
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(3)> attr = %{"project_number" => "PJ-01", "project_key1" => "key1_update", "lock_version" => 2}
  iex(4)> {:ok, results} = MateriaCommerce.Projects.create_new_project_history(%{}, base_datetime, keywords, attr, 1)
  iex(5)> view = MateriaCommerceWeb.ProjectView.render("show.json", %{project: results})
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 3,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  project_appendices: [],
  project_date1: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_date2: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_date3: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_date4: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_date5: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_date6: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  project_key1: "key1_update",
  project_key2: "key2",
  project_key3: "key3",
  project_key4: "key4",
  project_name: "History3",
  project_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user: nil
  }
  """
  def create_new_project_history(%{}, start_datetime, keywords, attr, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent = get_recent_project_history(start_datetime, keywords)
    {i, _reason} = delete_future_project_histories(start_datetime, keywords)
    project =
      if recent == nil do
        attr = attr
               |> Map.put("start_datetime", start_datetime)
               |> Map.put("end_datetime", end_datetime)
               |> Map.put("inserted_id", user_id)
        {:ok, project} = create_project(attr)
      else
        _ = cond do
          !Map.has_key?(attr, "lock_version") ->
            raise KeyError, message: "parameter have not lock_version"
          attr["lock_version"] != recent.lock_version ->
            raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
          true -> :ok
        end

        attr = Map.keys(attr)
               |> Enum.reduce(
                    recent,
                    fn (key, acc) ->
                      acc = acc
                            |> Map.put(String.to_atom(key), attr[key])
                    end
                  )

        attr = attr
               |> Map.put(:lock_version, recent.lock_version + 1)
               |> Map.put(:start_datetime, start_datetime)
               |> Map.put(:end_datetime, end_datetime)
               |> Map.put(:inserted_id, user_id)

        {:ok, project} = create_project(attr)
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_project = struct(Project, recent)
        update_project(struct_project, %{end_datetime: recent_end_datetime})
        {:ok, project}
      end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> {result, _} = MateriaCommerce.Projects.delete_future_project_histories(base_datetime, keywords)
  {2, nil}
  """
  def delete_future_project_histories(base_datetime, keywords) do
    projects = EctoUtil.delete_future_histories(@repo, Project, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_current_project_appendix_history(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.ProjectAppendixView.render("index.json", %{project_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 0,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 1,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  }
  ]
  """
  def get_current_project_appendix_history(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, ProjectAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
  iex(5)> view = results
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "2999-12-31 23:59:59Z",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "2999-12-31 23:59:59Z",
    inserted_id: 1,
    lock_version: 0,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "2999-12-31 23:59:59Z",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "2999-12-31 23:59:59Z",
    inserted_id: 1,
    lock_version: 1,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  }
  ]
  """
  def get_recent_project_appendix_history(base_datetime, keywords) do
    EctoUtil.list_recent_history(@repo, ProjectAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(3)> attr = [%{"project_number" => "PJ-01", "project_key1" => "key1_update", "lock_version" => 1, "id" => 4}]
  iex(4)> {:ok, results} = MateriaCommerce.Projects.create_new_project_appendix_history(%{}, base_datetime, keywords, attr, 1)
  iex(5)> view = MateriaCommerceWeb.ProjectAppendixView.render("index.json", %{project_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 2,
    project_key1: "key1_update",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  }
  ]
  """
  def create_new_project_appendix_history(%{}, start_datetime, keywords, attrs, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_project_appendix = get_recent_project_appendix_history(start_datetime, keywords)
    {i, _reason} = delete_future_project_appendix_histories(start_datetime, keywords)
    project_appendix =
      if recent_project_appendix == [] do
        project_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  attr = attr
                                         |> Map.put("start_datetime", start_datetime)
                                         |> Map.put("end_datetime", end_datetime)
                                         |> Map.put("inserted_id", user_id)
                                  {:ok, project_appendix} = create_project_appendix(attr)
                                  project_appendix
                                end
                              )
        {:ok, project_appendix}
      else
        attrs
        |> Enum.map(
             fn attr ->
               cond do
                 Map.has_key?(attr, "id") and !Map.has_key?(attr, "lock_version") ->
                   raise KeyError, message: "parameter have not lock_version"
                 Map.has_key?(attr, "id") and !check_recent_project_appendix(recent_project_appendix, attr["id"], attr["lock_version"]) ->
                   raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
                 true -> :ok
               end
             end
           )

        project_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  recent = check_recent_project_appendix(
                                    recent_project_appendix,
                                    attr["id"],
                                    attr["lock_version"]
                                  )
                                  unless recent do
                                    recent = Map.from_struct(%ProjectAppendix{})
                                  end
                                  recent = Map.keys(attr)
                                           |> Enum.reduce(
                                                recent,
                                                fn (key, acc) ->
                                                  acc = acc
                                                        |> Map.put(String.to_atom(key), attr[key])
                                                end
                                              )
                                           |> Map.put(:lock_version, recent.lock_version + 1)
                                           |> Map.put(:start_datetime, start_datetime)
                                           |> Map.put(:end_datetime, end_datetime)
                                           |> Map.put(:inserted_id, user_id)
                                end
                              )
                           |> Enum.map(
                                fn attr ->
                                  {:ok, project_appendix} = create_project_appendix(attr)
                                  project_appendix
                                end
                              )

        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        recent_project_appendix
        |> Enum.map(
             fn recent ->
               struct_project_appendix = struct(ProjectAppendix, recent)
               update_project_appendix(struct_project_appendix, %{end_datetime: recent_end_datetime})
             end
           )
        {:ok, project_appendix}
      end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> {result, _} = MateriaCommerce.Projects.delete_future_project_appendix_histories(base_datetime, keywords)
  {2, nil}
  """
  def delete_future_project_appendix_histories(base_datetime, keywords) do
    EctoUtil.delete_future_histories(@repo, ProjectAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_recent_project_appendix_history(base_datetime, keywords)
  iex(5)> result = MateriaCommerce.Projects.check_recent_project_appendix(results, 5, 4)
  iex(6)> result == false
  true
  iex(7)> result = MateriaCommerce.Projects.check_recent_project_appendix(results, 5, 0)
  iex(8)> result == false
  false
  """
  def check_recent_project_appendix(recent_project_appendix, id, lock_version) do
    filter = Enum.filter(recent_project_appendix, fn x -> x.id == id end) |> List.first
    cond do
      filter != nil and filter.lock_version != lock_version -> false
      filter == nil -> false
      true -> filter
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_current_project(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.ProjectView.render("index.json", %{projects: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :project_date1, to_string(x.project_date1)); x = Map.put(x, :project_date2, to_string(x.project_date2)); x = Map.put(x, :project_date3, to_string(x.project_date3)); x = Map.put(x, :project_date4, to_string(x.project_date4)); x = Map.put(x, :project_date5, to_string(x.project_date5)); x = Map.put(x, :project_date6, to_string(x.project_date6)); end)
  [
  %{
    accuracy: "accuracy",
    description: "description",
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 2,
    note1: "note1",
    note2: "note2",
    note3: "note3",
    note4: "note4",
    project_appendices: [],
    project_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_name: "History3",
    project_number: "PJ-01",
    quantity1: 0,
    quantity2: 1,
    quantity3: 2,
    quantity4: 3,
    quantity5: 4,
    quantity6: 5,
    status: 2,
    user: nil
  }
  ]
  """
  def get_current_project(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, Project, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:project_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Projects.get_current_project_appendices(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.ProjectAppendixView.render("index.json", %{project_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 0,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 1,
    project_key1: "key1",
    project_key2: "key2",
    project_key3: "key3",
    project_key4: "key4",
    project_number: "PJ-01"
  }
  ]
  """
  def get_current_project_appendices(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, ProjectAppendix, base_datetime, keywords)
  end
end
