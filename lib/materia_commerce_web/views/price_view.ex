defmodule MateriaCommerceWeb.PriceView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.PriceView

  def render("index.json", %{prices: prices}) do
    %{data: render_many(prices, PriceView, "price.json")}
  end

  def render("show.json", %{price: price}) do
    %{data: render_one(price, PriceView, "price.json")}
  end

  def render("price.json", %{price: price}) do
    %{id: price.id,
      description: price.description,
      unit_price: price.unit_price,
      start_datetime: price.start_datetime,
      end_datetime: price.end_datetime,
      lock_version: price.lock_version}
  end
end
