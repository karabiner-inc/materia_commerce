defmodule MateriaCommerceWeb.ItemControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Products
  alias MateriaCommerce.Products.Item

  @create_attrs %{category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", delivery_area: "some delivery_area", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", lock_version: 42, manufacturer: "some manufacturer", model_number: "some model_number", name: "some name", size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4"}
  @update_attrs %{category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", delivery_area: "some updated delivery_area", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", lock_version: 43, manufacturer: "some updated manufacturer", model_number: "some updated model_number", name: "some updated name", size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", start_datetime: "2011-05-18 15:01:01.000000Z", status: 1, tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4"}
  @invalid_attrs %{category1: nil, category2: nil, category3: nil, category4: nil, color: nil, delivery_area: nil, description: nil, end_datetime: nil, image_url: nil, item_code: nil, jan_code: nil, lock_version: nil, manufacturer: nil, model_number: nil, name: nil, size1: nil, size2: nil, size3: nil, size4: nil, start_datetime: nil, status: nil, tax_category: nil, thumbnail: nil, weight1: nil, weight2: nil, weight3: nil, weight4: nil}

  def fixture(:item) do
    {:ok, item} = Products.create_item(@create_attrs)
    item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get conn, item_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, item_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
        "id" => id,
        "category1" => "some category1",
        "category2" => "some category2",
        "category3" => "some category3",
        "category4" => "some category4",
        "color" => "some color",
        "delivery_area" => "some delivery_area",
        "description" => "some description",
        "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
        "image_url" => "some image_url",
        "item_code" => "some item_code",
        "jan_code" => "some jan_code",
        "lock_version" => 42,
        "manufacturer" => "some manufacturer",
        "model_number" => "some model_number",
        "name" => "some name",
        "size1" => "some size1",
        "size2" => "some size2",
        "size3" => "some size3",
        "size4" => "some size4",
        "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
        "status" => 0,
        "tax_category" => "some tax_category",
        "thumbnail" => "some thumbnail",
        "weight1" => "some weight1",
        "weight2" => "some weight2",
        "weight3" => "some weight3",
        "weight4" => "some weight4",
        "price" => nil,
        "tax" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{conn: conn, item: %Item{id: id} = item} do
      conn = put conn, item_path(conn, :update, item), @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get conn, item_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
        "id" => id,
        "category1" => "some updated category1",
        "category2" => "some updated category2",
        "category3" => "some updated category3",
        "category4" => "some updated category4",
        "color" => "some updated color",
        "delivery_area" => "some updated delivery_area",
        "description" => "some updated description",
        "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
        "image_url" => "some updated image_url",
        "item_code" => "some updated item_code",
        "jan_code" => "some updated jan_code",
        "lock_version" => 43,
        "manufacturer" => "some updated manufacturer",
        "model_number" => "some updated model_number",
        "name" => "some updated name",
        "size1" => "some updated size1",
        "size2" => "some updated size2",
        "size3" => "some updated size3",
        "size4" => "some updated size4",
        "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
        "status" => 1,
        "tax_category" => "some updated tax_category",
        "thumbnail" => "some updated thumbnail",
        "weight1" => "some updated weight1",
        "weight2" => "some updated weight2",
        "weight3" => "some updated weight3",
        "weight4" => "some updated weight4",
        "price" => nil,
        "tax" => nil}
    end

    # test "renders errors when data is invalid", %{conn: conn, item: item} do
    #   conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete conn, item_path(conn, :delete, item)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, item)
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
