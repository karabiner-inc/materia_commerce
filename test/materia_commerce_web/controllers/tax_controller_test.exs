defmodule MateriaCommerceWeb.TaxControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Tax

  @create_attrs %{end_datetime: "2010-04-17 14:00:00.000000Z", name: "some name", start_datetime: "2010-04-17 14:00:00.000000Z", tax_category: "some tax_category", tax_rate: "120.5"}
  @update_attrs %{end_datetime: "2011-05-18 15:01:01.000000Z", name: "some updated name", start_datetime: "2011-05-18 15:01:01.000000Z", tax_category: "some updated tax_category", tax_rate: "456.7"}
  @invalid_attrs %{end_datetime: nil, name: nil, start_datetime: nil, tax_category: nil, tax_rate: nil}

  def fixture(:tax) do
    {:ok, tax} = Products.create_tax(@create_attrs)
    tax
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  end

  describe "index" do
    test "lists all taxes", %{conn: conn} do
      conn = get conn, tax_path(conn, :index)
      assert json_response(conn, 200)!= []
    end
  end

  describe "create tax" do
    test "renders tax when data is valid", %{conn: conn} do
      conn = post conn, tax_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, tax_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
        "id" => id,
        "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
        "lock_version" => 0,
        "name" => "some name",
        "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
        "tax_category" => "some tax_category",
        "tax_rate" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tax_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tax" do
    setup [:create_tax]

    test "renders tax when data is valid", %{conn: conn, tax: %Tax{id: id} = tax} do
      conn = put conn, tax_path(conn, :update, tax), @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, tax_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
        "id" => id,
        "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
        "lock_version" => 0,
        "name" => "some updated name",
        "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
        "tax_category" => "some updated tax_category",
        "tax_rate" => "456.7"}
    end

    test "renders errors when data is invalid", %{conn: conn, tax: tax} do
      conn = put conn, tax_path(conn, :update, tax), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tax" do
    setup [:create_tax]

    test "deletes chosen tax", %{conn: conn, tax: tax} do
      conn = delete conn, tax_path(conn, :delete, tax)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, tax_path(conn, :show, tax)
      end
    end
  end

  defp create_tax(_) do
    tax = fixture(:tax)
    {:ok, tax: tax}
  end
end
