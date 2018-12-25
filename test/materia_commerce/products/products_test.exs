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
      assert Products.list_taxes() == [tax]
    end

    test "get_tax!/1 returns the tax with given id" do
      tax = tax_fixture()
      assert Products.get_tax!(tax.id) == tax
    end

    test "create_tax/1 with valid data creates a tax" do
      assert {:ok, %Tax{} = tax} = Products.create_tax(@valid_attrs)
      assert tax.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert tax.name == "some name"
      assert tax.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert tax.tax_category == "some tax_category"
      assert tax.tax_rate == Decimal.new("120.5")
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
end
