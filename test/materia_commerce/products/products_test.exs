defmodule MateriaCommerce.ProductsTest do
  use MateriaCommerce.DataCase

  alias MateriaCommerce.Products

  describe "taxes" do
    alias MateriaCommerce.Products.Tax

    @valid_attrs %{end_datetime: "2010-04-17 14:00:00.000000Z", name: "some name", start_datetime: "2010-04-17 14:00:00.000000Z", tax_category: "some tax_category", tax_rate: "120.5"}
    @update_attrs %{end_datetime: "2011-05-18 15:01:01.000000Z", name: "some updated name", start_datetime: "2011-05-18 15:01:01.000000Z", tax_category: "some updated tax_category", tax_rate: "456.7"}
    @invalid_attrs %{end_datetime: nil, lock_version: nil, name: nil, start_datetime: nil, tax_category: nil, tax_rate: nil}

    def tax_fixture(attrs \\ %{}) do
      {:ok, tax} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_tax()
      tax
    end

    test "list_taxes/0 returns all taxes" do
      tax = tax_fixture()
      assert Products.list_taxes() |> Enum.any?(fn(x) -> x == tax end)
    end

    test "get_tax!/1 returns the tax with given id" do
      tax = tax_fixture()
      assert Products.get_tax!(tax.id) == tax
    end

    test "get_current_tax_history/2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      current_tax = MateriaCommerce.Products.get_current_tax_history(base_datetime, [{:tax_category, "category1"}])
      assert current_tax.name == "test2 tax"
    end

    test "get_recent_tax_history/2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
      current_tax = MateriaCommerce.Products.get_recent_tax_history(base_datetime, [{:tax_category, "category1"}])
      assert current_tax.name == "test3 tax"
    end

    test "delete_future_tax_histories/2 delete test3 tax" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      {result, _} = MateriaCommerce.Products.delete_future_tax_histories(base_datetime, [{:tax_category, "category1"}])
      taxes = Products.list_taxes()
      assert result == 1
      assert !Enum.any?(taxes, fn(tax)-> tax.name == "test3 tax" end)
    end

    test "create_tax/1 with valid data creates a tax" do
      assert {:ok, %Tax{} = tax} = Products.create_tax(@valid_attrs)
      assert tax.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert tax.name == "some name"
      assert tax.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert tax.tax_category == "some tax_category"
      assert tax.tax_rate == Decimal.new("120.5")
    end

    test "create_new_tax_history/4 error parameters have not lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      attr =  %{
        "name"=> "test1 tax", 
        "tax_category"=> "category1",
        "tax_rate"=> 0.3,
      }
      assert_raise(KeyError, fn -> Products.create_new_tax_history(%{}, base_datetime, [{:tax_category, "category1"}], attr) end)
    end

    test "create_new_tax_history/4 error different lock_version" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      attr =  %{
        "name"=> "test1 tax", 
        "tax_category"=> "category1",
        "lock_version" => 99,
        "tax_rate"=> 0.3,
      }
      assert_raise(KeyError, fn -> Products.create_new_tax_history(%{}, base_datetime, [{:tax_category, "category1"}], attr) end)
    end

    test "create_new_tax_history/4 create twice new data" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-17 09:00:00Z")
      attr =  %{
        "name"=> "test1 tax", 
        "lock_version"=> 0,
        "tax_category"=> "category1",
        "tax_rate"=> 0.3,
      }
      Products.create_new_tax_history(%{}, base_datetime, [{:tax_category, "category1"}], attr)
      [tax|_] = Products.list_taxes()
      IO.inspect tax
      assert tax.start_datetime == DateTime.from_naive!(~N[2018-11-17 09:00:00.000000Z], "Etc/UTC")
      assert tax.tax_rate == Decimal.new(0.3)
    end

    test "create_tax/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_tax(@invalid_attrs)
    end

    test "update_tax/2 with valid data updates the tax" do
      tax = tax_fixture()
      assert {:ok, tax} = Products.update_tax(tax, @update_attrs)
      assert %Tax{} = tax
      assert tax.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert tax.name == "some updated name"
      assert tax.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert tax.tax_category == "some updated tax_category"
      assert tax.tax_rate == Decimal.new("456.7")
    end

    test "update_tax/2 with invalid data returns error changeset" do
      tax = tax_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_tax(tax, @invalid_attrs)
      assert tax == Products.get_tax!(tax.id)
    end

    test "delete_tax/1 deletes the tax" do
      tax = tax_fixture()
      assert {:ok, %Tax{}} = Products.delete_tax(tax)
      assert_raise Ecto.NoResultsError, fn -> Products.get_tax!(tax.id) end
    end

    test "change_tax/1 returns a tax changeset" do
      tax = tax_fixture()
      assert %Ecto.Changeset{} = Products.change_tax(tax)
    end
  end

  describe "prices" do
    alias MateriaCommerce.Products.Price

    @valid_attrs %{description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", start_datetime: "2010-04-17 14:00:00.000000Z", unit_price: "120.5"}
    @update_attrs %{description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", start_datetime: "2011-05-18 15:01:01.000000Z", unit_price: "456.7"}
    @invalid_attrs %{description: nil, end_datetime: nil, start_datetime: nil, unit_price: nil}

    def price_fixture(attrs \\ %{}) do
      {:ok, price} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_price()

      price
    end

    test "list_prices/0 returns all prices" do
      price = price_fixture()
      assert Products.list_prices() |> Enum.count() > 0
    end

    test "get_price!/1 returns the price with given id" do
      price = price_fixture()
      assert Products.get_price!(price.id) == price
    end

    test "get_current_price_history/2" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      current_price = MateriaCommerce.Products.get_current_price_history(base_datetime, [])
      assert current_price.unit_price == Decimal.new(200)
    end

    # test "get_recent_price_history/2" do
    #   {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
    #   current_tax = MateriaCommerce.Products.get_recent_price_history(base_datetime, [{:tax_category, "category1"}])
    #   assert current_tax.name == "test3 price"
    # end

    test "delete_future_price_histories/2 delete test3 price" do
      {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
      {result, _} = MateriaCommerce.Products.delete_future_price_histories(base_datetime, [])
      prices = Products.list_prices()
      assert result == 1
      assert !Enum.any?(prices, fn(price)-> price.unit_price == 300 end)
    end

    test "create_price/1 with valid data creates a price" do
      assert {:ok, %Price{} = price} = Products.create_price(@valid_attrs)
      assert price.description == "some description"
      assert price.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert price.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert price.unit_price == Decimal.new("120.5")
    end

    test "create_price/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_price(@invalid_attrs)
    end

    test "update_price/2 with valid data updates the price" do
      price = price_fixture()
      assert {:ok, price} = Products.update_price(price, @update_attrs)
      assert %Price{} = price
      assert price.description == "some updated description"
      assert price.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert price.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert price.unit_price == Decimal.new("456.7")
    end

    test "update_price/2 with invalid data returns error changeset" do
      price = price_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_price(price, @invalid_attrs)
      assert price == Products.get_price!(price.id)
    end

    test "delete_price/1 deletes the price" do
      price = price_fixture()
      assert {:ok, %Price{}} = Products.delete_price(price)
      assert_raise Ecto.NoResultsError, fn -> Products.get_price!(price.id) end
    end

    test "change_price/1 returns a price changeset" do
      price = price_fixture()
      assert %Ecto.Changeset{} = Products.change_price(price)
    end
  end
end
