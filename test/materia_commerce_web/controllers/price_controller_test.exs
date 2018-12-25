defmodule MateriaCommerceWeb.PriceControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Price

  @create_attrs %{description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", start_datetime: "2010-04-17 14:00:00.000000Z", unit_price: "120.5"}
  @update_attrs %{description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", start_datetime: "2011-05-18 15:01:01.000000Z", unit_price: "456.7"}
  @invalid_attrs %{description: nil, end_datetime: nil, start_datetime: nil, unit_price: nil}

  def fixture(:price) do
    {:ok, price} = Products.create_price(@create_attrs)
    price
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all prices", %{conn: conn} do
      conn = get conn, price_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create price" do
    test "renders price when data is valid", %{conn: conn} do
      conn = post conn, price_path(conn, :create), price: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, price_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "end_datetime" => "2010-04-17T14:00:00.000000Z",
        "lock_version" => 0,
        "start_datetime" => "2010-04-17T14:00:00.000000Z",
        "unit_price" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, price_path(conn, :create), price: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update price" do
    setup [:create_price]

    test "renders price when data is valid", %{conn: conn, price: %Price{id: id} = price} do
      conn = put conn, price_path(conn, :update, price), price: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, price_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "end_datetime" => "2011-05-18T15:01:01.000000Z",
        "lock_version" => 1,
        "start_datetime" => "2011-05-18T15:01:01.000000Z",
        "unit_price" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, price: price} do
      conn = put conn, price_path(conn, :update, price), price: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete price" do
    setup [:create_price]

    test "deletes chosen price", %{conn: conn, price: price} do
      conn = delete conn, price_path(conn, :delete, price)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, price_path(conn, :show, price)
      end
    end
  end

  defp create_price(_) do
    price = fixture(:price)
    {:ok, price: price}
  end
end
