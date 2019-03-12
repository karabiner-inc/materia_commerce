defmodule MateriaCommerceWeb.PriceControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Price

  @create_attrs %{description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", item_code: "some item_code", merchandise_cost: "120.5", purchase_amount: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", unit_price: "120.5", inserted_id: 1,}
  @update_attrs %{description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", item_code: "some updated item_code", merchandise_cost: "456.7", purchase_amount: "456.7", start_datetime: "2011-05-18 15:01:01.000000Z", unit_price: "456.7", inserted_id: 1,}
  @invalid_attrs %{description: nil, end_datetime: nil, item_code: nil, lock_version: nil, merchandise_cost: nil, purchase_amount: nil, start_datetime: nil, unit_price: nil, inserted_id: 1}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }
  def fixture(:price) do
    {:ok, price} = Products.create_price(@create_attrs)
    price
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all prices", %{conn: conn} do
      conn = get conn, price_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create price" do
    test "renders price when data is valid", %{conn: conn} do
      result_conn = post conn, price_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, price_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
               "id" => id,
               "description" => "some description",
               "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "item_code" => "some item_code",
               "lock_version" => 0,
               "merchandise_cost" => "120.5",
               "purchase_amount" => "120.5",
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "unit_price" => "120.5",
               "inserted" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => [],
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               }
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, price_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update price" do
    setup [:create_price]

    test "renders price when data is valid", %{conn: conn, price: %Price{id: id} = price} do
      result_conn = put conn, price_path(conn, :update, price), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, price_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
               "id" => id,
               "description" => "some updated description",
               "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "item_code" => "some updated item_code",
               "lock_version" => 1,
               "merchandise_cost" => "456.7",
               "purchase_amount" => "456.7",
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "unit_price" => "456.7",
               "inserted" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => [],
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               }
             }
    end

    test "renders errors when data is invalid", %{conn: conn, price: price} do
      conn = put conn, price_path(conn, :update, price), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete price" do
    setup [:create_price]

    test "deletes chosen price", %{conn: conn, price: price} do
      result_conn = delete conn, price_path(conn, :delete, price)
      assert response(result_conn, 204)
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
