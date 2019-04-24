defmodule MateriaCommerceWeb.ContractControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Contract

  @create_attrs %{billing_address: 42, buyer_id: 1, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2099-12-31 23:59:59.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5", inserted_id: 1,}
  @update_attrs %{billing_address: 43, buyer_id: 43, contract_no: "some updated contract_no", contracted_date: "2011-05-18 15:01:01.000000Z", delivery_address: 43, delivery_end_datetime: "2011-05-18 15:01:01.000000Z", delivery_start_datetime: "2011-05-18 15:01:01.000000Z", end_datetime: "2011-05-18 15:01:01.000000Z", expiration_date: "2011-05-18 15:01:01.000000Z", lock_version: 43, seller_id: 43, sender_address: 43, settlement: "some updated settlement", shipping_fee: "456.7", start_datetime: "2011-05-18 15:01:01.000000Z", status: 1, tax_amount: "456.7", total_amount: "456.7", inserted_id: 1,}
  @invalid_attrs %{billing_address: nil, buyer_id: nil, contract_no: nil, contracted_date: nil, delivery_address: nil, delivery_end_datetime: nil, delivery_start_datetime: nil, end_datetime: nil, expiration_date: nil, lock_version: nil, seller_id: nil, sender_address: nil, settlement: nil, shipping_fee: nil, start_datetime: nil, status: nil, tax_amount: nil, total_amount: nil, inserted_id: nil}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }
  def fixture(:contract) do
    {:ok, contract} = Commerces.create_contract(@create_attrs)
    contract
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, contract_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn} do
      result_conn = post conn, contract_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      show_conn = get conn, contract_path(conn, :show, id)
      assert json_response(show_conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
               "id" => id,
               "billing_address" => 42,
               "buyer_id" => 1,
               "contract_no" => "some contract_no",
               "request_number" => nil,
               "contracted_date" => "2010-04-17T23:00:00.000000+09:00",
               "delivery_address" => 42,
               "delivery_end_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "delivery_start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "end_datetime" => "2100-01-01T08:59:59.000000+09:00",
               "expiration_date" => "2010-04-17T23:00:00.000000+09:00",
               "lock_version" => 42,
               "seller_id" => 42,
               "sender_address" => 42,
               "settlement" => "some settlement",
               "shipping_fee" => "120.5",
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "status" => 0,
               "tax_amount" => "120.5",
               "total_amount" => "120.5",
               "contract_details" => [],
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
               },
               "buyer" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "hogehoge@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 1, "lock_version" => 2, "name" => "hogehoge", "organization" => [], "phone_number" => nil, "role" => "admin", "status" => 1},
               "seller" => nil
             }

        result_conn = post conn, contract_path(conn, :search_my_current_contracts), %{}
        resp = json_response(result_conn, 200)
        assert length(resp) == 1

    end

    test "create my contract hostory", %{conn: conn} do
      attrs = %{buyer_id: 99, seller_id: 99, billing_address: 42, contract_no: "some contract_no2", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2099-12-31 23:59:59.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5"}
      error_result_conn = post conn, contract_path(conn, :create_my_new_contract_history), attrs
      error_resp = response(error_result_conn, 400)
      assert error_resp == "\"At least either buyer_id or seller_id should be your user_id. user_id:1 buyer_id:99 seller_id:99\""

      attrs = %{buyer_id: 1, seller_id: 99, billing_address: 42, contract_no: "some contract_no2", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2099-12-31 23:59:59.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5"}
      result_conn = post conn, contract_path(conn, :create_my_new_contract_history), attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      result_conn = post conn, contract_path(conn, :search_my_current_contracts), %{"and" => [%{"contract_no" => "some contract_no2"}]}
      resp = json_response(result_conn, 200)
      assert length(resp) == 1

      attrs = %{buyer_id: 99, seller_id: 1, billing_address: 42, contract_no: "some contract_no3", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2099-12-31 23:59:59.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5"}
      result_conn = post conn, contract_path(conn, :create_my_new_contract_history), attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      result_conn = post conn, contract_path(conn, :search_my_current_contracts), %{"and" => [%{"contract_no" => "some contract_no3"}]}
      resp = json_response(result_conn, 200)
      assert length(resp) == 1



    end

#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post conn, contract_path(conn, :create), contract: @invalid_attrs
#      assert json_response(conn, 422)["errors"] != %{}
#    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "renders contract when data is valid", %{conn: conn, contract: %Contract{id: id} = contract} do

      result_conn = put conn, contract_path(conn, :update, contract), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, contract_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("updated_at")
             |> Map.delete("inserted_at") == %{
               "id" => id,
               "billing_address" => 43,
               "buyer_id" => 43,
               "contract_no" => "some updated contract_no",
               "request_number" => nil,
               "contracted_date" => "2011-05-19T00:01:01.000000+09:00",
               "delivery_address" => 43,
               "delivery_end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "delivery_start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "expiration_date" => "2011-05-19T00:01:01.000000+09:00",
               "lock_version" => 43,
               "seller_id" => 43,
               "sender_address" => 43,
               "settlement" => "some updated settlement",
               "shipping_fee" => "456.7",
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "status" => 1,
               "tax_amount" => "456.7",
               "total_amount" => "456.7",
               "contract_details" => [],
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
               },
               "buyer" => nil,
               "seller" => nil
             }
    end

    # test "renders errors when data is invalid", %{conn: conn, contract: contract} do
    #   conn = put conn, contract_path(conn, :update, contract), contract: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      result_conn = delete conn, contract_path(conn, :delete, contract)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, contract_path(conn, :show, contract)
      end
    end
  end

  defp create_contract(_) do
    contract = fixture(:contract)
    {:ok, contract: contract}
  end
end
