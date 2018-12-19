defmodule MateriaCommerce.ProductsTest do
  use MateriaCommerce.DataCase
  doctest MateriaCommerce.Products

  alias MateriaCommerce.Products

#  describe "items" do
#    alias MateriaCommerce.Products.Item
#
#    @valid_attrs %{category1: "some category1", category2: "some category2", category3: "some category3", category4: "some category4", color: "some color", delivery_area: "some delivery_area", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", image_url: "some image_url", item_code: "some item_code", jan_code: "some jan_code", lock_version: 42, manufacturer: "some manufacturer", model_number: "some model_number", name: "some name", size1: "some size1", size2: "some size2", size3: "some size3", size4: "some size4", start_datetime: "2010-04-17 14:00:00.000000Z", status: "some status", tax_category: "some tax_category", thumbnail: "some thumbnail", weight1: "some weight1", weight2: "some weight2", weight3: "some weight3", weight4: "some weight4"}
#    @update_attrs %{category1: "some updated category1", category2: "some updated category2", category3: "some updated category3", category4: "some updated category4", color: "some updated color", delivery_area: "some updated delivery_area", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", image_url: "some updated image_url", item_code: "some updated item_code", jan_code: "some updated jan_code", lock_version: 43, manufacturer: "some updated manufacturer", model_number: "some updated model_number", name: "some updated name", size1: "some updated size1", size2: "some updated size2", size3: "some updated size3", size4: "some updated size4", start_datetime: "2011-05-18 15:01:01.000000Z", status: "some updated status", tax_category: "some updated tax_category", thumbnail: "some updated thumbnail", weight1: "some updated weight1", weight2: "some updated weight2", weight3: "some updated weight3", weight4: "some updated weight4"}
#    @invalid_attrs %{category1: nil, category2: nil, category3: nil, category4: nil, color: nil, delivery_area: nil, description: nil, end_datetime: nil, image_url: nil, item_code: nil, jan_code: nil, lock_version: nil, manufacturer: nil, model_number: nil, name: nil, size1: nil, size2: nil, size3: nil, size4: nil, start_datetime: nil, status: nil, tax_category: nil, thumbnail: nil, weight1: nil, weight2: nil, weight3: nil, weight4: nil}
#
#    def item_fixture(attrs \\ %{}) do
#      {:ok, item} =
#        attrs
#        |> Enum.into(@valid_attrs)
#        |> Products.create_item()
#
#      item
#    end
#
#    test "list_items/0 returns all items" do
#      item = item_fixture()
#      assert Products.list_items() == [item]
#    end
#
#    test "get_item!/1 returns the item with given id" do
#      item = item_fixture()
#      assert Products.get_item!(item.id) == item
#    end
#
#    test "create_item/1 with valid data creates a item" do
#      assert {:ok, %Item{} = item} = Products.create_item(@valid_attrs)
#      assert item.category1 == "some category1"
#      assert item.category2 == "some category2"
#      assert item.category3 == "some category3"
#      assert item.category4 == "some category4"
#      assert item.color == "some color"
#      assert item.delivery_area == "some delivery_area"
#      assert item.description == "some description"
#      assert item.end_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
#      assert item.image_url == "some image_url"
#      assert item.item_code == "some item_code"
#      assert item.jan_code == "some jan_code"
#      assert item.lock_version == 42
#      assert item.manufacturer == "some manufacturer"
#      assert item.model_number == "some model_number"
#      assert item.name == "some name"
#      assert item.size1 == "some size1"
#      assert item.size2 == "some size2"
#      assert item.size3 == "some size3"
#      assert item.size4 == "some size4"
#      assert item.start_datetime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
#      assert item.status == "some status"
#      assert item.tax_category == "some tax_category"
#      assert item.thumbnail == "some thumbnail"
#      assert item.weight1 == "some weight1"
#      assert item.weight2 == "some weight2"
#      assert item.weight3 == "some weight3"
#      assert item.weight4 == "some weight4"
#    end
#
#    test "create_item/1 with invalid data returns error changeset" do
#      assert {:error, %Ecto.Changeset{}} = Products.create_item(@invalid_attrs)
#    end
#
#    test "update_item/2 with valid data updates the item" do
#      item = item_fixture()
#      assert {:ok, item} = Products.update_item(item, @update_attrs)
#      assert %Item{} = item
#      assert item.category1 == "some updated category1"
#      assert item.category2 == "some updated category2"
#      assert item.category3 == "some updated category3"
#      assert item.category4 == "some updated category4"
#      assert item.color == "some updated color"
#      assert item.delivery_area == "some updated delivery_area"
#      assert item.description == "some updated description"
#      assert item.end_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
#      assert item.image_url == "some updated image_url"
#      assert item.item_code == "some updated item_code"
#      assert item.jan_code == "some updated jan_code"
#      assert item.lock_version == 43
#      assert item.manufacturer == "some updated manufacturer"
#      assert item.model_number == "some updated model_number"
#      assert item.name == "some updated name"
#      assert item.size1 == "some updated size1"
#      assert item.size2 == "some updated size2"
#      assert item.size3 == "some updated size3"
#      assert item.size4 == "some updated size4"
#      assert item.start_datetime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
#      assert item.status == "some updated status"
#      assert item.tax_category == "some updated tax_category"
#      assert item.thumbnail == "some updated thumbnail"
#      assert item.weight1 == "some updated weight1"
#      assert item.weight2 == "some updated weight2"
#      assert item.weight3 == "some updated weight3"
#      assert item.weight4 == "some updated weight4"
#    end
#
#    test "update_item/2 with invalid data returns error changeset" do
#      item = item_fixture()
#      assert {:error, %Ecto.Changeset{}} = Products.update_item(item, @invalid_attrs)
#      assert item == Products.get_item!(item.id)
#    end
#
#    test "delete_item/1 deletes the item" do
#      item = item_fixture()
#      assert {:ok, %Item{}} = Products.delete_item(item)
#      assert_raise Ecto.NoResultsError, fn -> Products.get_item!(item.id) end
#    end
#
#    test "change_item/1 returns a item changeset" do
#      item = item_fixture()
#      assert %Ecto.Changeset{} = Products.change_item(item)
#    end
#  end
end
