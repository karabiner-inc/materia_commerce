defmodule MateriaCommerceWeb.ContractControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Contract

  @create_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", status: "some status", tax_amount: "120.5", total_amount: "120.5"}
  @update_attrs %{billing_address: 43, buyer_id: 43, contract_no: "some updated contract_no", contracted_date: "2011-05-18 15:01:01.000000Z", delivery_address: 43, delivery_end_datetime: "2011-05-18 15:01:01.000000Z", delivery_start_datetime: "2011-05-18 15:01:01.000000Z", expiration_date: "2011-05-18 15:01:01.000000Z", seller_id: 43, sender_address: 43, settlement: "some updated settlement", shipping_fee: "456.7", status: "some updated status", tax_amount: "456.7", total_amount: "456.7"}
  @invalid_attrs %{billing_address: nil, buyer_id: nil, contract_no: nil, contracted_date: nil, delivery_address: nil, delivery_end_datetime: nil, delivery_start_datetime: nil, expiration_date: nil, seller_id: nil, sender_address: nil, settlement: nil, shipping_fee: nil, status: nil, tax_amount: nil, total_amount: nil}

  def fixture(:contract) do
    {:ok, contract} = Commerces.create_contract(@create_attrs)
    contract
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all contracts", %{conn: conn} do
      conn = get conn, contract_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create contract" do
    test "renders contract when data is valid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "billing_address" => 42,
        "buyer_id" => 42,
        "contract_no" => "some contract_no",
        "contracted_date" => "2010-04-17T14:00:00.000000Z",
        "delivery_address" => 42,
        "delivery_end_datetime" => "2010-04-17T14:00:00.000000Z",
        "delivery_start_datetime" => "2010-04-17T14:00:00.000000Z",
        "expiration_date" => "2010-04-17T14:00:00.000000Z",
        "lock_version" => 0,
        "seller_id" => 42,
        "sender_address" => 42,
        "settlement" => "some settlement",
        "shipping_fee" => "120.5",
        "status" => "some status",
        "tax_amount" => "120.5",
        "total_amount" => "120.5"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, contract_path(conn, :create), contract: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contract" do
    setup [:create_contract]

    test "renders contract when data is valid", %{conn: conn, contract: %Contract{id: id} = contract} do
      conn = put conn, contract_path(conn, :update, contract), contract: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, contract_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "billing_address" => 43,
        "buyer_id" => 43,
        "contract_no" => "some updated contract_no",
        "contracted_date" => "2011-05-18T15:01:01.000000Z",
        "delivery_address" => 43,
        "delivery_end_datetime" => "2011-05-18T15:01:01.000000Z",
        "delivery_start_datetime" => "2011-05-18T15:01:01.000000Z",
        "expiration_date" => "2011-05-18T15:01:01.000000Z",
        "lock_version" => 1,
        "seller_id" => 43,
        "sender_address" => 43,
        "settlement" => "some updated settlement",
        "shipping_fee" => "456.7",
        "status" => "some updated status",
        "tax_amount" => "456.7",
        "total_amount" => "456.7"}
    end

    # test "renders errors when data is invalid", %{conn: conn, contract: contract} do
    #   conn = put conn, contract_path(conn, :update, contract), contract: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete contract" do
    setup [:create_contract]

    test "deletes chosen contract", %{conn: conn, contract: contract} do
      conn = delete conn, contract_path(conn, :delete, contract)
      assert response(conn, 204)
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