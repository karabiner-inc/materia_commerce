defmodule MateriaCommerceWeb.PriceView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.PriceView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{prices: prices}) do
    render_many(prices, PriceView, "price.json")
  end

  def render("show.json", %{price: price}) do
    render_one(price, PriceView, "price.json")
  end

  def render("price.json", %{price: price}) do
    result_map = %{
      id: price.id,
      item_code: price.item_code,
      description: price.description,
      unit_price: price.unit_price,
      purchase_amount: price.purchase_amount,
      merchandise_cost: price.merchandise_cost,
      start_datetime: CalendarUtil.convert_time_utc2local(price.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(price.end_datetime),
      lock_version: price.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(price.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(price.updated_at)
    }

    result_map = cond do
      Ecto.assoc_loaded?(price.inserted) and price.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: price.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end
  end
end
