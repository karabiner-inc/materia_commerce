defmodule MateriaCommerceWeb.TaxController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Tax
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    taxes = Products.list_taxes()
    render(conn, "index.json", taxes: taxes)
  end

  def create(conn, tax_params) do
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

  def update(conn, tax_params) do
    tax = Products.get_tax!(tax_params["id"])

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

  def search_current_taxes(conn, params) do
    base_datetime = CalendarUtil.now()
    taxes = Products.get_current_tax(base_datetime, params)
    render(conn, "index.json", taxes: taxes)
  end

  def current_taxes(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()
    key_words = [{:tax_category, params["tax_category"]}]

    MateriaWeb.ControllerBase.transaction_flow(conn, :tax, Products, :create_new_tax_history, [
      now,
      key_words,
      params,
      user_id
    ])
  end
end
