defmodule MateriaCommerceWeb.ProjectAppendixView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ProjectAppendixView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{project_appendices: project_appendices}) do
    render_many(project_appendices, ProjectAppendixView, "project_appendix.json")
  end

  def render("show.json", %{project_appendix: project_appendix}) do
    render_one(project_appendix, ProjectAppendixView, "project_appendix.json")
  end

  def render("project_appendix.json", %{project_appendix: project_appendix}) do
    result_map =  %{
      id: project_appendix.id,
      project_key1: project_appendix.project_key1,
      project_key2: project_appendix.project_key2,
      project_key3: project_appendix.project_key3,
      project_key4: project_appendix.project_key4,
      project_number: project_appendix.project_number,
      appendix_category: project_appendix.appendix_category,
      appendix_name: project_appendix.appendix_name,
      appendix_date: CalendarUtil.convert_time_utc2local(project_appendix.appendix_date),
      appendix_number: project_appendix.appendix_number,
      appendix_description: project_appendix.appendix_description,
      appendix_status: project_appendix.appendix_status,
      start_datetime: CalendarUtil.convert_time_utc2local(project_appendix.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(project_appendix.end_datetime),
      lock_version: project_appendix.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(project_appendix.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(project_appendix.updated_at)
    }

    cond do
      Ecto.assoc_loaded?(project_appendix.inserted) and project_appendix.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: project_appendix.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end
  end
end
