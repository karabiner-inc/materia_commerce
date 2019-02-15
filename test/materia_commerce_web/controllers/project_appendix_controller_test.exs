defmodule MateriaCommerceWeb.ProjectAppendixControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Projects
  alias MateriaCommerce.Projects.ProjectAppendix

  @create_attrs %{appendix_category: "some appendix_category", appendix_date: "2010-04-17 14:00:00.000000Z", appendix_description: "some appendix_description", appendix_name: "some appendix_name", appendix_number: "120.5", appendix_status: 42, end_datetime: "2010-04-17 14:00:00.000000Z", lock_version: 42, project_key1: "some project_key1", project_key2: "some project_key2", project_key3: "some project_key3", project_key4: "some project_key4", project_number: "some project_number", start_datetime: "2010-04-17 14:00:00.000000Z", inserted_id: 1}
  @update_attrs %{appendix_category: "some updated appendix_category", appendix_date: "2011-05-18 15:01:01.000000Z", appendix_description: "some updated appendix_description", appendix_name: "some updated appendix_name", appendix_number: "456.7", appendix_status: 43, end_datetime: "2011-05-18 15:01:01.000000Z", lock_version: 43, project_key1: "some updated project_key1", project_key2: "some updated project_key2", project_key3: "some updated project_key3", project_key4: "some updated project_key4", project_number: "some updated project_number", start_datetime: "2011-05-18 15:01:01.000000Z", inserted_id: 2}
  @invalid_attrs %{appendix_category: nil, appendix_date: nil, appendix_description: nil, appendix_name: nil, appendix_number: nil, appendix_status: nil, end_datetime: nil, lock_version: nil, project_key1: nil, project_key2: nil, project_key3: nil, project_key4: nil, project_number: nil, start_datetime: nil, inserted_id: nil}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }

  def fixture(:project_appendix) do
    {:ok, project_appendix} = Projects.create_project_appendix(@create_attrs)
    project_appendix
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all project_appendices", %{conn: conn} do
      conn = get conn, project_appendix_path(conn, :index)
      assert json_response(conn, 200) == []
    end
  end

  describe "create project_appendix" do
    test "renders project_appendix when data is valid", %{conn: conn} do
      result_conn = post conn, project_appendix_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, project_appendix_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "appendix_category" => "some appendix_category",
               "appendix_date" => "2010-04-17T23:00:00.000000+09:00",
               "appendix_description" => "some appendix_description",
               "appendix_name" => "some appendix_name",
               "appendix_number" => "120.5",
               "appendix_status" => 42,
               "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "lock_version" => 42,
               "project_key1" => "some project_key1",
               "project_key2" => "some project_key2",
               "project_key3" => "some project_key3",
               "project_key4" => "some project_key4",
               "project_number" => "some project_number",
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "hogehoge@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 1, "lock_version" => 2, "name" => "hogehoge", "organization" => [], "phone_number" => nil, "role" => "admin", "status" => 1}
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, project_appendix_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project_appendix" do
    setup [:create_project_appendix]

    test "renders project_appendix when data is valid", %{conn: conn, project_appendix: %ProjectAppendix{id: id} = project_appendix} do
      result_conn = put conn, project_appendix_path(conn, :update, project_appendix), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, project_appendix_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "appendix_category" => "some updated appendix_category",
               "appendix_date" => "2011-05-19T00:01:01.000000+09:00",
               "appendix_description" => "some updated appendix_description",
               "appendix_name" => "some updated appendix_name",
               "appendix_number" => "456.7",
               "appendix_status" => 43,
               "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "lock_version" => 43,
               "project_key1" => "some updated project_key1",
               "project_key2" => "some updated project_key2",
               "project_key3" => "some updated project_key3",
               "project_key4" => "some updated project_key4",
               "project_number" => "some updated project_number",
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "fugafuga@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 2, "lock_version" => 1, "name" => "fugafuga", "organization" => [], "phone_number" => nil, "role" => "operator", "status" => 1}
             }
    end

    test "renders errors when data is invalid", %{conn: conn, project_appendix: project_appendix} do
      conn = put conn, project_appendix_path(conn, :update, project_appendix), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project_appendix" do
    setup [:create_project_appendix]

    test "deletes chosen project_appendix", %{conn: conn, project_appendix: project_appendix} do
      result_conn = delete conn, project_appendix_path(conn, :delete, project_appendix)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, project_appendix_path(conn, :show, project_appendix)
      end
    end
  end

  defp create_project_appendix(_) do
    project_appendix = fixture(:project_appendix)
    {:ok, project_appendix: project_appendix}
  end
end
