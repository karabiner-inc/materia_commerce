defmodule MateriaCommerceWeb.ProjectView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ProjectView
  alias AppExWeb.ProjectAppendixView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{projects: projects}) do
    render_many(projects, ProjectView, "project.json")
  end

  def render("show.json", %{project: project}) do
    render_one(project, ProjectView, "project.json")
  end

  def render("project.json", %{project: project}) do
    result_map = %{
      id: project.id,
      project_key1: project.project_key1,
      project_key2: project.project_key2,
      project_key3: project.project_key3,
      project_key4: project.project_key4,
      project_number: project.project_number,
      project_name: project.project_name,
      accuracy: project.accuracy,
      project_date1: CalendarUtil.convert_time_utc2local(project.project_date1),
      project_date2: CalendarUtil.convert_time_utc2local(project.project_date2),
      project_date3: CalendarUtil.convert_time_utc2local(project.project_date3),
      project_date4: CalendarUtil.convert_time_utc2local(project.project_date4),
      project_date5: CalendarUtil.convert_time_utc2local(project.project_date5),
      project_date6: CalendarUtil.convert_time_utc2local(project.project_date6),
      quantity1: project.quantity1,
      quantity2: project.quantity2,
      quantity3: project.quantity3,
      quantity4: project.quantity4,
      quantity5: project.quantity5,
      quantity6: project.quantity6,
      description: project.description,
      note1: project.note1,
      note2: project.note2,
      note3: project.note3,
      note4: project.note4,
      start_datetime: CalendarUtil.convert_time_utc2local(project.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(project.end_datetime),
      status: project.status,
      lock_version: project.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(project.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(project.updated_at)
    }

    result_map = cond do
      Ecto.assoc_loaded?(project.user) and project.user != nil ->
        Map.put(result_map, :user, UserView.render("user.json", %{user: project.user}))
      true ->
        Map.put(result_map, :user, nil)
    end

    result_map = cond do
      Ecto.assoc_loaded?(project.inserted) and project.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: project.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end

    result_map = cond do
      Map.has_key?(project, :project_appendices) and project.project_appendices != [] ->
        Map.put(result_map, :project_appendices, ProjectAppendixView.render("index.json", %{project_appendices: project.project_appendices}))
      true ->
        Map.put(result_map, :project_appendices, [])
    end
  end
end
