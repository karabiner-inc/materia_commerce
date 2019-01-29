defmodule MateriaCommerceWeb.ItemView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ItemView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{items: items}) do
    render_many(items, ItemView, "item.json")
  end

  def render("show.json", %{item: item}) do
    render_one(item, ItemView, "item.json")
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      name: item.name,
      category1: item.category1,
      category2: item.category2,
      category3: item.category3,
      category4: item.category4,
      item_code: item.item_code,
      model_number: item.model_number,
      jan_code: item.jan_code,
      thumbnail: item.thumbnail,
      image_url: item.image_url,
      size1: item.size1,
      size2: item.size2,
      size3: item.size3,
      size4: item.size4,
      weight1: item.weight1,
      weight2: item.weight2,
      weight3: item.weight3,
      weight4: item.weight4,
      delivery_area: item.delivery_area,
      manufacturer: item.manufacturer,
      status: item.status,
      color: item.color,
      description: item.description,
      tax_category: item.tax_category,
      lock_version: item.lock_version,
      start_datetime: CalendarUtil.convert_time_utc2local(item.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(item.end_datetime),
      inserted_at: CalendarUtil.convert_time_utc2local(item.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(item.updated_at)
    }
  end
end
