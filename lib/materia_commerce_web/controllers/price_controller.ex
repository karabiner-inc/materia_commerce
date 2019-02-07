defmodule MateriaCommerceWeb.PriceController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Price

  action_fallback MateriaCommerceWeb.FallbackController

  def index(conn, _params) do
    prices = Products.list_prices()
    render(conn, "index.json", prices: prices)
  end

  def create(conn, price_params) do
    with {:ok, %Price{} = price} <- Products.create_price(price_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", price_path(conn, :show, price))
      |> render("show.json", price: price)
    end
  end

  def show(conn, %{"id" => id}) do
    price = Products.get_price!(id)
    render(conn, "show.json", price: price)
  end

  def update(conn, price_params) do
    price = Products.get_price!(price_params["id"])
    with {:ok, %Price{} = price} <- Products.update_price(price, price_params) do
      render(conn, "show.json", price: price)
    end
  end

  def delete(conn, %{"id" => id}) do
    price = Products.get_price!(id)
    with {:ok, %Price{}} <- Products.delete_price(price) do
      send_resp(conn, :no_content, "")
    end
  end
end
