defmodule MateriaCommerce.DeliveriesTest do
  use MateriaCommerce.DataCase
  doctest MateriaCommerce.Deliveries
  alias MateriaCommerce.Deliveries
  @repo Application.get_env(:materia, :repo)

  describe "deliveries" do
    alias MateriaCommerce.Deliveries.Delivery

    @valid_attrs %{
      "snd_zip_code" => "some snd_zip_code",
      "snd_address1" => "some snd_address1",
      "snd_address1_p" => "some snd_address1_p",
      "snd_address2" => "some snd_address2",
      "snd_address2_p" => "some snd_address2_p",
      "snd_address3" => "some snd_address3",
      "snd_address3_p" => "some snd_address3_p",
      "snd_phone_number" => "some snd_phone_number",
      "snd_fax_number" => "some snd_fax_number",
      "snd_notation_org_name" => "some snd_notation_org_name",
      "snd_notation_org_name_p" => "some snd_notation_org_name_p",
      "snd_notation_name" => "some snd_notation_name",
      "snd_notation_name_p" => "some snd_notation_name_p",
      "snd_date" => "some snd_date",
      "snd_time" => "some snd_time",
      "snd_condition1" => "some snd_condition1",
      "snd_condition2" => "some snd_condition2",
      "snd_condition3" => "some snd_condition3",
      "snd_note1" => "some snd_note1",
      "snd_note2" => "some snd_note2",
      "snd_note3" => "some snd_note3",
      "rcv_zip_code" => "some rcv_zip_code",
      "rcv_address1" => "some rcv_address1",
      "rcv_address1_p" => "some rcv_address1_p",
      "rcv_address2" => "some rcv_address2",
      "rcv_address2_p" => "some rcv_address2_p",
      "rcv_address3" => "some rcv_address3",
      "rcv_address3_p" => "some rcv_address3_p",
      "rcv_phone_number" => "some rcv_phone_number",
      "rcv_fax_number" => "some rcv_fax_number",
      "rcv_notation_org_name" => "some rcv_notation_org_name",
      "rcv_notation_org_name_p" => "some rcv_notation_org_name_p",
      "rcv_notation_name" => "some rcv_notation_name",
      "rcv_notation_name_p" => "some rcv_notation_name_p",
      "rcv_date" => "some rcv_date",
      "rcv_time" => "some rcv_time",
      "rcv_condition1" => "some rcv_condition1",
      "rcv_condition2" => "some rcv_condition2",
      "rcv_condition3" => "some rcv_condition3",
      "rcv_note1" => "some rcv_note1",
      "rcv_note2" => "some rcv_note2",
      "rcv_note3" => "some rcv_note3",
      "clt_zip_code" => "some clt_zip_code",
      "clt_address1" => "some clt_address1",
      "clt_address1_p" => "some clt_address1_p",
      "clt_address2" => "some clt_address2",
      "clt_address2_p" => "some clt_address2_p",
      "clt_address3" => "some clt_address3",
      "clt_address3_p" => "some clt_address3_p",
      "clt_phone_number" => "some clt_phone_number",
      "clt_fax_number" => "some clt_fax_number",
      "clt_notation_org_name" => "some clt_notation_org_name",
      "clt_notation_org_name_p" => "some clt_notation_org_name_p",
      "clt_notation_name" => "some clt_notation_name",
      "clt_notation_name_p" => "some clt_notation_name_p",
      "status" => 42,
      "lock_version" => 42,
      "snd_user_id" => 1,
      "rcv_user_id" => 1,
      "clt_user_id" => 1
    }
    @update_attrs %{
      "snd_zip_code" => "some updated snd_zip_code",
      "snd_address1" => "some updated snd_address1",
      "snd_address1_p" => "some updated snd_address1_p",
      "snd_address2" => "some updated snd_address2",
      "snd_address2_p" => "some updated snd_address2_p",
      "snd_address3" => "some updated snd_address3",
      "snd_address3_p" => "some updated snd_address3_p",
      "snd_phone_number" => "some updated snd_phone_number",
      "snd_fax_number" => "some updated snd_fax_number",
      "snd_notation_org_name" => "some updated snd_notation_org_name",
      "snd_notation_org_name_p" => "some updated snd_notation_org_name_p",
      "snd_notation_name" => "some updated snd_notation_name",
      "snd_notation_name_p" => "some updated snd_notation_name_p",
      "snd_date" => "some updated snd_date",
      "snd_time" => "some updated snd_time",
      "snd_condition1" => "some updated snd_condition1",
      "snd_condition2" => "some updated snd_condition2",
      "snd_condition3" => "some updated snd_condition3",
      "snd_note1" => "some updated snd_note1",
      "snd_note2" => "some updated snd_note2",
      "snd_note3" => "some updated snd_note3",
      "rcv_zip_code" => "some updated rcv_zip_code",
      "rcv_address1" => "some updated rcv_address1",
      "rcv_address1_p" => "some updated rcv_address1_p",
      "rcv_address2" => "some updated rcv_address2",
      "rcv_address2_p" => "some updated rcv_address2_p",
      "rcv_address3" => "some updated rcv_address3",
      "rcv_address3_p" => "some updated rcv_address3_p",
      "rcv_phone_number" => "some updated rcv_phone_number",
      "rcv_fax_number" => "some updated rcv_fax_number",
      "rcv_notation_org_name" => "some updated rcv_notation_org_name",
      "rcv_notation_org_name_p" => "some updated rcv_notation_org_name_p",
      "rcv_notation_name" => "some updated rcv_notation_name",
      "rcv_notation_name_p" => "some updated rcv_notation_name_p",
      "rcv_date" => "some updated rcv_date",
      "rcv_time" => "some updated rcv_time",
      "rcv_condition1" => "some updated rcv_condition1",
      "rcv_condition2" => "some updated rcv_condition2",
      "rcv_condition3" => "some updated rcv_condition3",
      "rcv_note1" => "some updated rcv_note1",
      "rcv_note2" => "some updated rcv_note2",
      "rcv_note3" => "some updated rcv_note3",
      "clt_zip_code" => "some updated clt_zip_code",
      "clt_address1" => "some updated clt_address1",
      "clt_address1_p" => "some updated clt_address1_p",
      "clt_address2" => "some updated clt_address2",
      "clt_address2_p" => "some updated clt_address2_p",
      "clt_address3" => "some updated clt_address3",
      "clt_address3_p" => "some updated clt_address3_p",
      "clt_phone_number" => "some updated clt_phone_number",
      "clt_fax_number" => "some updated clt_fax_number",
      "clt_notation_org_name" => "some updated clt_notation_org_name",
      "clt_notation_org_name_p" => "some updated clt_notation_org_name_p",
      "clt_notation_name" => "some updated clt_notation_name",
      "clt_notation_name_p" => "some updated clt_notation_name_p",
      "status" => 43,
      "lock_version" => 42,
      "snd_user_id" => 2,
      "rcv_user_id" => 2,
      "clt_user_id" => 2
    }
    @invalid_attrs %{
      "snd_zip_code" => nil,
      "snd_address1" => nil,
      "snd_address1_p" => nil,
      "snd_address2" => nil,
      "snd_address2_p" => nil,
      "snd_address3" => nil,
      "snd_address3_p" => nil,
      "snd_phone_number" => nil,
      "snd_fax_number" => nil,
      "snd_notation_org_name" => nil,
      "snd_notation_org_name_p" => nil,
      "snd_notation_name" => nil,
      "snd_notation_name_p" => nil,
      "snd_date" => nil,
      "snd_time" => nil,
      "snd_condition1" => nil,
      "snd_condition2" => nil,
      "snd_condition3" => nil,
      "snd_note1" => nil,
      "snd_note2" => nil,
      "snd_note3" => nil,
      "rcv_zip_code" => nil,
      "rcv_address1" => nil,
      "rcv_address1_p" => nil,
      "rcv_address2" => nil,
      "rcv_address2_p" => nil,
      "rcv_address3" => nil,
      "rcv_address3_p" => nil,
      "rcv_phone_number" => nil,
      "rcv_fax_number" => nil,
      "rcv_notation_org_name" => nil,
      "rcv_notation_org_name_p" => nil,
      "rcv_notation_name" => nil,
      "rcv_notation_name_p" => nil,
      "rcv_date" => nil,
      "rcv_time" => nil,
      "rcv_condition1" => nil,
      "rcv_condition2" => nil,
      "rcv_condition3" => nil,
      "rcv_note1" => nil,
      "rcv_note2" => nil,
      "rcv_note3" => nil,
      "clt_zip_code" => nil,
      "clt_address1" => nil,
      "clt_address1_p" => nil,
      "clt_address2" => nil,
      "clt_address2_p" => nil,
      "clt_address3" => nil,
      "clt_address3_p" => nil,
      "clt_phone_number" => nil,
      "clt_fax_number" => nil,
      "clt_notation_org_name" => nil,
      "clt_notation_org_name_p" => nil,
      "clt_notation_name" => nil,
      "clt_notation_name_p" => nil,
      "status" => nil,
      "lock_version" => nil,
      "snd_user_id" => nil,
      "rcv_user_id" => nil,
      "clt_user_id" => nil
    }

    def delivery_fixture(attrs \\ %{}) do
      {:ok, delivery} = Deliveries.create_delivery(%{}, @valid_attrs, 1)
      delivery
    end

    test "list_deliveries/0 returns all deliveries" do
      delivery =
        delivery_fixture()
        |> @repo.preload(
          snd_user: [:addresses],
          rcv_user: [:addresses],
          clt_user: [:addresses],
          inserted: [],
          updated: []
        )

      assert Deliveries.list_deliveries() != []
    end

    test "get_delivery!/1 returns the delivery with given id" do
      delivery =
        delivery_fixture()
        |> @repo.preload(
          snd_user: [:addresses],
          rcv_user: [:addresses],
          clt_user: [:addresses],
          inserted: [],
          updated: []
        )

      assert Deliveries.get_delivery!(delivery.id) == delivery
    end

    test "create_delivery/1 with valid data creates a delivery" do
      assert {:ok, %Delivery{} = delivery} = Deliveries.create_delivery(%{}, @valid_attrs, 1)
      assert delivery.snd_phone_number == "some snd_phone_number"
      assert delivery.rcv_note3 == "some rcv_note3"
      assert delivery.snd_address2 == "some snd_address2"
      assert delivery.rcv_address1_p == "some rcv_address1_p"
      assert delivery.rcv_note1 == "some rcv_note1"
      assert delivery.clt_address3_p == "some clt_address3_p"
      assert delivery.clt_fax_number == "some clt_fax_number"
      assert delivery.rcv_condition2 == "some rcv_condition2"
      assert delivery.rcv_condition1 == "some rcv_condition1"
      assert delivery.clt_notation_org_name == "some clt_notation_org_name"
      assert delivery.clt_address1 == "some clt_address1"
      assert delivery.rcv_address2_p == "some rcv_address2_p"
      assert delivery.rcv_address3 == "some rcv_address3"
      assert delivery.snd_address3 == "some snd_address3"
      assert delivery.snd_condition3 == "some snd_condition3"
      assert delivery.clt_address2_p == "some clt_address2_p"
      assert delivery.snd_address3_p == "some snd_address3_p"
      assert delivery.snd_notation_org_name_p == "some snd_notation_org_name_p"
      assert delivery.clt_address1_p == "some clt_address1_p"
      assert delivery.rcv_address3_p == "some rcv_address3_p"
      assert delivery.rcv_fax_number == "some rcv_fax_number"
      assert delivery.snd_note3 == "some snd_note3"
      assert delivery.rcv_condition3 == "some rcv_condition3"
      assert delivery.rcv_zip_code == "some rcv_zip_code"
      assert delivery.rcv_notation_name_p == "some rcv_notation_name_p"
      assert delivery.snd_address1 == "some snd_address1"
      assert delivery.snd_condition1 == "some snd_condition1"
      assert delivery.rcv_notation_org_name == "some rcv_notation_org_name"
      assert delivery.rcv_address1 == "some rcv_address1"
      assert delivery.clt_phone_number == "some clt_phone_number"
      assert delivery.clt_address3 == "some clt_address3"
      assert delivery.lock_version == 42
      assert delivery.rcv_address2 == "some rcv_address2"
      assert delivery.rcv_date == "some rcv_date"
      assert delivery.snd_note2 == "some snd_note2"
      assert delivery.rcv_time == "some rcv_time"
      assert delivery.snd_notation_name == "some snd_notation_name"
      assert delivery.rcv_note2 == "some rcv_note2"
      assert delivery.clt_notation_org_name_p == "some clt_notation_org_name_p"
      assert delivery.snd_fax_number == "some snd_fax_number"
      assert delivery.rcv_phone_number == "some rcv_phone_number"
      assert delivery.snd_notation_name_p == "some snd_notation_name_p"
      assert delivery.snd_zip_code == "some snd_zip_code"
      assert delivery.snd_address1_p == "some snd_address1_p"
      assert delivery.snd_time == "some snd_time"
      assert delivery.rcv_notation_org_name_p == "some rcv_notation_org_name_p"
      assert delivery.snd_notation_org_name == "some snd_notation_org_name"
      assert delivery.clt_notation_name == "some clt_notation_name"
      assert delivery.snd_date == "some snd_date"
      assert delivery.clt_address2 == "some clt_address2"
      assert delivery.snd_condition2 == "some snd_condition2"
      assert delivery.clt_notation_name_p == "some clt_notation_name_p"
      assert delivery.clt_zip_code == "some clt_zip_code"
      assert delivery.rcv_notation_name == "some rcv_notation_name"
      assert delivery.snd_note1 == "some snd_note1"
      assert delivery.snd_address2_p == "some snd_address2_p"
      assert delivery.status == 42
      assert delivery.snd_user_id == 1
      assert delivery.rcv_user_id == 1
      assert delivery.clt_user_id == 1
      assert delivery.inserted_id == 1
      assert delivery.updated_id == 1
    end

    test "update_delivery/2 with valid data updates the delivery" do
      delivery = delivery_fixture()
      assert {:ok, delivery} = Deliveries.update_delivery(%{}, delivery, @update_attrs, 2)
      assert %Delivery{} = delivery
      assert delivery.snd_phone_number == "some updated snd_phone_number"
      assert delivery.rcv_note3 == "some updated rcv_note3"
      assert delivery.snd_address2 == "some updated snd_address2"
      assert delivery.rcv_address1_p == "some updated rcv_address1_p"
      assert delivery.rcv_note1 == "some updated rcv_note1"
      assert delivery.clt_address3_p == "some updated clt_address3_p"
      assert delivery.clt_fax_number == "some updated clt_fax_number"
      assert delivery.rcv_condition2 == "some updated rcv_condition2"
      assert delivery.rcv_condition1 == "some updated rcv_condition1"
      assert delivery.clt_notation_org_name == "some updated clt_notation_org_name"
      assert delivery.clt_address1 == "some updated clt_address1"
      assert delivery.rcv_address2_p == "some updated rcv_address2_p"
      assert delivery.rcv_address3 == "some updated rcv_address3"
      assert delivery.snd_address3 == "some updated snd_address3"
      assert delivery.snd_condition3 == "some updated snd_condition3"
      assert delivery.clt_address2_p == "some updated clt_address2_p"
      assert delivery.snd_address3_p == "some updated snd_address3_p"
      assert delivery.snd_notation_org_name_p == "some updated snd_notation_org_name_p"
      assert delivery.clt_address1_p == "some updated clt_address1_p"
      assert delivery.rcv_address3_p == "some updated rcv_address3_p"
      assert delivery.rcv_fax_number == "some updated rcv_fax_number"
      assert delivery.snd_note3 == "some updated snd_note3"
      assert delivery.rcv_condition3 == "some updated rcv_condition3"
      assert delivery.rcv_zip_code == "some updated rcv_zip_code"
      assert delivery.rcv_notation_name_p == "some updated rcv_notation_name_p"
      assert delivery.snd_address1 == "some updated snd_address1"
      assert delivery.snd_condition1 == "some updated snd_condition1"
      assert delivery.rcv_notation_org_name == "some updated rcv_notation_org_name"
      assert delivery.rcv_address1 == "some updated rcv_address1"
      assert delivery.clt_phone_number == "some updated clt_phone_number"
      assert delivery.clt_address3 == "some updated clt_address3"
      assert delivery.lock_version == 43
      assert delivery.rcv_address2 == "some updated rcv_address2"
      assert delivery.rcv_date == "some updated rcv_date"
      assert delivery.snd_note2 == "some updated snd_note2"
      assert delivery.rcv_time == "some updated rcv_time"
      assert delivery.snd_notation_name == "some updated snd_notation_name"
      assert delivery.rcv_note2 == "some updated rcv_note2"
      assert delivery.clt_notation_org_name_p == "some updated clt_notation_org_name_p"
      assert delivery.snd_fax_number == "some updated snd_fax_number"
      assert delivery.rcv_phone_number == "some updated rcv_phone_number"
      assert delivery.snd_notation_name_p == "some updated snd_notation_name_p"
      assert delivery.snd_zip_code == "some updated snd_zip_code"
      assert delivery.snd_address1_p == "some updated snd_address1_p"
      assert delivery.snd_time == "some updated snd_time"
      assert delivery.rcv_notation_org_name_p == "some updated rcv_notation_org_name_p"
      assert delivery.snd_notation_org_name == "some updated snd_notation_org_name"
      assert delivery.clt_notation_name == "some updated clt_notation_name"
      assert delivery.snd_date == "some updated snd_date"
      assert delivery.clt_address2 == "some updated clt_address2"
      assert delivery.snd_condition2 == "some updated snd_condition2"
      assert delivery.clt_notation_name_p == "some updated clt_notation_name_p"
      assert delivery.clt_zip_code == "some updated clt_zip_code"
      assert delivery.rcv_notation_name == "some updated rcv_notation_name"
      assert delivery.snd_note1 == "some updated snd_note1"
      assert delivery.snd_address2_p == "some updated snd_address2_p"
      assert delivery.status == 43
      assert delivery.snd_user_id == 2
      assert delivery.rcv_user_id == 2
      assert delivery.clt_user_id == 2
      assert delivery.inserted_id == 1
      assert delivery.updated_id == 2
    end

    test "update_delivery/2 with invalid data returns error changeset" do
      delivery =
        delivery_fixture()
        |> @repo.preload(
          snd_user: [:addresses],
          rcv_user: [:addresses],
          clt_user: [:addresses],
          inserted: [],
          updated: []
        )

      assert {:error, %Ecto.Changeset{}} = Deliveries.update_delivery(%{}, delivery, @invalid_attrs, 1)
      assert delivery == Deliveries.get_delivery!(delivery.id)
    end

    test "delete_delivery/1 deletes the delivery" do
      delivery = delivery_fixture()
      assert {:ok, delivery} = Deliveries.delete_delivery(%{}, delivery, 2)
      assert delivery.status == 9
      assert delivery.inserted_id == 1
      assert delivery.updated_id == 2
    end
  end
end
