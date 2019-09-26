defmodule MateriaCommerce.CommercesTest do
  use MateriaCommerce.DataCase

  doctest MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces

  @repo Application.get_env(:materia, :repo)

  describe "contracts" do
    alias MateriaCommerce.Commerces.Contract

    @valid_attrs %{billing_address: 42, buyer_id: 42, contract_no: "some contract_no", contracted_date: "2010-04-17 14:00:00.000000Z", delivery_address: 42, delivery_end_datetime: "2010-04-17 14:00:00.000000Z", delivery_start_datetime: "2010-04-17 14:00:00.000000Z", end_datetime: "2010-04-17 14:00:00.000000Z", expiration_date: "2010-04-17 14:00:00.000000Z", lock_version: 42, seller_id: 42, sender_address: 42, settlement: "some settlement", shipping_fee: "120.5", start_datetime: "2010-04-17 14:00:00.000000Z", status: 0, tax_amount: "120.5", total_amount: "120.5", inserted_id: 1, delivery_id: 1,total_size: 9.99, total_weight: 99.99, total_count: 999.99, billing_amount: 9999.99, other_fee: 99999.99, contract_name: "contract_name", description: "description", note1: "note1", note2: "note2", note3: "note3", note4: "note4"}
    @update_attrs %{billing_address: 43, buyer_id: 43, contract_no: "some updated contract_no", contracted_date: "2011-05-18 15:01:01.000000Z", delivery_address: 43, delivery_end_datetime: "2011-05-18 15:01:01.000000Z", delivery_start_datetime: "2011-05-18 15:01:01.000000Z", end_datetime: "2011-05-18 15:01:01.000000Z", expiration_date: "2011-05-18 15:01:01.000000Z", lock_version: 43, seller_id: 43, sender_address: 43, settlement: "some updated settlement", shipping_fee: "456.7", start_datetime: "2011-05-18 15:01:01.000000Z", status: 1, tax_amount: "456.7", total_amount: "456.7", inserted_id: 1, delivery_id: 2,total_size: 9.88, total_weight: 99.88, total_count: 999.88, billing_amount: 9999.88, other_fee: 99999.88, contract_name: "update contract_name", description: "update description", note1: "update note1", note2: "update note2", note3: "update note3", note4: "update note4"}
    @invalid_attrs %{billing_address: nil, buyer_id: nil, contract_no: nil, contracted_date: nil, delivery_address: nil, delivery_end_datetime: nil, delivery_start_datetime: nil, end_datetime: nil, expiration_date: nil, lock_version: nil, seller_id: nil, sender_address: nil, settlement: nil, shipping_fee: nil, start_datetime: nil, status: nil, tax_amount: nil, total_amount: nil, inserted_id: nil, delivery_id: nil, total_size: nil, total_weight: nil, total_count: nil, billing_amount: nil, other_fee: nil, contract_name: nil, description: nil, note1: nil, note2: nil, note3: nil, note4: nil}

    def contract_fixture(attrs \\ %{}) do
      {:ok, contract} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_contract()

      contract
    end

    test "search_my_current_contracts/2" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
    end

    test "get_contract!/1 returns the contract with given id" do
      contract = contract_fixture()
                 |> @repo.preload([:buyer, :seller, :inserted])
                 |> @repo.preload(
                      delivery: [
                        snd_user: [:addresses],
                        rcv_user: [:addresses],
                        clt_user: [:addresses],
                        inserted: [],
                        updated: [],
                      ]
                    )
      assert Commerces.get_contract!(contract.id) == contract
    end

    test "get_current_contract_history/2 get status2" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_current_contract_history(base_datetime, keywords)
      assert result.status == 2
    end

    test "delete_future_contract_histories/2 delete status3" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      {result, _} =
        MateriaCommerce.Commerces.delete_future_contract_histories(base_datetime, keywords)

      contracts = MateriaCommerce.Commerces.list_contracts()
      assert result == 1
      assert !Enum.any?(contracts, fn contract -> contract.status == 3 end)
    end

    test "get_recent_contract_history/2 no result" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]
      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result == nil
    end

    test "get_recent_contract_history/2 boundary values" do
      keywords = [{:contract_no, "0000-0000-0000"}]

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 3

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, keywords)
      assert result.status == 3
    end

    test "create_new_contract_history/4 error parameters lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => nil,
        "total_amount" => 9999,
        "status" => 4
      }

      assert_raise(KeyError, fn ->
        MateriaCommerce.Commerces.create_new_contract_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )
      end)
    end

    test "create_new_contract_history/4 error different lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => nil,
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 99
      }

      assert_raise(Ecto.StaleEntryError, fn ->
        MateriaCommerce.Commerces.create_new_contract_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )
      end)
    end

    test "create_new_contract_history/4 create data all delete" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0
      }

      {:ok, create_contract} =
        MateriaCommerce.Commerces.create_new_contract_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )

      contracts =
        MateriaCommerce.Commerces.list_contracts()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      contract = contracts |> Enum.filter(fn x -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"

      assert contract.start_datetime ==
               DateTime.from_naive!(~N[2017-11-17 09:00:00.000000Z], "Etc/UTC")

      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
      assert Enum.count(contracts) == 1
    end

    test "create_new_contract_history/4 latest update" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0
      }

      {:ok, create_contract} =
        MateriaCommerce.Commerces.create_new_contract_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )

      contracts =
        MateriaCommerce.Commerces.list_contracts()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      contract = contracts |> Enum.filter(fn x -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"

      assert contract.start_datetime ==
               DateTime.from_naive!(~N[2019-01-01 09:00:00.000000Z], "Etc/UTC")

      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
    end

    test "create_new_contract_history/4 create latest history data" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attr = %{
        "contract_no" => "0000-0000-0000",
        "settlement" => "1234-5678-9012",
        "total_amount" => 9999,
        "status" => 4,
        "lock_version" => 0
      }

      {:ok, create_contract} =
        MateriaCommerce.Commerces.create_new_contract_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )

      contracts =
        MateriaCommerce.Commerces.list_contracts()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      contract = contracts |> Enum.filter(fn x -> x.id == create_contract.id end) |> Enum.at(0)
      assert contract.id == create_contract.id
      assert contract.contract_no == "0000-0000-0000"
      assert contract.settlement == "1234-5678-9012"

      assert contract.start_datetime ==
               DateTime.from_naive!(~N[2019-01-02 09:00:00.000000Z], "Etc/UTC")

      assert contract.total_amount == Decimal.new(9999)
      assert contract.status == 4
    end

    test "create_contract/1 with valid data creates a contract" do
      assert {:ok, %Contract{} = contract} = Commerces.create_contract(@valid_attrs)
      assert contract.billing_address == 42
      assert contract.buyer_id == 42
      assert contract.contract_no == "some contract_no"

      assert contract.contracted_date ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert contract.delivery_address == 42

      assert contract.delivery_end_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert contract.delivery_start_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert contract.end_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert contract.expiration_date ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert contract.lock_version == 42
      assert contract.seller_id == 42
      assert contract.sender_address == 42
      assert contract.settlement == "some settlement"
      assert contract.shipping_fee == Decimal.new("120.5")

      assert contract.start_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

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

      assert contract.contracted_date ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.delivery_address == 43

      assert contract.delivery_end_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.delivery_start_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.end_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.expiration_date ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.lock_version == 43
      assert contract.seller_id == 43
      assert contract.sender_address == 43
      assert contract.settlement == "some updated settlement"
      assert contract.shipping_fee == Decimal.new("456.7")

      assert contract.start_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract.status == 1
      assert contract.tax_amount == Decimal.new("456.7")
      assert contract.total_amount == Decimal.new("456.7")
    end

    # test "update_contract/2 with invalid data returns error changeset" do
    #  contract = contract_fixture() |> @repo.preload(:inserted)
    #  assert {:error, %Ecto.Changeset{}} = Commerces.update_contract(contract, @invalid_attrs)
    #  assert contract == Commerces.get_contract!(contract.id)
    # end

    test "delete_contract/1 deletes the contract" do
      contract = contract_fixture()
                 |> @repo.preload(:inserted)
                 |> @repo.preload(
                      delivery: [
                        snd_user: [:addresses],
                        rcv_user: [:addresses],
                        clt_user: [:addresses],
                        inserted: [],
                        updated: [],
                      ]
                    )
      assert {:ok, %Contract{}} = Commerces.delete_contract(contract)
      assert_raise Ecto.NoResultsError, fn -> Commerces.get_contract!(contract.id) end
    end
  end

  describe "contract_details" do
    alias MateriaCommerce.Commerces.ContractDetail

    @valid_attrs %{contract_detail_no: "some contract_detail_no", amount: 42, category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", contract_name: "some contract_name", contract_no: "some contract_no", delivery_area: "some delivery_area", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", lock_version: 42, manufacturer: "some manufacturer", merchandise_cost: "120.5", model_number: "some model_number", name: "some name", price: "120.5", purchase_amount: "120.5", size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", start_datetime: "2010-04-17 14:00:00.000000Z", tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4", inserted_id: 1, delivery_id: 2}
    @update_attrs %{contract_detail_no: "some updated contract_detail_no", amount: 43, category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", contract_name: "some updated contract_name", contract_no: "some updated contract_no", delivery_area: "some updated delivery_area", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", lock_version: 43, manufacturer: "some updated manufacturer", merchandise_cost: "456.7", model_number: "some updated model_number", name: "some updated name", price: "456.7", purchase_amount: "456.7", size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", start_datetime: "2011-05-18 15:01:01.000000Z", tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4", inserted_id: 1, delivery_id: 1}

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
                        |> @repo.preload(:inserted)
                        |> @repo.preload(
                             delivery: [
                               snd_user: [:addresses],
                               rcv_user: [:addresses],
                               clt_user: [:addresses],
                               inserted: [],
                               updated: [],
                             ]
                           )
      assert Commerces.get_contract_detail!(contract_detail.id) == contract_detail
    end

    test "get_current_contract_detail_history/2 get status2" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      result =
        MateriaCommerce.Commerces.get_current_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 2

      result
      |> Enum.map(fn x ->
        assert x.contract_no == "0000-0000-0000"

        assert x.start_datetime ==
                 DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")

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
      end)
    end

    test "delete_future_contract_detail_histories/2 delete status3" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      {result, _} =
        MateriaCommerce.Commerces.delete_future_contract_detail_histories(base_datetime, keywords)

      details =
        MateriaCommerce.Commerces.list_contract_details()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      assert result == 2
      assert Enum.count(details) == 3

      details
      |> Enum.map(fn x ->
        assert x.contract_no == "0000-0000-0000"

        cond do
          x.amount == 1 ->
            assert x.amount == 1
            assert x.price == Decimal.new(100)
            assert x.category1 == "Single Detail"
            assert x.item_code == nil

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2018-12-01 08:59:59.000000Z], "Etc/UTC")

          x.amount == 2 ->
            assert x.amount == 2
            assert x.price == Decimal.new(200)
            assert x.category1 == "Multiple Details:1"
            assert x.item_code == nil

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")

          x.amount == 3 ->
            assert x.amount == 3
            assert x.price == Decimal.new(300)
            assert x.category1 == "Multiple Details:2 With Item"
            assert x.item_code == "ICZ1000"

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-12-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
        end
      end)
    end

    test "get_recent_contract_detail_history/2 no result" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 0
    end

    test "get_recent_contract_detail_history/2 boundary values" do
      keywords = [{:contract_no, "0000-0000-0000"}]

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 1
      assert Enum.any?(result, fn x -> x.amount == 1 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 1
      assert Enum.any?(result, fn x -> x.amount == 1 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 2 end)
      assert Enum.any?(result, fn x -> x.amount == 3 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 2 end)
      assert Enum.any?(result, fn x -> x.amount == 3 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 4 end)
      assert Enum.any?(result, fn x -> x.amount == 5 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")

      result =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.amount == 4 end)
      assert Enum.any?(result, fn x -> x.amount == 5 end)
    end

    test "create_new_contract_detail_history/4 error parameters lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST3",
          "id" => 3
          # "lock_version" => 0,
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_name" => "TEST1"
        }
      ]

      assert_raise(KeyError, fn ->
        MateriaCommerce.Commerces.create_new_contract_detail_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )
      end)
    end

    test "create_new_contract_detail_history/4 error different lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-02",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-03",
          "contract_name" => "TEST3",
          "id" => 3,
          "lock_version" => 1
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-01",
          "contract_name" => "TEST1"
        }
      ]

      assert_raise(Ecto.StaleEntryError, fn ->
        MateriaCommerce.Commerces.create_new_contract_detail_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )
      end)
    end

    test "create_new_contract_detail_history/4 create data all delete" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-02",
          "contract_name" => "TEST2"
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-03",
          "contract_name" => "TEST3"
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-01",
          "contract_name" => "TEST1"
        }
      ]

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_contract_detail_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
        assert x.contract_no == "0000-0000-0000"
        assert x.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00Z], "Etc/UTC")
        assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
      end)

      details =
        MateriaCommerce.Commerces.list_contract_details()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      assert Enum.count(details) == 3
    end

    test "create_new_contract_detail_history/4 latest update" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-02",
          "contract_name" => "TEST2",
          "id" => 2,
          "lock_version" => 0,
          "price" => 2000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-03",
          "contract_name" => "TEST3",
          "id" => 3,
          "lock_version" => 0,
          "price" => 3000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-01",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000
        }
      ]

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_contract_detail_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
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
      end)

      details =
        MateriaCommerce.Commerces.list_contract_details()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      assert Enum.count(details) == 6
    end

    test "create_new_contract_detail_history/4 create latest history data" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-04",
          "contract_name" => "TEST4",
          "id" => 4,
          "lock_version" => 0,
          "price" => 4000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-05",
          "contract_name" => "TEST5",
          "id" => 5,
          "lock_version" => 0,
          "price" => 5000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-01",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000
        }
      ]

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_contract_detail_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
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
      end)

      details =
        MateriaCommerce.Commerces.list_contract_details()
        |> Enum.filter(fn x -> x.contract_no == "0000-0000-0000" end)

      assert Enum.count(details) == 8
    end

    test "check_recent_contract_detail/3" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")

      keywords = [{:contract_no, "0000-0000-0000"}]

      attrs = [
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-04",
          "contract_name" => "TEST4",
          "id" => 4,
          "lock_version" => 0,
          "price" => 4000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-05",
          "contract_name" => "TEST5",
          "id" => 5,
          "lock_version" => 0,
          "price" => 5000
        },
        %{
          "contract_no" => "0000-0000-0000",
          "contract_detail_no" => "0000-0000-0000-01",
          "contract_name" => "TEST1",
          "amount" => 1,
          "price" => 1000
        }
      ]

      recent =
        MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, keywords)

      assert MateriaCommerce.Commerces.check_recent_contract_detail(recent, 4, 0)
      assert MateriaCommerce.Commerces.check_recent_contract_detail(recent, 5, 0)
      assert !MateriaCommerce.Commerces.check_recent_contract_detail(recent, 4, 1)
      assert !MateriaCommerce.Commerces.check_recent_contract_detail(recent, 5, 1)
    end

    test "create_contract_detail/1 with valid data creates a contract_detail" do
      assert {:ok, %ContractDetail{} = contract_detail} =
               Commerces.create_contract_detail(@valid_attrs)

      assert contract_detail.amount == 42
      assert contract_detail.category1 == "some category1"
      assert contract_detail.category2 == "some category2"
      assert contract_detail.category3 == "some category3"
      assert contract_detail.category4 == "some category4"
      assert contract_detail.color == "some color"
      assert contract_detail.contract_name == "some contract_name"
      assert contract_detail.contract_no == "some contract_no"
      assert contract_detail.contract_detail_no == "some contract_detail_no"
      assert contract_detail.delivery_area == "some delivery_area"
      assert contract_detail.description == "some description"

      assert contract_detail.end_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

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

      assert contract_detail.start_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

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

      assert {:ok, contract_detail} =
               Commerces.update_contract_detail(contract_detail, @update_attrs)

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

      assert contract_detail.end_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

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

      assert contract_detail.start_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert contract_detail.tax_category == "some updated tax_category"
      assert contract_detail.thumbnail == "some updated thumbnail"
      assert contract_detail.weight1 == "some updated weight1"
      assert contract_detail.weight2 == "some updated weight2"
      assert contract_detail.weight3 == "some updated weight3"
      assert contract_detail.weight4 == "some updated weight4"
    end

    test "delete_contract_detail/1 deletes the contract_detail" do
      contract_detail = contract_detail_fixture()
                        |> @repo.preload(:inserted)
                        |> @repo.preload(
                             delivery: [
                               snd_user: [:addresses],
                               rcv_user: [:addresses],
                               clt_user: [:addresses],
                               inserted: [],
                               updated: [],
                             ]
                           )
      assert {:ok, %ContractDetail{}} = Commerces.delete_contract_detail(contract_detail)

      assert_raise Ecto.NoResultsError, fn ->
        Commerces.get_contract_detail!(contract_detail.id)
      end
    end
  end

  describe "requests" do
    alias MateriaCommerce.Commerces.Request

    @valid_attrs %{
      accuracy: "some accuracy",
      description: "some description",
      end_datetime: "2010-04-17 14:00:00.000000Z",
      lock_version: 42,
      note1: "some note1",
      note2: "some note2",
      note3: "some note3",
      note4: "some note4",
      request_date1: "2010-04-17 14:00:00.000000Z",
      request_date2: "2010-04-17 14:00:00.000000Z",
      request_date3: "2010-04-17 14:00:00.000000Z",
      request_date4: "2010-04-17 14:00:00.000000Z",
      request_date5: "2010-04-17 14:00:00.000000Z",
      request_date6: "2010-04-17 14:00:00.000000Z",
      request_key1: "some request_key1",
      request_key2: "some request_key2",
      request_key3: "some request_key3",
      request_key4: "some request_key4",
      request_key5: "some request_key5",
      request_name: "some request_name",
      request_number: "some request_number",
      quantity1: 42,
      quantity2: 42,
      quantity3: 42,
      quantity4: 42,
      quantity5: 42,
      quantity6: 42,
      start_datetime: "2010-04-17 14:00:00.000000Z",
      status: 42,
      inserted_id: 1
    }
    @update_attrs %{
      accuracy: "some updated accuracy",
      description: "some updated description",
      end_datetime: "2011-05-18 15:01:01.000000Z",
      lock_version: 43,
      note1: "some updated note1",
      note2: "some updated note2",
      note3: "some updated note3",
      note4: "some updated note4",
      request_date1: "2011-05-18 15:01:01.000000Z",
      request_date2: "2011-05-18 15:01:01.000000Z",
      request_date3: "2011-05-18 15:01:01.000000Z",
      request_date4: "2011-05-18 15:01:01.000000Z",
      request_date5: "2011-05-18 15:01:01.000000Z",
      request_date6: "2011-05-18 15:01:01.000000Z",
      request_key1: "some updated request_key1",
      request_key2: "some updated request_key2",
      request_key3: "some updated request_key3",
      request_key4: "some updated request_key4",
      request_key5: "some updated request_key5",
      request_name: "some updated request_name",
      request_number: "some updated request_number",
      quantity1: 43,
      quantity2: 43,
      quantity3: 43,
      quantity4: 43,
      quantity5: 43,
      quantity6: 43,
      start_datetime: "2011-05-18 15:01:01.000000Z",
      status: 43,
      inserted_id: 2
    }
    @invalid_attrs %{
      accuracy: nil,
      description: nil,
      end_datetime: nil,
      lock_version: nil,
      note1: nil,
      note2: nil,
      note3: nil,
      note4: nil,
      request_date1: nil,
      request_date2: nil,
      request_date3: nil,
      request_date4: nil,
      request_date5: nil,
      request_date6: nil,
      request_key1: nil,
      request_key2: nil,
      request_key3: nil,
      request_key4: nil,
      request_key5: nil,
      request_name: nil,
      request_number: nil,
      quantity1: nil,
      quantity2: nil,
      quantity3: nil,
      quantity4: nil,
      quantity5: nil,
      quantity6: nil,
      start_datetime: nil,
      status: nil,
      inserted_id: nil
    }

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()

      assert Commerces.list_requests()
             |> Enum.filter(fn p -> p.id == request.id end)
             |> Enum.map(fn x ->
               x
               |> Map.delete(:user)
               |> Map.delete(:inserted)
             end)
             |> List.first() ==
               request
               |> Map.delete(:user)
               |> Map.delete(:inserted)
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()

      assert Commerces.get_request!(request.id)
             |> Map.delete(:inserted)
             |> Map.delete(:user) ==
               request
               |> Map.delete(:inserted)
               |> Map.delete(:user)
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Commerces.create_request(@valid_attrs)
      assert request.accuracy == "some accuracy"
      assert request.description == "some description"

      assert request.end_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.lock_version == 42
      assert request.note1 == "some note1"
      assert request.note2 == "some note2"
      assert request.note3 == "some note3"
      assert request.note4 == "some note4"

      assert request.request_date1 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_date2 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_date3 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_date4 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_date5 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_date6 ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.request_key1 == "some request_key1"
      assert request.request_key2 == "some request_key2"
      assert request.request_key3 == "some request_key3"
      assert request.request_key4 == "some request_key4"
      assert request.request_key5 == "some request_key5"
      assert request.request_name == "some request_name"
      assert request.request_number == "some request_number"
      assert request.quantity1 == 42
      assert request.quantity2 == 42
      assert request.quantity3 == 42
      assert request.quantity4 == 42
      assert request.quantity5 == 42
      assert request.quantity6 == 42

      assert request.start_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request.status == 42
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commerces.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, request} = Commerces.update_request(request, @update_attrs)
      assert %Request{} = request
      assert request.accuracy == "some updated accuracy"
      assert request.description == "some updated description"

      assert request.end_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.lock_version == 43
      assert request.note1 == "some updated note1"
      assert request.note2 == "some updated note2"
      assert request.note3 == "some updated note3"
      assert request.note4 == "some updated note4"

      assert request.request_date1 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_date2 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_date3 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_date4 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_date5 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_date6 ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.request_key1 == "some updated request_key1"
      assert request.request_key2 == "some updated request_key2"
      assert request.request_key3 == "some updated request_key3"
      assert request.request_key4 == "some updated request_key4"
      assert request.request_key5 == "some updated request_key5"
      assert request.request_name == "some updated request_name"
      assert request.request_number == "some updated request_number"
      assert request.quantity1 == 43
      assert request.quantity2 == 43
      assert request.quantity3 == 43
      assert request.quantity4 == 43
      assert request.quantity5 == 43
      assert request.quantity6 == 43

      assert request.start_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request.status == 43
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Commerces.update_request(request, @invalid_attrs)

      assert request
             |> Map.delete(:inserted)
             |> Map.delete(:user) ==
               Commerces.get_request!(request.id)
               |> Map.delete(:inserted)
               |> Map.delete(:user)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Commerces.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Commerces.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Commerces.change_request(request)
    end

    test "get_current_request_history/2 " do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]
      result = MateriaCommerce.Commerces.get_current_request_history(base_datetime, keywords)
      assert result.request_number == "PJ-01"
      assert result.status == 1
    end

    test "delete_future_request_histories/2 delete status2" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      {result, _} =
        MateriaCommerce.Commerces.delete_future_request_histories(base_datetime, keywords)

      lists = MateriaCommerce.Commerces.list_requests()
      assert result == 1
      assert !Enum.any?(lists, fn list -> list.status == 2 end)
    end

    test "get_recent_request_history/2 no result" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]
      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result == nil
    end

    test "get_recent_request_history/2 boundary values" do
      keywords = [{:request_number, "PJ-01"}]

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 0

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 0

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 1

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 2

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")

      result = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
      assert result.status == 2
    end

    test "create_new_request_history/5 error parameters lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attr = %{
        "request_number" => "PJ-01",
        "status" => 4
      }

      assert_raise(KeyError, fn ->
        MateriaCommerce.Commerces.create_new_request_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )
      end)
    end

    test "create_new_request_history/5 error different lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attr = %{
        "request_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 99
      }

      assert_raise(Ecto.StaleEntryError, fn ->
        MateriaCommerce.Commerces.create_new_request_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )
      end)
    end

    test "create_new_request_history/5 create data all delete" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attr = %{
        "request_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 2
      }

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_request_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )

      lists =
        MateriaCommerce.Commerces.list_requests()
        |> Enum.filter(fn x -> x.request_number == "PJ-01" end)

      list = lists |> Enum.filter(fn x -> x.id == result.id end) |> Enum.at(0)
      assert list.id == result.id
      assert list.request_number == "PJ-01"
      assert list.status == 4

      assert list.start_datetime ==
               DateTime.from_naive!(~N[2017-11-17 09:00:00.000000Z], "Etc/UTC")

      assert list.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59.000000Z], "Etc/UTC")
      assert Enum.count(lists) == 1
    end

    test "create_new_request_history/5 create latest history data" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attr = %{
        "request_number" => "PJ-01",
        "status" => 4,
        "lock_version" => 2
      }

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_request_history(
          %{},
          base_datetime,
          keywords,
          attr,
          1
        )

      lists =
        MateriaCommerce.Commerces.list_requests()
        |> Enum.filter(fn x -> x.request_number == "PJ-01" end)

      list = lists |> Enum.filter(fn x -> x.id == result.id end) |> Enum.at(0)
      assert list.id == result.id
      assert list.request_number == "PJ-01"
      assert list.status == 4

      assert list.start_datetime ==
               DateTime.from_naive!(~N[2019-01-02 09:00:00.000000Z], "Etc/UTC")

      assert list.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59.000000Z], "Etc/UTC")
    end
  end

  describe "request_appendices" do
    alias MateriaCommerce.Commerces.RequestAppendix

    @valid_attrs %{
      appendix_category: "some appendix_category",
      appendix_date: "2010-04-17 14:00:00.000000Z",
      appendix_description: "some appendix_description",
      appendix_name: "some appendix_name",
      appendix_number: "120.5",
      appendix_status: 42,
      end_datetime: "2010-04-17 14:00:00.000000Z",
      lock_version: 42,
      request_key1: "some request_key1",
      request_key2: "some request_key2",
      request_key3: "some request_key3",
      request_key4: "some request_key4",
      request_key5: "some request_key5",
      request_number: "some request_number",
      start_datetime: "2010-04-17 14:00:00.000000Z",
      inserted_id: 1
    }
    @update_attrs %{
      appendix_category: "some updated appendix_category",
      appendix_date: "2011-05-18 15:01:01.000000Z",
      appendix_description: "some updated appendix_description",
      appendix_name: "some updated appendix_name",
      appendix_number: "456.7",
      appendix_status: 43,
      end_datetime: "2011-05-18 15:01:01.000000Z",
      lock_version: 43,
      request_key1: "some updated request_key1",
      request_key2: "some updated request_key2",
      request_key3: "some updated request_key3",
      request_key4: "some updated request_key4",
      request_key5: "some updated request_key5",
      request_number: "some updated request_number",
      start_datetime: "2011-05-18 15:01:01.000000Z",
      inserted_id: 2
    }
    @invalid_attrs %{
      appendix_category: nil,
      appendix_date: nil,
      appendix_description: nil,
      appendix_name: nil,
      appendix_number: nil,
      appendix_status: nil,
      end_datetime: nil,
      lock_version: nil,
      request_key1: nil,
      request_key2: nil,
      request_key3: nil,
      request_key4: nil,
      request_number: nil,
      start_datetime: nil,
      inserted_id: nil
    }

    def request_appendix_fixture(attrs \\ %{}) do
      {:ok, request_appendix} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Commerces.create_request_appendix()

      request_appendix
    end

    test "list_request_appendices/0 returns all request_appendices" do
      request_appendix = request_appendix_fixture()

      assert Commerces.list_request_appendices()
             |> Enum.filter(fn appendix -> appendix.id == request_appendix.id end)
             |> List.first()
             |> Map.delete(:inserted) ==
               request_appendix
               |> Map.delete(:inserted)
    end

    test "get_request_appendix!/1 returns the request_appendix with given id" do
      request_appendix = request_appendix_fixture()

      assert Commerces.get_request_appendix!(request_appendix.id)
             |> Map.delete(:inserted) ==
               request_appendix
               |> Map.delete(:inserted)
    end

    test "create_request_appendix/1 with valid data creates a request_appendix" do
      assert {:ok, %RequestAppendix{} = request_appendix} =
               Commerces.create_request_appendix(@valid_attrs)

      assert request_appendix.appendix_category == "some appendix_category"

      assert request_appendix.appendix_date ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request_appendix.appendix_description == "some appendix_description"
      assert request_appendix.appendix_name == "some appendix_name"
      assert request_appendix.appendix_number == Decimal.new("120.5")
      assert request_appendix.appendix_status == 42

      assert request_appendix.end_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")

      assert request_appendix.lock_version == 42
      assert request_appendix.request_key1 == "some request_key1"
      assert request_appendix.request_key2 == "some request_key2"
      assert request_appendix.request_key3 == "some request_key3"
      assert request_appendix.request_key4 == "some request_key4"
      assert request_appendix.request_key5 == "some request_key5"
      assert request_appendix.request_number == "some request_number"

      assert request_appendix.start_datetime ==
               DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_request_appendix/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Commerces.create_request_appendix(@invalid_attrs)
    end

    test "update_request_appendix/2 with valid data updates the request_appendix" do
      request_appendix = request_appendix_fixture()

      assert {:ok, request_appendix} =
               Commerces.update_request_appendix(request_appendix, @update_attrs)

      assert %RequestAppendix{} = request_appendix
      assert request_appendix.appendix_category == "some updated appendix_category"

      assert request_appendix.appendix_date ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request_appendix.appendix_description == "some updated appendix_description"
      assert request_appendix.appendix_name == "some updated appendix_name"
      assert request_appendix.appendix_number == Decimal.new("456.7")
      assert request_appendix.appendix_status == 43

      assert request_appendix.end_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")

      assert request_appendix.lock_version == 43
      assert request_appendix.request_key1 == "some updated request_key1"
      assert request_appendix.request_key2 == "some updated request_key2"
      assert request_appendix.request_key3 == "some updated request_key3"
      assert request_appendix.request_key4 == "some updated request_key4"
      assert request_appendix.request_key5 == "some updated request_key5"
      assert request_appendix.request_number == "some updated request_number"

      assert request_appendix.start_datetime ==
               DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_request_appendix/2 with invalid data returns error changeset" do
      request_appendix = request_appendix_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Commerces.update_request_appendix(request_appendix, @invalid_attrs)

      assert request_appendix
             |> Map.delete(:inserted) ==
               Commerces.get_request_appendix!(request_appendix.id)
               |> Map.delete(:inserted)
    end

    test "delete_request_appendix/1 deletes the request_appendix" do
      request_appendix = request_appendix_fixture()
      assert {:ok, %RequestAppendix{}} = Commerces.delete_request_appendix(request_appendix)

      assert_raise Ecto.NoResultsError, fn ->
        Commerces.get_request_appendix!(request_appendix.id)
      end
    end

    test "change_request_appendix/1 returns a request_appendix changeset" do
      request_appendix = request_appendix_fixture()
      assert %Ecto.Changeset{} = Commerces.change_request_appendix(request_appendix)
    end

    test "get_current_request_appendix_history/2 get status2" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      result =
        MateriaCommerce.Commerces.get_current_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
        assert x.request_number == "PJ-01"

        cond do
          x.appendix_category == "Category1" ->
            assert x.appendix_status == 0

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")

          x.appendix_category == "Category2" ->
            assert x.appendix_status == 1

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")

          x.appendix_category == "Category3" ->
            assert x.appendix_status == 2

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
        end
      end)
    end

    test "delete_future_request_appendix_histories/2 delete status3" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      {result, _} =
        MateriaCommerce.Commerces.delete_future_request_appendix_histories(
          base_datetime,
          keywords
        )

      details =
        MateriaCommerce.Commerces.list_request_appendices()
        |> Enum.filter(fn x -> x.request_number == "PJ-01" end)

      assert result == 2
      assert Enum.count(details) == 3

      details
      |> Enum.map(fn x ->
        assert x.request_number == "PJ-01"

        cond do
          x.appendix_category == "Category1" ->
            assert x.appendix_status == 0

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")

          x.appendix_category == "Category2" ->
            assert x.appendix_status == 1

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")

          x.appendix_category == "Category3" ->
            assert x.appendix_status == 2

            assert x.start_datetime ==
                     DateTime.from_naive!(~N[2018-11-01 09:00:00.000000Z], "Etc/UTC")

            assert x.end_datetime ==
                     DateTime.from_naive!(~N[2019-01-01 08:59:59.000000Z], "Etc/UTC")
        end
      end)
    end

    test "get_recent_request_appendix_history/2 no result" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      result =
        MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 0
    end

    test "get_recent_request_appendix_history/2 boundary values" do
      keywords = [{:request_number, "PJ-01"}]

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")

      result =
        MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 3
      assert Enum.any?(result, fn x -> x.appendix_status == 0 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 1 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 2 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      result =
        MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 3
      assert Enum.any?(result, fn x -> x.appendix_status == 0 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 1 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 2 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:01Z")

      result =
        MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.appendix_status == 3 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 4 end)

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-02-01 09:00:00Z")

      result =
        MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)

      assert Enum.count(result) == 2
      assert Enum.any?(result, fn x -> x.appendix_status == 3 end)
      assert Enum.any?(result, fn x -> x.appendix_status == 4 end)
    end

    test "create_new_request_appendix_history/5 error parameters lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      keywords = [{:request_number, "PJ-01"}]

      attrs = [
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "99",
          "id" => 1,
          "lock_version" => 0
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category2",
          "appendix_status" => "99",
          "id" => 2
          # "lock_version" => 1,
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category5"
        }
      ]

      assert_raise(KeyError, fn ->
        MateriaCommerce.Commerces.create_new_request_appendix_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )
      end)
    end

    test "create_new_request_appendix_history/5 error parameters error different lock_version" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:01Z")

      keywords = [{:request_number, "PJ-01"}]

      attrs = [
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "99",
          "id" => 1,
          "lock_version" => 0
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category2",
          "appendix_status" => "99",
          "id" => 2,
          "lock_version" => 99
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category5"
        }
      ]

      assert_raise(Ecto.StaleEntryError, fn ->
        MateriaCommerce.Commerces.create_new_request_appendix_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )
      end)
    end

    test "create_new_request_appendix_history/5 create data all delete" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2017-11-17 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attrs = [
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category90"
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category91"
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category92"
        }
      ]

      {:ok, result} =
        Commerces.create_new_request_appendix_history(%{}, base_datetime, keywords, attrs, 1)

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
        assert x.request_number == "PJ-01"
        assert x.start_datetime == DateTime.from_naive!(~N[2017-11-17 09:00:00Z], "Etc/UTC")
        assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")
      end)

      details =
        MateriaCommerce.Commerces.list_request_appendices()
        |> Enum.filter(fn x -> x.request_number == "PJ-01" end)

      assert Enum.count(details) == 3
    end

    test "create_new_request_appendix_history/5 create latest history data" do
      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-02 09:00:00Z")

      keywords = [{:request_number, "PJ-01"}]

      attrs = [
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category1",
          "appendix_status" => "90",
          "id" => 4,
          "lock_version" => 1
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category4",
          "appendix_status" => "91",
          "id" => 5,
          "lock_version" => 0
        },
        %{
          "request_number" => "PJ-01",
          "appendix_category" => "Category5",
          "appendix_status" => "92"
        }
      ]

      {:ok, result} =
        MateriaCommerce.Commerces.create_new_request_appendix_history(
          %{},
          base_datetime,
          keywords,
          attrs,
          1
        )

      assert Enum.count(result) == 3

      result
      |> Enum.map(fn x ->
        assert x.request_number == "PJ-01"
        assert x.start_datetime == DateTime.from_naive!(~N[2019-01-02 09:00:00Z], "Etc/UTC")
        assert x.end_datetime == DateTime.from_naive!(~N[2999-12-31 23:59:59Z], "Etc/UTC")

        cond do
          x.appendix_category == "Category1" ->
            assert x.appendix_status == 90

          x.appendix_category == "Category4" ->
            assert x.appendix_status == 91

          x.appendix_category == "Category5" ->
            assert x.appendix_status == 92
        end
      end)

      details =
        MateriaCommerce.Commerces.list_request_appendices()
        |> Enum.filter(fn x -> x.request_number == "PJ-01" end)

      assert Enum.count(details) == 8
    end
  end

  describe "expand_search" do
    alias MateriaUtils.Ecto.EctoUtil

    test "get_current_products/2 params and str int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and int datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"and" => [%{"status" => 1}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and str datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params or str int" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"or" => [%{"item_code" => "ICZ1001"}, %{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params or int datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"or" => [%{"status" => 2}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params or str datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"or" => [%{"item_code" => "ICZ2222"}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not str int" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"not" => [%{"item_code" => "ICZ2222"}, %{"status" => 1}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not int datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"not" => [%{"status" => 1}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not str datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 5,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"not" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in str int" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"in" => [%{"item_code" => ["ICZ1111", "ICZ2222"]}, %{"status" => [1, 3]}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params in int datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"in" => [%{"status" => [1, 3]}, %{"start_datetime" => [check_datetime]}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in str datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [
          %{"item_code" => ["ICZ1111", "ICZ2222"]},
          %{"start_datetime" => [check_datetime]}
        ]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params greater str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1010",
        "item_code" => "ICZ3333",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ4444",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      params = %{"greater" => [%{"name" => "炊飯器Z1000"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params greater int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"greater" => [%{"status" => 1}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params greater datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"greater" => [%{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params greater_equal str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1010",
        "item_code" => "ICZ3333",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ4444",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      params = %{"greater_equal" => [%{"name" => "炊飯器Z1000"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5
    end

    test "get_current_products/2 params greater_equal int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"greater_equal" => [%{"status" => 1}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params greater_equal datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"greater_equal" => [%{"start_datetime" => check_datetime}]}

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(check_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params less str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1010",
        "item_code" => "ICZ3333",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ4444",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      params = %{"less" => [%{"name" => "炊飯器Z1000"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params less int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"less" => [%{"status" => 2}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less_equal str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1010",
        "item_code" => "ICZ3333",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ4444",
        "status" => 1,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      params = %{"less_equal" => [%{"name" => "炊飯器Z1000"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params less_equal int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      params = %{"less_equal" => [%{"status" => 2}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params less_equal datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"start_datetime" => check_datetime}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params order_by:asc str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1001",
        "item_code" => "ICZ2222",
        "status" => 3,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ3333",
        "status" => 4,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"name" => "asc"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("name", product.name)

          [t]
        end)

      expect_value = [
        %{"name" => "炊飯器Z"},
        %{"name" => "炊飯器Z1000"},
        %{"name" => "炊飯器Z1000"},
        %{"name" => "炊飯器Z1001"},
        %{"name" => "炊飯器Z1100"}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by:asc int" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"status" => "asc"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 3},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by:asc datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-11 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-21 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"start_datetime" => "asc"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 3},
        %{"status" => 1},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by:desc str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1001",
        "item_code" => "ICZ2222",
        "status" => 3,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1100",
        "item_code" => "ICZ3333",
        "status" => 4,
        "description" => "炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"name" => "desc"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("name", product.name)

          [t]
        end)

      expect_value = [
        %{"name" => "炊飯器Z1100"},
        %{"name" => "炊飯器Z1001"},
        %{"name" => "炊飯器Z1000"},
        %{"name" => "炊飯器Z1000"},
        %{"name" => "炊飯器Z"}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by:desc int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"status" => "desc"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 1},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by:desc datetime" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-11 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-21 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"order_by" => [%{"start_datetime" => "desc"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 1},
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params forward_like str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"forward_like" => [%{"description" => "超"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params forward_like int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 10,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"forward_like" => [%{"status" => 1}]}

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params forward_like datetime" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 12,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 21,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"forward_like" => [%{"status" => "2018"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params backward_like str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器X",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器X",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"backward_like" => [%{"description" => "炊飯器X"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params backward_like int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 10,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"backward_like" => [%{"status" => 1}]}

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params backward_like datetime" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 12,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 21,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"backward_like" => [%{"start_datetime" => "09:00:00"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params like str" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "低級級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"like" => [%{"description" => "高級"}]}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params like int" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 10,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"like" => [%{"status" => 1}]}

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params like datetime" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 11,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 12,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 21,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"like" => [%{"start_datetime" => "11-01"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      assert_raise(Postgrex.Error, fn ->
        MateriaCommerce.Products.get_current_products(base_datetime, params)
      end)
    end

    test "get_current_products/2 params paging 1p" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"paging" => %{"page" => 1, "limit" => 2}}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params paging 2p" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"paging" => %{"page" => 2, "limit" => 2}}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params paging 3p" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"paging" => %{"page" => 3, "limit" => 2}}
      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params miss" do
      alias MateriaCommerce.Products

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "description" => "超高級炊飯器",
        "status" => 2,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "description" => "高級炊飯器",
        "status" => 3,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "description" => "超高級炊飯器",
        "status" => 4,
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, base_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      params = %{"miss" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}]}

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5
    end

    test "get_current_products/2 params and　not1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "not" => [%{"item_code" => "ICZ3333"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params and　not2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "not" => [%{"item_code" => "ICZ3333"}, %{"status" => 1}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params and　or1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "or" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params and　or2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "or" => [%{"item_code" => "ICZ1000"}, %{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params and　in1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "in" => [
          %{"item_code" => ["ICZ1111", "ICZ3333"]},
          %{"start_datetime" => [check_datetime]}
        ]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　in2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 3,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "in" => [%{"item_code" => ["ICZ1111", "ICZ3333"]}, %{"status" => [1, 3]}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　greater1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "greater" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　greater2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "greater" => [%{"item_code" => "ICZ1111"}, %{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　greater_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "greater_equal" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params and　greater_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "greater_equal" => [%{"item_code" => "ICZ1111"}, %{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params and　less1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "less" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params and　less2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "less" => [%{"item_code" => "ICZ1111"}, %{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　less_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "less_equal" => [%{"item_code" => "ICZ1111"}, %{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and　less_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "less_equal" => [%{"item_code" => "ICZ1111"}, %{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params and　order_by1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"status" => 2}],
        "order_by" => [%{"item_code" => "asc"}, %{"start_datetime" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("item_code", product.item_code)

          [t]
        end)

      expect_value = [
        %{"item_code" => "ICZ1111"},
        %{"item_code" => "ICZ2222"},
        %{"item_code" => "ICZ3333"},
        %{"item_code" => "ICZ4444"}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params and order_by2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "order_by" => [%{"item_code" => "asc"}, %{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("item_code", product.item_code)

          [t]
        end)

      expect_value = [
        %{"item_code" => "ICZ1000"},
        %{"item_code" => "ICZ1111"},
        %{"item_code" => "ICZ2222"},
        %{"item_code" => "ICZ3333"}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params and order_by3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [%{"name" => "炊飯器Z1000"}, %{"start_datetime" => check_datetime}],
        "order_by" => [%{"item_code" => "desc"}, %{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("item_code", product.item_code)

          [t]
        end)

      expect_value = [
        %{"item_code" => "ICZ3333"},
        %{"item_code" => "ICZ2222"},
        %{"item_code" => "ICZ1111"},
        %{"item_code" => "ICZ1000"}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params and forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [
          %{"name" => "炊飯器Z1000"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "高級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [
          %{"name" => "炊飯器Z1000"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "backward_like" => [%{"description" => "炊飯器"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [
          %{"name" => "炊飯器Z1000"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "like" => [%{"description" => "高級"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params and paging 1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [
          %{"name" => "炊飯器Z1000"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "paging" => %{"page" => 1, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params and paging 2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "and" => [
          %{"name" => "炊飯器Z1000"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "paging" => %{"page" => 2, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params or not" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "not" => [%{"item_code" => "ICZ1111"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or in" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "in" => [%{"description" => ["高級炊飯器", "超高級炊飯器"]}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or order_by1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "order_by" => [%{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params or order_by2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "order_by" => [%{"start_datetime" => "asc"}, %{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params or order_by3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "order_by" => [%{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params or order_by4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "order_by" => [%{"start_datetime" => "desc"}, %{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params or greater1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "greater" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params or greater2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "greater" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params or greater_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "greater_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or greater_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "greater_equal" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or less1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "less" => [%{"status" => 3}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or less2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "less" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params or less_equal" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "less_equal" => [%{"status" => 3}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5
    end

    test "get_current_products/2 params or less_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "less_equal" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4
    end

    test "get_current_products/2 params or forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params or backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params or like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "like" => [%{"description" => "低級"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params or paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "paging" => %{"page" => 1, "limit" => 3}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params or paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-31 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "or" => [
          %{"item_code" => "ICZ4444"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "paging" => %{"page" => 2, "limit" => 3}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not in" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 1,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 2}
        ],
        "in" => [%{"description" => ["高級炊飯器", "超高級炊飯器"]}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not order_by1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "order_by" => [%{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params not order_by2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "order_by" => [%{"start_datetime" => "asc"}, %{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params not order_by3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "order_by" => [%{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params not order_by4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "order_by" => [%{"start_datetime" => "desc"}, %{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 1},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params not greater1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 4}
        ],
        "greater" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not greater2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, not_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      {:ok, greater_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => not_check_datetime},
          %{"status" => 4}
        ],
        "greater" => [%{"start_datetime" => greater_check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not greater_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 4}
        ],
        "greater_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params not greater_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, not_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      {:ok, greater_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => not_check_datetime},
          %{"status" => 3}
        ],
        "greater_equal" => [%{"start_datetime" => greater_check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params not less1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "less" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not less2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, not_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      {:ok, less_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => not_check_datetime},
          %{"status" => 3}
        ],
        "less" => [%{"start_datetime" => less_check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not less_equal" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "less_equal" => [%{"status" => 3}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params not less_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, not_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      {:ok, less_check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => not_check_datetime},
          %{"status" => 3}
        ],
        "less_equal" => [%{"start_datetime" => less_check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params not like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "like" => [%{"description" => "低級"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params not paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "paging" => %{"page" => 1, "limit" => 3}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params not paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "not" => [
          %{"item_code" => "ICZ1001"},
          %{"start_datetime" => check_datetime},
          %{"status" => 3}
        ],
        "paging" => %{"page" => 2, "limit" => 3}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params in order_by1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "order_by" => [%{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params in order_by2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "in" => [%{"start_datetime" => [check_datetime]}],
        "order_by" => [%{"start_datetime" => "asc"}, %{"status" => "asc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params in order_by3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "order_by" => [%{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params in order_by4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 1,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "in" => [%{"start_datetime" => [check_datetime]}],
        "order_by" => [%{"status" => "desc"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params in greater1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "greater" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params in greater2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "greater" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params in greater_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "greater_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params in greater_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "greater_equal" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in less1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "less" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params in less2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "less" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in less_equal" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 1,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "less_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params in less_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "less_equal" => [%{"start_datetime" => check_datetime}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params in forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params in like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "like" => [%{"description" => "低級"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "paging" => %{"page" => 1, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params in paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "paging" => %{"page" => 2, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params order_by greater1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "greater" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "desc"}], "greater" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"start_datetime" => "asc"}], "greater" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"start_datetime" => "desc"}], "greater" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "greater_equal" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 3},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "desc"}], "greater_equal" => [%{"status" => 2}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 4},
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater_equal3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "order_by" => [%{"start_datetime" => "asc"}],
        "greater_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 4},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by greater_equal4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "order_by" => [%{"start_datetime" => "desc"}],
        "greater_equal" => [%{"status" => 2}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 4}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "less" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "desc"}], "less" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"start_datetime" => "asc"}], "less" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"start_datetime" => "desc"}], "less" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 4

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less_equal1" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "less_equal" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less_equal2" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "desc"}], "less_equal" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less_equal3" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"start_datetime" => "asc"}], "less_equal" => [%{"status" => 3}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 3},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by less_equal4" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 4,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "order_by" => [%{"start_datetime" => "desc"}],
        "less_equal" => [%{"status" => 3}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 5

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 3},
        %{"status" => 2},
        %{"status" => 2},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "高級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "order_by" => [%{"status" => "asc"}],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "order_by" => [%{"status" => "desc"}],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 3},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "in" => [%{"item_code" => ["ICZ1111", "ICZ2222", "ICZ3333"]}],
        "like" => [%{"description" => "低級"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "paging" => %{"page" => 2, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 2}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params order_by paging3p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"order_by" => [%{"status" => "asc"}], "paging" => %{"page" => 3, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2

      order_check =
        current_product
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 2},
        %{"status" => 3}
      ]

      assert expect_value == order_check
    end

    test "get_current_products/2 params greater forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater" => [%{"status" => 2}], "forward_like" => [%{"description" => "超"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params greater_equal forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "greater_equal" => [%{"status" => 2}],
        "forward_like" => [%{"description" => "超"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params less forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"status" => 2}], "forward_like" => [%{"description" => "超"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params less_equal forward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"status" => 2}], "forward_like" => [%{"description" => "超"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 3
    end

    test "get_current_products/2 params greater backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater" => [%{"status" => 2}], "backward_like" => [%{"description" => "炊飯器Z"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params greater_equal backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "greater_equal" => [%{"status" => 2}],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"status" => 2}], "backward_like" => [%{"description" => "炊飯器Z"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params less_equal backward_like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "less_equal" => [%{"status" => 2}],
        "backward_like" => [%{"description" => "炊飯器Z"}]
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params greater like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater" => [%{"status" => 2}], "like" => [%{"description" => "低級"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params greater_equal like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater_equal" => [%{"status" => 2}], "like" => [%{"description" => "低級"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"status" => 2}], "like" => [%{"description" => "低級"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params less_equal like" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "超高級炊飯器Z",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"status" => 2}], "like" => [%{"description" => "低級"}]}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params greater paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater" => [%{"status" => 2}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params greater_equal paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater_equal" => [%{"status" => 2}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params greater_equal paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"greater_equal" => [%{"status" => 2}], "paging" => %{"page" => 2, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"status" => 2}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less" => [%{"status" => 2}], "paging" => %{"page" => 2, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "get_current_products/2 params less_equal paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"status" => 2}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less_equal paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"status" => 2}], "paging" => %{"page" => 2, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params less_equal paging3p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"less_equal" => [%{"status" => 2}], "paging" => %{"page" => 3, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params forward_like paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "forward_like" => [%{"description" => "超"}],
        "paging" => %{"page" => 1, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params forward_like paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "forward_like" => [%{"description" => "超"}],
        "paging" => %{"page" => 2, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params backward_like paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{
        "backward_like" => [%{"description" => "炊飯器Z"}],
        "paging" => %{"page" => 1, "limit" => 2}
      }

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 1
    end

    test "get_current_products/2 params like paging1p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"like" => [%{"description" => "低級"}], "paging" => %{"page" => 1, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 2
    end

    test "get_current_products/2 params like paging2p" do
      alias MateriaCommerce.Products

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超高級炊飯器",
        "inserted_id" => 1
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ2222",
        "status" => 2,
        "description" => "超低級炊飯器Z",
        "inserted_id" => 2
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ2222"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-30 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ3333",
        "status" => 2,
        "description" => "低級炊飯器",
        "inserted_id" => 3
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ3333"}], attr, 1)

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ4444",
        "status" => 3,
        "description" => "高級炊飯器",
        "inserted_id" => 4
      }

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ4444"}], attr, 1)

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")

      params = %{"like" => [%{"description" => "低級"}], "paging" => %{"page" => 2, "limit" => 2}}

      {:ok, base_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-01-01 09:00:00Z")

      current_product = MateriaCommerce.Products.get_current_products(base_datetime, params)
      assert Enum.count(current_product) == 0
    end

    test "select_by_param/3 and" do
      alias MateriaCommerce.Products
      params = %{"and" => [%{"name" => "炊飯器Z1000"}, %{"item_code" => "ICZ1001"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 1
    end

    test "select_by_param/3 not" do
      alias MateriaCommerce.Products

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"not" => [%{"item_code" => "ICZ1001"}, %{"start_datetime" => check_datetime}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 2
    end

    test "select_by_param/3 or" do
      alias MateriaCommerce.Products

      {:ok, check_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      params = %{"or" => [%{"item_code" => "ICZ1001"}, %{"start_datetime" => check_datetime}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 2
    end

    test "select_by_param/3 greater" do
      alias MateriaCommerce.Products
      params = %{"greater" => [%{"status" => 0}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 3
    end

    test "select_by_param/3 greater_equal" do
      alias MateriaCommerce.Products
      params = %{"greater_equal" => [%{"status" => 0}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 4
    end

    test "select_by_param/3 less" do
      alias MateriaCommerce.Products
      params = %{"less" => [%{"status" => 1}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 1
    end

    test "select_by_param/3 less_equal" do
      alias MateriaCommerce.Products
      params = %{"greater_equal" => [%{"status" => 0}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 4
    end

    test "select_by_param/3 order_by:asc" do
      alias MateriaCommerce.Products
      params = %{"order_by" => [%{"status" => "asc"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 4

      order_check =
        products
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 0},
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 1}
      ]

      assert expect_value == order_check
    end

    test "select_by_param/3 order_by:desc" do
      alias MateriaCommerce.Products
      params = %{"order_by" => [%{"status" => "desc"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 4

      order_check =
        products
        |> Enum.flat_map(fn product ->
          t =
            %{}
            |> Map.put("status", product.status)

          [t]
        end)

      expect_value = [
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 1},
        %{"status" => 0}
      ]

      assert expect_value == order_check
    end

    test "select_by_param/3 forward_like" do
      alias MateriaCommerce.Products
      params = %{"forward_like" => [%{"description" => "超"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 2
    end

    test "select_by_param/3 backward_like" do
      alias MateriaCommerce.Products
      params = %{"backward_like" => [%{"item_code" => "01"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 1
    end

    test "select_by_param/3 like" do
      alias MateriaCommerce.Products

      attr = %{
        "name" => "炊飯器Z1000",
        "item_code" => "ICZ1111",
        "status" => 2,
        "description" => "超低級炊飯器",
        "inserted_id" => 1
      }

      {:ok, start_datetime} =
        MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:00Z")

      {:ok, create_price} =
        Products.create_new_item_history(%{}, start_datetime, [{:item_code, "ICZ1111"}], attr, 1)

      params = %{"like" => [%{"description" => "低"}]}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 1
    end

    test "select_by_param/3 paging1p" do
      alias MateriaCommerce.Products
      params = %{"paging" => %{"page" => 1, "limit" => 3}}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 3
    end

    test "select_by_param/3 paging2p" do
      alias MateriaCommerce.Products
      params = %{"paging" => %{"page" => 2, "limit" => 3}}

      products =
        MateriaUtils.Ecto.EctoUtil.select_by_param(@repo, MateriaCommerce.Products.Item, params)

      assert Enum.count(products) == 1
    end
  end
end
