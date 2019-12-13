defmodule MateriaCommerceWeb.DeliveryControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Deliveries
  alias MateriaCommerce.Deliveries.Delivery

  @create_attrs %{
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
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin"
  }

  def fixture(:delivery) do
    {:ok, delivery} = Deliveries.create_delivery(%{}, @create_attrs, 1)
    delivery
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post(conn, authenticator_path(conn, :sign_in), @admin_user_attrs)
    %{"access_token" => token} = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all deliveries", %{conn: conn} do
      conn = get(conn, delivery_path(conn, :index))
      assert json_response(conn, 200) != []
    end
  end

  describe "create delivery" do
    test "renders delivery when data is valid", %{conn: conn} do
      result_conn = post(conn, delivery_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get(conn, delivery_path(conn, :show, id))

      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "snd_phone_number" => "some snd_phone_number",
               "rcv_note3" => "some rcv_note3",
               "snd_address2" => "some snd_address2",
               "rcv_address1_p" => "some rcv_address1_p",
               "rcv_note1" => "some rcv_note1",
               "clt_address3_p" => "some clt_address3_p",
               "clt_fax_number" => "some clt_fax_number",
               "rcv_condition2" => "some rcv_condition2",
               "rcv_condition1" => "some rcv_condition1",
               "clt_notation_org_name" => "some clt_notation_org_name",
               "clt_address1" => "some clt_address1",
               "rcv_address2_p" => "some rcv_address2_p",
               "rcv_address3" => "some rcv_address3",
               "snd_address3" => "some snd_address3",
               "snd_condition3" => "some snd_condition3",
               "clt_address2_p" => "some clt_address2_p",
               "snd_address3_p" => "some snd_address3_p",
               "snd_notation_org_name_p" => "some snd_notation_org_name_p",
               "clt_address1_p" => "some clt_address1_p",
               "rcv_address3_p" => "some rcv_address3_p",
               "rcv_fax_number" => "some rcv_fax_number",
               "snd_note3" => "some snd_note3",
               "rcv_condition3" => "some rcv_condition3",
               "rcv_zip_code" => "some rcv_zip_code",
               "rcv_notation_name_p" => "some rcv_notation_name_p",
               "snd_address1" => "some snd_address1",
               "snd_condition1" => "some snd_condition1",
               "rcv_notation_org_name" => "some rcv_notation_org_name",
               "rcv_address1" => "some rcv_address1",
               "clt_phone_number" => "some clt_phone_number",
               "clt_address3" => "some clt_address3",
               "lock_version" => 42,
               "rcv_address2" => "some rcv_address2",
               "rcv_date" => "some rcv_date",
               "snd_note2" => "some snd_note2",
               "rcv_time" => "some rcv_time",
               "snd_notation_name" => "some snd_notation_name",
               "rcv_note2" => "some rcv_note2",
               "clt_notation_org_name_p" => "some clt_notation_org_name_p",
               "snd_fax_number" => "some snd_fax_number",
               "rcv_phone_number" => "some rcv_phone_number",
               "snd_notation_name_p" => "some snd_notation_name_p",
               "snd_zip_code" => "some snd_zip_code",
               "snd_address1_p" => "some snd_address1_p",
               "snd_time" => "some snd_time",
               "rcv_notation_org_name_p" => "some rcv_notation_org_name_p",
               "snd_notation_org_name" => "some snd_notation_org_name",
               "clt_notation_name" => "some clt_notation_name",
               "snd_date" => "some snd_date",
               "clt_address2" => "some clt_address2",
               "snd_condition2" => "some snd_condition2",
               "clt_notation_name_p" => "some clt_notation_name_p",
               "clt_zip_code" => "some clt_zip_code",
               "rcv_notation_name" => "some rcv_notation_name",
               "snd_note1" => "some snd_note1",
               "snd_address2_p" => "some snd_address2_p",
               "status" => 42,
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
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "updated" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "rcv_user" => %{
                 "addresses" => [
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "大名 x-x-xx",
                     "id" => 2,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "billing",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   },
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "港 x-x-xx",
                     "id" => 1,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "living",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   }
                 ],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "clt_user" => %{
                 "addresses" => [
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "大名 x-x-xx",
                     "id" => 2,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "billing",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   },
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "港 x-x-xx",
                     "id" => 1,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "living",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   }
                 ],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "snd_user" => %{
                 "addresses" => [
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "大名 x-x-xx",
                     "id" => 2,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "billing",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   },
                   %{
                     "address1" => "福岡市中央区",
                     "address2" => "港 x-x-xx",
                     "id" => 1,
                     "latitude" => nil,
                     "location" => "福岡県",
                     "lock_version" => 0,
                     "longitude" => nil,
                     "organization" => nil,
                     "subject" => "living",
                     "user" => [],
                     "zip_code" => "810-ZZZZ"
                   }
                 ],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               }
             }
    end
  end

  describe "update delivery" do
    setup [:create_delivery]

    test "renders delivery when data is valid", %{conn: conn, delivery: %Delivery{id: id} = delivery} do
      result_con = put(conn, delivery_path(conn, :update, delivery), @update_attrs)
      assert %{"id" => ^id} = json_response(result_con, 201)

      conn = get(conn, delivery_path(conn, :show, id))

      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "snd_phone_number" => "some updated snd_phone_number",
               "rcv_note3" => "some updated rcv_note3",
               "snd_address2" => "some updated snd_address2",
               "rcv_address1_p" => "some updated rcv_address1_p",
               "rcv_note1" => "some updated rcv_note1",
               "clt_address3_p" => "some updated clt_address3_p",
               "clt_fax_number" => "some updated clt_fax_number",
               "rcv_condition2" => "some updated rcv_condition2",
               "rcv_condition1" => "some updated rcv_condition1",
               "clt_notation_org_name" => "some updated clt_notation_org_name",
               "clt_address1" => "some updated clt_address1",
               "rcv_address2_p" => "some updated rcv_address2_p",
               "rcv_address3" => "some updated rcv_address3",
               "snd_address3" => "some updated snd_address3",
               "snd_condition3" => "some updated snd_condition3",
               "clt_address2_p" => "some updated clt_address2_p",
               "snd_address3_p" => "some updated snd_address3_p",
               "snd_notation_org_name_p" => "some updated snd_notation_org_name_p",
               "clt_address1_p" => "some updated clt_address1_p",
               "rcv_address3_p" => "some updated rcv_address3_p",
               "rcv_fax_number" => "some updated rcv_fax_number",
               "snd_note3" => "some updated snd_note3",
               "rcv_condition3" => "some updated rcv_condition3",
               "rcv_zip_code" => "some updated rcv_zip_code",
               "rcv_notation_name_p" => "some updated rcv_notation_name_p",
               "snd_address1" => "some updated snd_address1",
               "snd_condition1" => "some updated snd_condition1",
               "rcv_notation_org_name" => "some updated rcv_notation_org_name",
               "rcv_address1" => "some updated rcv_address1",
               "clt_phone_number" => "some updated clt_phone_number",
               "clt_address3" => "some updated clt_address3",
               "lock_version" => 43,
               "rcv_address2" => "some updated rcv_address2",
               "rcv_date" => "some updated rcv_date",
               "snd_note2" => "some updated snd_note2",
               "rcv_time" => "some updated rcv_time",
               "snd_notation_name" => "some updated snd_notation_name",
               "rcv_note2" => "some updated rcv_note2",
               "clt_notation_org_name_p" => "some updated clt_notation_org_name_p",
               "snd_fax_number" => "some updated snd_fax_number",
               "rcv_phone_number" => "some updated rcv_phone_number",
               "snd_notation_name_p" => "some updated snd_notation_name_p",
               "snd_zip_code" => "some updated snd_zip_code",
               "snd_address1_p" => "some updated snd_address1_p",
               "snd_time" => "some updated snd_time",
               "rcv_notation_org_name_p" => "some updated rcv_notation_org_name_p",
               "snd_notation_org_name" => "some updated snd_notation_org_name",
               "clt_notation_name" => "some updated clt_notation_name",
               "snd_date" => "some updated snd_date",
               "clt_address2" => "some updated clt_address2",
               "snd_condition2" => "some updated snd_condition2",
               "clt_notation_name_p" => "some updated clt_notation_name_p",
               "clt_zip_code" => "some updated clt_zip_code",
               "rcv_notation_name" => "some updated rcv_notation_name",
               "snd_note1" => "some updated snd_note1",
               "snd_address2_p" => "some updated snd_address2_p",
               "status" => 43,
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
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "updated" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "hogehoge@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 1,
                 "lock_version" => 2,
                 "name" => "hogehoge",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "admin",
                 "status" => 1
               },
               "rcv_user" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "fugafuga@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 2,
                 "lock_version" => 1,
                 "name" => "fugafuga",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "operator",
                 "status" => 1
               },
               "clt_user" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "fugafuga@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 2,
                 "lock_version" => 1,
                 "name" => "fugafuga",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "operator",
                 "status" => 1
               },
               "snd_user" => %{
                 "addresses" => [],
                 "back_ground_img_url" => nil,
                 "descriptions" => nil,
                 "email" => "fugafuga@example.com",
                 "external_user_id" => nil,
                 "icon_img_url" => nil,
                 "id" => 2,
                 "lock_version" => 1,
                 "name" => "fugafuga",
                 "organization" => nil,
                 "phone_number" => nil,
                 "role" => "operator",
                 "status" => 1
               }
             }
    end
  end

  describe "delete delivery" do
    setup [:create_delivery]

    test "deletes chosen delivery", %{conn: conn, delivery: delivery} do
      result_con = delete(conn, delivery_path(conn, :delete, delivery))
      assert response(result_con, 201)
    end
  end

  defp create_delivery(_) do
    delivery = fixture(:delivery)
    {:ok, delivery: delivery}
  end
end
