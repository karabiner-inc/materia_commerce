defmodule MateriaCommerce.CommercesTest do
  use MateriaCommerce.DataCase

  alias MateriaCommerce.Commerces

  describe "contracts" do
    alias MateriaCommerce.Commerces.Contract

    @valid_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", status: "some status", tax_amount: "120.5", total_amount: "120.5"}
    @update_attrs %{billing_address: 43, buyer_id: 43, contract_no: "some updated contract_no", contracted_date: "2011-05-18 15:01:01.000000Z", delivery_address: 43, delivery_end_datetime: "2011-05-18 15:01:01.000000Z", delivery_start_datetime: "2011-05-18 15:01:01.000000Z", expiration_date: "2011-05-18 15:01:01.000000Z", seller_id: 43, sender_address: 43, settlement: "some updated settlement", shipping_fee: "456.7", status: "some updated status", tax_amount: "456.7", total_amount: "456.7"}
    @invalid_attrs %{billing_address: nil, buyer_id: nil, contract_no: nil, contracted_date: nil, delivery_address: nil, delivery_end_datetime: nil, delivery_start_datetime: nil, expiration_date: nil, seller_id: nil, sender_address: nil, settlement: nil, shipping_fee: nil, status: nil, tax_amount: nil, total_amount: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Commerces.list_contracts() == [contract]
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Commerces.get_contract!(contract.id) == contract
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Commerces.create_contract(@valid_attrs)
      assert contract.billing_address == 42
      assert contract.buyer_id == 42
      assert contract.contract_no == "some contract_no"
      assert contract.contracted_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.delivery_address == 42
      assert contract.delivery_end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.delivery_start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.expiration_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.seller_id == 42
      assert contract.sender_address == 42
      assert contract.settlement == "some settlement"
      assert contract.shipping_fee == Decimal.new("120.5")
      assert contract.status == "some status"
      assert contract.tax_amount == Decimal.new("120.5")
      assert contract.total_amount == Decimal.new("120.5")
    end

    test "create_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commerces.create_contract(@invalid_attrs)
    end

    test "update_contract/2 with valid data updates the contract" do
      contract = contract_fixture()
      assert {:ok, contract} = Commerces.update_contract(contract, @update_attrs)
      assert %Contract{} = contract
      assert contract.billing_address == 43
      assert contract.buyer_id == 43
      assert contract.contract_no == "some updated contract_no"
      assert contract.contracted_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.delivery_address == 43
      assert contract.delivery_end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.delivery_start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.expiration_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.seller_id == 43
      assert contract.sender_address == 43
      assert contract.settlement == "some updated settlement"
      assert contract.shipping_fee == Decimal.new("456.7")
      assert contract.status == "some updated status"
      assert contract.tax_amount == Decimal.new("456.7")
      assert contract.total_amount == Decimal.new("456.7")
    end

    test "update_contract/2 with invalid data returns error changeset" do
      contract = contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Commerces.update_contract(contract, @invalid_attrs)
      assert contract == Commerces.get_contract!(contract.id)
    end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
      assert {:ok, %Contract{}} = Commerces.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Commerces.get_contract!(contract.id) end
    end

    test "change_contract/1 returns a contract changeset" do
      contract = contract_fixture()
      assert %Ecto.Changeset{} = Commerces.change_contract(contract)
    end
  end
end
