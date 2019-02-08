defmodule MateriaCommerceWeb.PriceView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.PriceView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{prices: prices}) do
    render_many(prices, PriceView, "price.json")
  end

  def render("show.json", %{price: price}) do
    render_one(price, PriceView, "price.json")
  end

  def render("price.json", %{price: price}) do
    %{
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
  end
end
