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
      description: price.description,
      unit_price: price.unit_price,
      lock_version: price.lock_version,
      start_datetime: CalendarUtil.convert_time_utc2local(price.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(price.end_datetime),
      inserted_at: CalendarUtil.convert_time_utc2local(price.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(price.updated_at)
    }
  end
end
