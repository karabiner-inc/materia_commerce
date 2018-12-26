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

    # test "update_contract/2 with invalid data returns error changeset" do
    #   contract = contract_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Commerces.update_contract(contract, @invalid_attrs)
    #   assert contract == Commerces.get_contract!(contract.id)
    # end

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

  describe "contract_details" do
    alias MateriaCommerce.Commerces.ContractDetail

    @contract_valid_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", status: "some status", tax_amount: "120.5", total_amount: "120.5"}
    @valid_attrs %{amount: 42, category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", contract_name: "some contract_name", delivery_area: "some delivery_area", description: "some description", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", manufacturer: "some manufacturer", model_number: "some model_number", name: "some name", price: 42, size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4"}
    @update_attrs %{amount: 43, category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", contract_name: "some updated contract_name", delivery_area: "some updated delivery_area", description: "some updated description", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", manufacturer: "some updated manufacturer", model_number: "some updated model_number", name: "some updated name", price: 43, size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4"}
    @invalid_attrs %{amount: nil, category1: nil, category2: nil, category3: nil, category4: nil, color: nil, contract_name: nil, delivery_area: nil, description: nil, image_url: nil, item_code: nil, jan_code: nil, manufacturer: nil, model_number: nil, name: nil, price: nil, size1: nil, size2: nil, size3: nil, size4: nil, tax_category: nil, thumbnail: nil, weight1: nil, weight2: nil, weight3: nil, weight4: nil}

    def contract_detail_fixture(attrs \\ %{}) do
      {:ok, contract} = Commerces.create_contract(@contract_valid_attrs)
      params = Map.put(@valid_attrs, :contract_id, contract.id)
      {:ok, contract_detail} =
        attrs
        |> Enum.into(params)
        |> Commerces.create_contract_detail()

      contract_detail
    end

    test "list_contract_details/0 returns all contract_details" do
      contract_detail = contract_detail_fixture()
      assert Commerces.list_contract_details() == [contract_detail]
    end

    test "get_contract_detail!/1 returns the contract_detail with given id" do
      contract_detail = contract_detail_fixture()
      assert Commerces.get_contract_detail!(contract_detail.id) == contract_detail
    end

    test "create_contract_detail/1 with valid data creates a contract_detail" do
      {:ok, contract} = Commerces.create_contract(@contract_valid_attrs)
      params = Map.put(@valid_attrs, :contract_id, contract.id)
      assert {:ok, %ContractDetail{} = contract_detail} = Commerces.create_contract_detail(params)
      assert contract_detail.amount == 42
      assert contract_detail.category1 == "some category1"
      assert contract_detail.category2 == "some category2"
      assert contract_detail.category3 == "some category3"
      assert contract_detail.category4 == "some category4"
      assert contract_detail.color == "some color"
      assert contract_detail.contract_name == "some contract_name"
      assert contract_detail.delivery_area == "some delivery_area"
      assert contract_detail.description == "some description"
      assert contract_detail.image_url == "some image_url"
      assert contract_detail.item_code == "some item_code"
      assert contract_detail.jan_code == "some jan_code"
      assert contract_detail.lock_version == 0
      assert contract_detail.manufacturer == "some manufacturer"
      assert contract_detail.model_number == "some model_number"
      assert contract_detail.name == "some name"
      assert contract_detail.price == 42
      assert contract_detail.size1 == "some size1"
      assert contract_detail.size2 == "some size2"
      assert contract_detail.size3 == "some size3"
      assert contract_detail.size4 == "some size4"
      assert contract_detail.tax_category == "some tax_category"
      assert contract_detail.thumbnail == "some thumbnail"
      assert contract_detail.weight1 == "some weight1"
      assert contract_detail.weight2 == "some weight2"
      assert contract_detail.weight3 == "some weight3"
      assert contract_detail.weight4 == "some weight4"
    end

    test "create_contract_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commerces.create_contract_detail(@invalid_attrs)
    end

    test "update_contract_detail/2 with valid data updates the contract_detail" do
      contract_detail = contract_detail_fixture()
      assert {:ok, contract_detail} = Commerces.update_contract_detail(contract_detail, @update_attrs)
      assert %ContractDetail{} = contract_detail
      assert contract_detail.amount == 43
      assert contract_detail.category1 == "some updated category1"
      assert contract_detail.category2 == "some updated category2"
      assert contract_detail.category3 == "some updated category3"
      assert contract_detail.category4 == "some updated category4"
      assert contract_detail.color == "some updated color"
      assert contract_detail.contract_name == "some updated contract_name"
      assert contract_detail.delivery_area == "some updated delivery_area"
      assert contract_detail.description == "some updated description"
      assert contract_detail.image_url == "some updated image_url"
      assert contract_detail.item_code == "some updated item_code"
      assert contract_detail.jan_code == "some updated jan_code"
      assert contract_detail.lock_version == 1
      assert contract_detail.manufacturer == "some updated manufacturer"
      assert contract_detail.model_number == "some updated model_number"
      assert contract_detail.name == "some updated name"
      assert contract_detail.price == 43
      assert contract_detail.size1 == "some updated size1"
      assert contract_detail.size2 == "some updated size2"
      assert contract_detail.size3 == "some updated size3"
      assert contract_detail.size4 == "some updated size4"
      assert contract_detail.tax_category == "some updated tax_category"
      assert contract_detail.thumbnail == "some updated thumbnail"
      assert contract_detail.weight1 == "some updated weight1"
      assert contract_detail.weight2 == "some updated weight2"
      assert contract_detail.weight3 == "some updated weight3"
      assert contract_detail.weight4 == "some updated weight4"
    end

    # test "update_contract_detail/2 with invalid data returns error changeset" do
    #   contract_detail = contract_detail_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Commerces.update_contract_detail(contract_detail, @invalid_attrs)
    #   assert contract_detail == Commerces.get_contract_detail!(contract_detail.id)
    # end

    test "delete_contract_detail/1 deletes the contract_detail" do
      contract_detail = contract_detail_fixture()
      assert {:ok, %ContractDetail{}} = Commerces.delete_contract_detail(contract_detail)
      assert_raise Ecto.NoResultsError, fn -> Commerces.get_contract_detail!(contract_detail.id) end
    end

    test "change_contract_detail/1 returns a contract_detail changeset" do
      contract_detail = contract_detail_fixture()
      assert %Ecto.Changeset{} = Commerces.change_contract_detail(contract_detail)
    end
  end
end
