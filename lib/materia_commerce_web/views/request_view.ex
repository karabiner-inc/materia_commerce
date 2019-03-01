defmodule MateriaCommerceWeb.RequestView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.RequestView
  alias MateriaCommerceWeb.RequestAppendixView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{requests: requests}) do
    render_many(requests, RequestView, "request.json")
  end

  def render("show.json", %{request: request}) do
    render_one(request, RequestView, "request.json")
  end

  def render("request.json", %{request: request}) do
    result_map = %{
      id: request.id,
      request_key1: request.request_key1,
      request_key2: request.request_key2,
      request_key3: request.request_key3,
      request_key4: request.request_key4,
      request_key5: request.request_key5,
      request_number: request.request_number,
      request_name: request.request_name,
      accuracy: request.accuracy,
      request_date1: CalendarUtil.convert_time_utc2local(request.request_date1),
      request_date2: CalendarUtil.convert_time_utc2local(request.request_date2),
      request_date3: CalendarUtil.convert_time_utc2local(request.request_date3),
      request_date4: CalendarUtil.convert_time_utc2local(request.request_date4),
      request_date5: CalendarUtil.convert_time_utc2local(request.request_date5),
      request_date6: CalendarUtil.convert_time_utc2local(request.request_date6),
      quantity1: request.quantity1,
      quantity2: request.quantity2,
      quantity3: request.quantity3,
      quantity4: request.quantity4,
      quantity5: request.quantity5,
      quantity6: request.quantity6,
      description: request.description,
      note1: request.note1,
      note2: request.note2,
      note3: request.note3,
      note4: request.note4,
      start_datetime: CalendarUtil.convert_time_utc2local(request.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(request.end_datetime),
      status: request.status,
      lock_version: request.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(request.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(request.updated_at)
    }

    result_map = cond do
      Ecto.assoc_loaded?(request.user) and request.user != nil ->
        Map.put(result_map, :user, UserView.render("user.json", %{user: request.user}))
      true ->
        Map.put(result_map, :user, nil)
    end

    result_map = cond do
      Ecto.assoc_loaded?(request.inserted) and request.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: request.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end

    result_map = cond do
      Map.has_key?(request, :request_appendices) and request.request_appendices != [] ->
        Map.put(result_map, :request_appendices, RequestAppendixView.render("index.json", %{request_appendices: request.request_appendices}))
      true ->
        Map.put(result_map, :request_appendices, [])
    end
  end
end
