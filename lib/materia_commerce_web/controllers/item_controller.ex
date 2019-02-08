defmodule MateriaCommerceWeb.ItemController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Item
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    items = Products.list_items()
    render(conn, "index.json", items: items)
  end

  def create(conn, item_params) do
    with {:ok, %Item{} = item} <- Products.create_item(item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", item_path(conn, :show, item))
      |> render("show.json", item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Products.get_item!(id)
    render(conn, "show.json", item: item)
  end

  def update(conn, item_params) do
    item = Products.get_item!(item_params["id"])

    with {:ok, %Item{} = item} <- Products.update_item(item, item_params) do
      render(conn, "show.json", item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Products.get_item!(id)
    with {:ok, %Item{}} <- Products.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_items(conn, %{"key_words" => key_words}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    items = Products.get_current_products(now, key_words)
    render(conn, "index.json", items: items)
  end

  def current_items(conn, %{"key_words" => key_words, "params" => params}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    MateriaWeb.ControllerBase.transaction_flow(conn, :item, Products, :create_new_item_history, [now, key_words, params])
  end
end
