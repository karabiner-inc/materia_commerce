defmodule MateriaCommerceWeb.ContractDetailControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.ContractDetail

  @create_contract_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", status: 0, tax_amount: "120.5", total_amount: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2010-04-17 14:00:00.000000Z", inserted_id: 1,}
  @create_attrs %{contract_detail_no: "some contract_detail_no", amount: 42, category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", contract_name: "some contract_name", contract_no: "some contract_no", delivery_area: "some delivery_area", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", lock_version: 42, manufacturer: "some manufacturer", merchandise_cost: "120.5", model_number: "some model_number", name: "some name", price: "120.5", purchase_amount: "120.5", size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", start_datetime: "2010-04-17 14:00:00.000000Z", tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4", datetime1: "2010-04-17 14:00:00.000000Z", datetime2: "2010-04-17 14:00:00.000000Z", datetime3: "2010-04-17 14:00:00.000000Z", datetime4: "2010-04-17 14:00:00.000000Z", inserted_id: 1,}
  @update_attrs %{contract_detail_no: "some updated contract_detail_no", amount: 43, category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", contract_name: "some updated contract_name", contract_no: "some updated contract_no", delivery_area: "some updated delivery_area", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", lock_version: 43, manufacturer: "some updated manufacturer", merchandise_cost: "456.7", model_number: "some updated model_number", name: "some updated name", price: "456.7", purchase_amount: "456.7", size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", start_datetime: "2011-05-18 15:01:01.000000Z", tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4", datetime1: nil, datetime2: nil, datetime3: nil, datetime4: nil, inserted_id: 1,}
  @invalid_attrs %{contract_detail_no: nil, amount: nil, category1: nil, category2: nil, category3: nil, category4: nil, color: nil, contract_name: nil, contract_no: nil, delivery_area: nil, description: nil, end_datetime: nil, image_url: nil, item_code: nil, jan_code: nil, lock_version: nil, manufacturer: nil, merchandise_cost: nil, model_number: nil, name: nil, price: nil, purchase_amount: nil, size1: nil, size2: nil, size3: nil, size4: nil, start_datetime: nil, tax_category: nil, thumbnail: nil, weight1: nil, weight2: nil, weight3: nil, weight4: nil, inserted_id: nil}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }
  def fixture(:contract_detail) do
    {:ok, contract} = Commerces.create_contract(@create_contract_attrs)
    params = Map.put(@create_attrs, :contract_id, contract.id)
    {:ok, contract_detail} = Commerces.create_contract_detail(params)
    contract_detail
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all contract_details", %{conn: conn} do
      conn = get conn, contract_detail_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create contract_detail" do
    test "renders contract_detail when data is valid", %{conn: conn} do
      {:ok, contract} = Commerces.create_contract(@create_contract_attrs)
      params = Map.put(@create_attrs, :contract_id, contract.id)
      result_conn = post conn, contract_detail_path(conn, :create), params
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, contract_detail_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
               "id" => id,
               "amount" => 42,
               "category1" => "some category1",
               "category2" => "some category2",
               "category3" => "some category3",
               "category4" => "some category4",
               "color" => "some color",
               "contract_name" => "some contract_name",
               "contract_no" => "some contract_no",
               "branch_type" => "contract",
               "branch_number" => 0,
               "contract_detail_no" => "some contract_detail_no",
               "delivery_area" => "some delivery_area",
               "description" => "some description",
               "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "image_url" => "some image_url",
               "item_code" => "some item_code",
               "jan_code" => "some jan_code",
               "lock_version" => 42,
               "manufacturer" => "some manufacturer",
               "merchandise_cost" => "120.5",
               "model_number" => "some model_number",
               "name" => "some name",
               "price" => "120.5",
               "purchase_amount" => "120.5",
               "size1" => "some size1",
               "size2" => "some size2",
               "size3" => "some size3",
               "size4" => "some size4",
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "tax_category" => "some tax_category",
               "thumbnail" => "some thumbnail",
               "weight1" => "some weight1",
               "weight2" => "some weight2",
               "weight3" => "some weight3",
               "weight4" => "some weight4",
               "datetime1" => "2010-04-17T23:00:00.000000+09:00",
               "datetime2" => "2010-04-17T23:00:00.000000+09:00",
               "datetime3" => "2010-04-17T23:00:00.000000+09:00",
               "datetime4" => "2010-04-17T23:00:00.000000+09:00",
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
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               }
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contract_detail_path(conn, :create), contract_detail: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contract_detail" do
    setup [:create_contract_detail]

    test "renders contract_detail when data is valid", %{conn: conn, contract_detail: %ContractDetail{id: id} = contract_detail} do
      result_conn = put conn, contract_detail_path(conn, :update, contract_detail), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, contract_detail_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
        "id" => id,
               "amount" => 43,
               "category1" => "some updated category1",
               "category2" => "some updated category2",
               "category3" => "some updated category3",
               "category4" => "some updated category4",
               "color" => "some updated color",
               "contract_name" => "some updated contract_name",
               "contract_no" => "some updated contract_no",
               "branch_type" => "contract",
               "branch_number" => 0,
               "contract_detail_no" => "some updated contract_detail_no",
               "delivery_area" => "some updated delivery_area",
               "description" => "some updated description",
               "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "image_url" => "some updated image_url",
               "item_code" => "some updated item_code",
               "jan_code" => "some updated jan_code",
               "lock_version" => 43,
               "manufacturer" => "some updated manufacturer",
               "merchandise_cost" => "456.7",
               "model_number" => "some updated model_number",
               "name" => "some updated name",
               "price" => "456.7",
               "purchase_amount" => "456.7",
               "size1" => "some updated size1",
               "size2" => "some updated size2",
               "size3" => "some updated size3",
               "size4" => "some updated size4",
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "tax_category" => "some updated tax_category",
               "thumbnail" => "some updated thumbnail",
               "weight1" => "some updated weight1",
               "weight2" => "some updated weight2",
               "weight3" => "some updated weight3",
               "weight4" => "some updated weight4",
               "datetime1" => nil,
               "datetime2" => nil,
               "datetime3" => nil,
               "datetime4" => nil,
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
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               }
             }
    end

    # test "renders errors when data is invalid", %{conn: conn, contract_detail: contract_detail} do
    #   conn = put conn, contract_detail_path(conn, :update, contract_detail), contract_detail: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete contract_detail" do
    setup [:create_contract_detail]

    test "deletes chosen contract_detail", %{conn: conn, contract_detail: contract_detail} do
      result_conn = delete conn, contract_detail_path(conn, :delete, contract_detail)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, contract_detail_path(conn, :show, contract_detail)
      end
    end
  end

  defp create_contract_detail(_) do
    contract_detail = fixture(:contract_detail)
    {:ok, contract_detail: contract_detail}
  end
end
