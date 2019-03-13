defmodule MateriaCommerceWeb.ItemView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ItemView
  alias MateriaCommerceWeb.PriceView
  alias MateriaCommerceWeb.TaxView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{items: items}) do
    render_many(items, ItemView, "item.json")
  end

  def render("show.json", %{item: item}) do
    render_one(item, ItemView, "item.json")
  end

  def render("item.json", %{item: item}) do
    result_map = %{
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

    result_map = if Map.has_key?(item, :price) and item.price != nil do
      Map.put(result_map, :price, PriceView.render("show.json", %{price: item.price}))
    else
      Map.put(result_map, :price, nil)
    end

    result_map = if Map.has_key?(item, :tax) and item.tax != nil do
      Map.put(result_map, :tax, TaxView.render("show.json", %{tax: item.tax}))
    else
      Map.put(result_map, :tax, nil)
    end

    result_map = cond do
      Ecto.assoc_loaded?(item.inserted) and item.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: item.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end
  end
end
