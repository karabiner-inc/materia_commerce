defmodule MateriaCommerceWeb.TaxController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Tax

  action_fallback MateriaCommerceWeb.FallbackController

  def index(conn, _params) do
    taxes = Products.list_taxes()
    render(conn, "index.json", taxes: taxes)
  end

  def create(conn, %{"tax" => tax_params}) do
    with {:ok, %Tax{} = tax} <- Products.create_tax(tax_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", tax_path(conn, :show, tax))
      |> render("show.json", tax: tax)
    end
  end

  def show(conn, %{"id" => id}) do
    tax = Products.get_tax!(id)
    render(conn, "show.json", tax: tax)
  end

  def update(conn, %{"id" => id, "tax" => tax_params}) do
    tax = Products.get_tax!(id)

    with {:ok, %Tax{} = tax} <- Products.update_tax(tax, tax_params) do
      render(conn, "show.json", tax: tax)
    end
  end

  def delete(conn, %{"id" => id}) do
    tax = Products.get_tax!(id)
    with {:ok, %Tax{}} <- Products.delete_tax(tax) do
      send_resp(conn, :no_content, "")
    end
  end
end
