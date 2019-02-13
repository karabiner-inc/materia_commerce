defmodule MateriaCommerce.CommercesTest do
  use MateriaCommerce.DataCase

  doctest MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces

  describe "contracts" do
    alias MateriaCommerce.Commerces.Contract

    @valid_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5"}
    @update_attrs %{billing_address: 43, buyer_id: 43, contract_no: "some updated contract_no", contracted_date: "2011-05-18 15:01:01.000000Z", delivery_address: 43, delivery_end_datetime: "2011-05-18 15:01:01.000000Z", delivery_start_datetime: "2011-05-18 15:01:01.000000Z", end_datetime: "2011-05-18 15:01:01.000000Z", expiration_date: "2011-05-18 15:01:01.000000Z", lock_version: 43, seller_id: 43, sender_address: 43, settlement: "some updated settlement", shipping_fee: "456.7", start_datetime: "2011-05-18 15:01:01.000000Z", status: 1, tax_amount: "456.7", total_amount: "456.7"}
    @invalid_attrs %{billing_address: nil, buyer_id: nil, contract_no: nil, contracted_date: nil, delivery_address: nil, delivery_end_datetime: nil, delivery_start_datetime: nil, end_datetime: nil, expiration_date: nil, lock_version: nil, seller_id: nil, sender_address: nil, settlement: nil, shipping_fee: nil, start_datetime: nil, status: nil, tax_amount: nil, total_amount: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_contract()

      contract
    end

    test "list_contracts/0 returns all contracts" do
      contract = contract_fixture()
      assert Commerces.list_contracts() |> Enum.any?(fn(x) -> x == contract end)
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
      assert Commerces.get_contract!(contract.id) == contract
    end

    test "get_current_contract_history/2 get status2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_current_contract_history(base_datetime, keywords)
      assert result.status == 2
    end

    test "delete_future_contract_histories/2 delete status3" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      {result, _} = MateriaCommerce.Commerces.delete_future_contract_histories(base_datetime, keywords)
      contracts = MateriaCommerce.Commerces.list_contracts()
      assert result == 1
      assert !Enum.any?(contracts, fn(contract)-> contract.status == 3 end)
    end

    test "get_recent_contract_history/2 no result" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result == nil
    end

    test "get_recent_contract_history/2 boundary values" do
      keywords = [{:contract_no, "0000-0000-0000"}]

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 3

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 3
    end

    test "create_new_contract_history/4 error parameters lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => nil,
        "total_amount" => 9999,
        "status" => 4,
      }
      assert_raise(KeyError, fn -> MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, keywords, attr) end)
    end

    test "create_new_contract_history/4 error different lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => nil,
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 99,
      }
      assert_raise(KeyError, fn -> MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, keywords, attr) end)
    end

    test "create_new_contract_history/4 create data all delete" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0,
      }
      {:ok, create_contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, keywords, attr)
      contracts = MateriaCommerce.Commerces.list_contracts() |> Enum.filter(fn(x) -> x.contract_no == "0000-0000-0000" end)
      contract = contracts |> Enum.filter(fn(x) -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"
      assert contract.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00.000000Z], "Etc/UTC")
      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
      assert Enum.count(contracts) == 1
    end

    test "create_new_contract_history/4 latest update" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0,
      }
      {:ok, create_contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, keywords, attr)
      contracts = MateriaCommerce.Commerces.list_contracts() |> Enum.filter(fn(x) -> x.contract_no == "0000-0000-0000" end)
      contract = contracts |> Enum.filter(fn(x) -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"
      assert contract.start_datetime == DateTime.from_naive!(~N[2019-01-01 09:00:00.000000Z], "Etc/UTC")
      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
    end

    test "create_new_contract_history/4 create latest history data" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0,
      }
      {:ok, create_contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, keywords, attr)
      contracts = MateriaCommerce.Commerces.list_contracts() |> Enum.filter(fn(x) -> x.contract_no == "0000-0000-0000" end)
      contract = contracts |> Enum.filter(fn(x) -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"
      assert contract.start_datetime == DateTime.from_naive!(~N[2019-01-02 09:00:00.000000Z], "Etc/UTC")
      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
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
      assert contract.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.expiration_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.lock_version == 42
      assert contract.seller_id == 42
      assert contract.sender_address == 42
      assert contract.settlement == "some settlement"
      assert contract.shipping_fee == Decimal.new("120.5")
      assert contract.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract.status == 0
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
      assert contract.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.expiration_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.lock_version == 43
      assert contract.seller_id == 43
      assert contract.sender_address == 43
      assert contract.settlement == "some updated settlement"
      assert contract.shipping_fee == Decimal.new("456.7")
      assert contract.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract.status == 1
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
  end

  describe "contract_details" do
    alias MateriaCommerce.Commerces.ContractDetail

    @valid_attrs %{amount: 42, category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", contract_name: "some contract_name", contract_no: "some contract_no", delivery_area: "some delivery_area", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", lock_version: 42, manufacturer: "some manufacturer", merchandise_cost: "120.5", model_number: "some model_number", name: "some name", price: "120.5", purchase_amount: "120.5", size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", start_datetime: "2010-04-17 14:00:00.000000Z", tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4"}
    @update_attrs %{amount: 43, category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", contract_name: "some updated contract_name", contract_no: "some updated contract_no", delivery_area: "some updated delivery_area", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", lock_version: 43, manufacturer: "some updated manufacturer", merchandise_cost: "456.7", model_number: "some updated model_number", name: "some updated name", price: "456.7", purchase_amount: "456.7", size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", start_datetime: "2011-05-18 15:01:01.000000Z", tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4"}
    @invalid_attrs %{amount: nil, category1: nil, category2: nil, category3: nil, category4: nil, color: nil, contract_name: nil, contract_no: nil, delivery_area: nil, description: nil, end_datetime: nil, image_url: nil, item_code: nil, jan_code: nil, lock_version: nil, manufacturer: nil, merchandise_cost: nil, model_number: nil, name: nil, price: nil, purchase_amount: nil, size1: nil, size2: nil, size3: nil, size4: nil, start_datetime: nil, tax_category: nil, thumbnail: nil, weight1: nil, weight2: nil, weight3: nil, weight4: nil}

    def contract_detail_fixture(attrs \\ %{}) do
      {:ok, contract_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_contract_detail()

      contract_detail
    end

    test "list_contract_details/0 returns all contract_details" do
      contract_detail = contract_detail_fixture()
      assert Commerces.list_contract_details() != []
    end

    test "get_contract_detail!/1 returns the contract_detail with given id" do
      contract_detail = contract_detail_fixture()
      assert Commerces.get_contract_detail!(contract_detail.id) == contract_detail
    end

    test "get_current_contract_detail_history/2 get status2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_current_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 2

      result
      |> Enum.map(
           fn x ->
             assert x.contract_no == "0000-0000-0000"
             assert x.start_datetime == DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
             cond do
               x.amount == 2 ->
                 assert x.amount == 2
                 assert x.price == Decimal.new(200)
                 assert x.category1 == "Multiple Details:1"
                 assert x.item_code == nil
               x.amount == 3 ->
                 assert x.amount == 3
                 assert x.price == Decimal.new(300)
                 assert x.category1 == "Multiple Details:2 With Item"
                 assert x.item_code == "ICZ1000"
             end
           end
         )
    end

    test "delete_future_contract_detail_histories/2 delete status3" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      {result, _} = MateriaCommerce.Commerces.delete_future_contract_detail_histories(base_datetime, keywords)
      details = MateriaCommerce.Commerces.list_contract_details()
                |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)
      assert result == 2
      assert Enum.count(details) == 3

      details
      |> Enum.map(
           fn x ->
             assert x.contract_no == "0000-0000-0000"
             cond do
               x.amount == 1 ->
                 assert x.amount == 1
                 assert x.price == Decimal.new(100)
                 assert x.category1 == "Single Detail"
                 assert x.item_code == nil
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2018-12-01 08:59:59.000000Z], "Etc/UTC")
               x.amount == 2 ->
                 assert x.amount == 2
                 assert x.price == Decimal.new(200)
                 assert x.category1 == "Multiple Details:1"
                 assert x.item_code == nil
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
               x.amount == 3 ->
                 assert x.amount == 3
                 assert x.price == Decimal.new(300)
                 assert x.category1 == "Multiple Details:2 With Item"
                 assert x.item_code == "ICZ1000"
                 assert x.start_datetime == DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")
                 assert x.end_datetime == DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
             end
           end
         )
    end

    test "get_recent_contract_detail_history/2 no result" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 0
    end

    test "get_recent_contract_detail_history/2 boundary values" do
      keywords = [{:contract_no, "0000-0000-0000"}]

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 1
      assert Enum.any?(result, fn x -> x.amount == 1 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 1
      assert Enum.any?(result, fn x -> x.amount == 1 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 2 end)
      assert Enum.any?(result, fn x -> x.amount == 3 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 2 end)
      assert Enum.any?(result, fn x -> x.amount == 3 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 4 end)
      assert Enum.any?(result, fn x -> x.amount == 5 end)

      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")
      result = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 4 end)
      assert Enum.any?(result, fn x -> x.amount == 5 end)
    end

    test "create_new_contract_detail_history/4 error parameters lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST3",
          "id" => 3,
          #"lock_version" => 0,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1"
        }
      ]
      assert_raise(KeyError, fn -> MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, keywords, attrs) end)
    end

    test "create_new_contract_detail_history/4 error different lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST3",
          "id" => 3,
          "lock_version" => 1,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1"
        }
      ]
      assert_raise(KeyError, fn -> MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, keywords, attrs) end)
    end

    test "create_new_contract_detail_history/4 create data all delete" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST2",
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST3",
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1"
        }
      ]
      {:ok, result} = MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, keywords, attrs)
      assert Enum.count(result) == 3
      result
      |> Enum.map(
           fn x ->
             assert x.contract_no == "0000-0000-0000"
             assert x.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
           end
         )

      details = MateriaCommerce.Commerces.list_contract_details()
                |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)
      assert Enum.count(details) == 3
    end

    test "create_new_contract_detail_history/4 latest update" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0,
          "price" => 2000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST3",
          "id" => 3,
          "lock_version" => 0,
          "price" => 3000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000,
        }
      ]
      {:ok, result} = MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, keywords, attrs)
      assert Enum.count(result) == 3
      result
      |> Enum.map(
           fn x ->
             assert x.contract_no == "0000-0000-0000"
             assert x.start_datetime == DateTime.from_naive!(~N[2019-01-01 09:00:00Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
             cond do
               x.amount == 2 ->
                 assert x.price == Decimal.new("2000")
               x.amount == 3 ->
                 assert x.price == Decimal.new("3000")
               x.amount == 1 ->
                 assert x.price == Decimal.new("1000")
             end
           end
         )
      details = MateriaCommerce.Commerces.list_contract_details()
                |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)
      assert Enum.count(details) == 6
    end

    test "create_new_contract_detail_history/4 create latest history data" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST4",
          "id" => 4,
          "lock_version" => 0,
          "price" => 4000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST5",
          "id" => 5,
          "lock_version" => 0,
          "price" => 5000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000,
        }
      ]
      {:ok, result} = MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, keywords, attrs)
      assert Enum.count(result) == 3
      result
      |> Enum.map(
           fn x ->
             assert x.contract_no == "0000-0000-0000"
             assert x.start_datetime == DateTime.from_naive!(~N[2019-01-02 09:00:00Z], "Etc/UTC")
             assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
             cond do
               x.amount == 4 ->
                 assert x.price == Decimal.new("4000")
               x.amount == 5 ->
                 assert x.price == Decimal.new("5000")
               x.amount == 1 ->
                 assert x.price == Decimal.new("1000")
             end
           end
         )
      details = MateriaCommerce.Commerces.list_contract_details()
                |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)
      assert Enum.count(details) == 8
    end

    test "check_recent_contract_detail/3" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")
      keywords = [{:contract_no, "0000-0000-0000"}]
      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST4",
          "id" => 4,
          "lock_version" => 0,
          "price" => 4000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST5",
          "id" => 5,
          "lock_version" => 0,
          "price" => 5000,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000,
        }
      ]

      recent = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)
      assert MateriaCommerce.Commerces.check_recent_contract_detail(recent, 4, 0)
      assert MateriaCommerce.Commerces.check_recent_contract_detail(recent, 5, 0)
      assert !MateriaCommerce.Commerces.check_recent_contract_detail(recent, 4, 1)
      assert !MateriaCommerce.Commerces.check_recent_contract_detail(recent, 5, 1)
    end

    test "create_contract_detail/1 with valid data creates a contract_detail" do
      assert {:ok, %ContractDetail{} = contract_detail} = Commerces.create_contract_detail(@valid_attrs)
      assert contract_detail.amount == 42
      assert contract_detail.category1 == "some category1"
      assert contract_detail.category2 == "some category2"
      assert contract_detail.category3 == "some category3"
      assert contract_detail.category4 == "some category4"
      assert contract_detail.color == "some color"
      assert contract_detail.contract_name == "some contract_name"
      assert contract_detail.contract_no == "some contract_no"
      assert contract_detail.delivery_area == "some delivery_area"
      assert contract_detail.description == "some description"
      assert contract_detail.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert contract_detail.image_url == "some image_url"
      assert contract_detail.item_code == "some item_code"
      assert contract_detail.jan_code == "some jan_code"
      assert contract_detail.lock_version == 42
      assert contract_detail.manufacturer == "some manufacturer"
      assert contract_detail.merchandise_cost == Decimal.new("120.5")
      assert contract_detail.model_number == "some model_number"
      assert contract_detail.name == "some name"
      assert contract_detail.price == Decimal.new("120.5")
      assert contract_detail.purchase_amount == Decimal.new("120.5")
      assert contract_detail.size1 == "some size1"
      assert contract_detail.size2 == "some size2"
      assert contract_detail.size3 == "some size3"
      assert contract_detail.size4 == "some size4"
      assert contract_detail.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
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
      assert contract_detail.contract_no == "some updated contract_no"
      assert contract_detail.delivery_area == "some updated delivery_area"
      assert contract_detail.description == "some updated description"
      assert contract_detail.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract_detail.image_url == "some updated image_url"
      assert contract_detail.item_code == "some updated item_code"
      assert contract_detail.jan_code == "some updated jan_code"
      assert contract_detail.lock_version == 43
      assert contract_detail.manufacturer == "some updated manufacturer"
      assert contract_detail.merchandise_cost == Decimal.new("456.7")
      assert contract_detail.model_number == "some updated model_number"
      assert contract_detail.name == "some updated name"
      assert contract_detail.price == Decimal.new("456.7")
      assert contract_detail.purchase_amount == Decimal.new("456.7")
      assert contract_detail.size1 == "some updated size1"
      assert contract_detail.size2 == "some updated size2"
      assert contract_detail.size3 == "some updated size3"
      assert contract_detail.size4 == "some updated size4"
      assert contract_detail.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert contract_detail.tax_category == "some updated tax_category"
      assert contract_detail.thumbnail == "some updated thumbnail"
      assert contract_detail.weight1 == "some updated weight1"
      assert contract_detail.weight2 == "some updated weight2"
      assert contract_detail.weight3 == "some updated weight3"
      assert contract_detail.weight4 == "some updated weight4"
    end

    test "update_contract_detail/2 with invalid data returns error changeset" do
      contract_detail = contract_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Commerces.update_contract_detail(contract_detail, @invalid_attrs)
      assert contract_detail == Commerces.get_contract_detail!(contract_detail.id)
    end

    test "delete_contract_detail/1 deletes the contract_detail" do
      contract_detail = contract_detail_fixture()
      assert {:ok, %ContractDetail{}} = Commerces.delete_contract_detail(contract_detail)
      assert_raise Ecto.NoResultsError, fn -> Commerces.get_contract_detail!(contract_detail.id) end
    end

  end
end
