defmodule MateriaCommerceWeb.RequestAppendixView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.RequestAppendixView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{request_appendices: request_appendices}) do
    render_many(request_appendices, RequestAppendixView, "request_appendix.json")
  end

  def render("show.json", %{request_appendices: request_appendices}) do
    render_many(request_appendices, RequestAppendixView, "request_appendix.json")
  end

  def render("show.json", %{request_appendix: request_appendix}) do
    render_one(request_appendix, RequestAppendixView, "request_appendix.json")
  end

  def render("request_appendix.json", %{request_appendix: request_appendix}) do
    result_map =  %{
      id: request_appendix.id,
      request_key1: request_appendix.request_key1,
      request_key2: request_appendix.request_key2,
      request_key3: request_appendix.request_key3,
      request_key4: request_appendix.request_key4,
      request_number: request_appendix.request_number,
      appendix_category: request_appendix.appendix_category,
      appendix_name: request_appendix.appendix_name,
      appendix_date: CalendarUtil.convert_time_utc2local(request_appendix.appendix_date),
      appendix_number: request_appendix.appendix_number,
      appendix_description: request_appendix.appendix_description,
      appendix_status: request_appendix.appendix_status,
      start_datetime: CalendarUtil.convert_time_utc2local(request_appendix.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(request_appendix.end_datetime),
      lock_version: request_appendix.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(request_appendix.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(request_appendix.updated_at)
    }

    cond do
      Ecto.assoc_loaded?(request_appendix.inserted) and request_appendix.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: request_appendix.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end
  end
end
