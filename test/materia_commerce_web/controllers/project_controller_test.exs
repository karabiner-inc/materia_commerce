defmodule MateriaCommerceWeb.ProjectControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Projects
  alias MateriaCommerce.Projects.Project

  @create_attrs %{accuracy: "some accuracy", description: "some description", end_datetime: "2010-04-17 14:00:00.000000Z", lock_version: 42, note1: "some note1", note2: "some note2", note3: "some note3", note4: "some note4", project_date1: "2010-04-17 14:00:00.000000Z", project_date2: "2010-04-17 14:00:00.000000Z", project_date3: "2010-04-17 14:00:00.000000Z", project_date4: "2010-04-17 14:00:00.000000Z", project_date5: "2010-04-17 14:00:00.000000Z", project_date6: "2010-04-17 14:00:00.000000Z", project_key1: "some project_key1", project_key2: "some project_key2", project_key3: "some project_key3", project_key4: "some project_key4", project_name: "some project_name", project_number: "some project_number", quantity1: 42, quantity2: 42, quantity3: 42, quantity4: 42, quantity5: 42, quantity6: 42, start_datetime: "2010-04-17 14:00:00.000000Z", status: 42, inserted_id: 1}
  @update_attrs %{accuracy: "some updated accuracy", description: "some updated description", end_datetime: "2011-05-18 15:01:01.000000Z", lock_version: 43, note1: "some updated note1", note2: "some updated note2", note3: "some updated note3", note4: "some updated note4", project_date1: "2011-05-18 15:01:01.000000Z", project_date2: "2011-05-18 15:01:01.000000Z", project_date3: "2011-05-18 15:01:01.000000Z", project_date4: "2011-05-18 15:01:01.000000Z", project_date5: "2011-05-18 15:01:01.000000Z", project_date6: "2011-05-18 15:01:01.000000Z", project_key1: "some updated project_key1", project_key2: "some updated project_key2", project_key3: "some updated project_key3", project_key4: "some updated project_key4", project_name: "some updated project_name", project_number: "some updated project_number", quantity1: 43, quantity2: 43, quantity3: 43, quantity4: 43, quantity5: 43, quantity6: 43, start_datetime: "2011-05-18 15:01:01.000000Z", status: 43, inserted_id: 2}
  @invalid_attrs %{accuracy: nil, description: nil, end_datetime: nil, lock_version: nil, note1: nil, note2: nil, note3: nil, note4: nil, project_date1: nil, project_date2: nil, project_date3: nil, project_date4: nil, project_date5: nil, project_date6: nil, project_key1: nil, project_key2: nil, project_key3: nil, project_key4: nil, project_name: nil, project_number: nil, quantity1: nil, quantity2: nil, quantity3: nil, quantity4: nil, quantity5: nil, quantity6: nil, start_datetime: nil, status: nil, inserted_id: nil}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }

  def fixture(:project) do
    {:ok, project} = Projects.create_project(@create_attrs)
    project
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get conn, project_path(conn, :index)
      assert json_response(conn, 200) == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      result_conn = post conn, project_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, project_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "accuracy" => "some accuracy",
               "description" => "some description",
               "end_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "lock_version" => 42,
               "note1" => "some note1",
               "note2" => "some note2",
               "note3" => "some note3",
               "note4" => "some note4",
               "project_date1" => "2010-04-17T23:00:00.000000+09:00",
               "project_date2" => "2010-04-17T23:00:00.000000+09:00",
               "project_date3" => "2010-04-17T23:00:00.000000+09:00",
               "project_date4" => "2010-04-17T23:00:00.000000+09:00",
               "project_date5" => "2010-04-17T23:00:00.000000+09:00",
               "project_date6" => "2010-04-17T23:00:00.000000+09:00",
               "project_key1" => "some project_key1",
               "project_key2" => "some project_key2",
               "project_key3" => "some project_key3",
               "project_key4" => "some project_key4",
               "project_name" => "some project_name",
               "project_number" => "some project_number",
               "quantity1" => 42,
               "quantity2" => 42,
               "quantity3" => 42,
               "quantity4" => 42,
               "quantity5" => 42,
               "quantity6" => 42,
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "status" => 42,
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "hogehoge@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 1, "lock_version" => 2, "name" => "hogehoge", "organization" => [], "phone_number" => nil, "role" => "admin", "status" => 1}, "project_appendices" => [], "user" => nil
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, project_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      result_conn = put conn, project_path(conn, :update, project), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, project_path(conn, :show, id)
      assert json_response(conn, 200)
             |> Map.delete("inserted_at")
             |> Map.delete("updated_at") == %{
               "id" => id,
               "accuracy" => "some updated accuracy",
               "description" => "some updated description",
               "end_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "lock_version" => 43,
               "note1" => "some updated note1",
               "note2" => "some updated note2",
               "note3" => "some updated note3",
               "note4" => "some updated note4",
               "project_date1" => "2011-05-19T00:01:01.000000+09:00",
               "project_date2" => "2011-05-19T00:01:01.000000+09:00",
               "project_date3" => "2011-05-19T00:01:01.000000+09:00",
               "project_date4" => "2011-05-19T00:01:01.000000+09:00",
               "project_date5" => "2011-05-19T00:01:01.000000+09:00",
               "project_date6" => "2011-05-19T00:01:01.000000+09:00",
               "project_key1" => "some updated project_key1",
               "project_key2" => "some updated project_key2",
               "project_key3" => "some updated project_key3",
               "project_key4" => "some updated project_key4",
               "project_name" => "some updated project_name",
               "project_number" => "some updated project_number",
               "quantity1" => 43,
               "quantity2" => 43,
               "quantity3" => 43,
               "quantity4" => 43,
               "quantity5" => 43,
               "quantity6" => 43,
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "status" => 43,
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "fugafuga@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 2, "lock_version" => 1, "name" => "fugafuga", "organization" => [], "phone_number" => nil, "role" => "operator", "status" => 1}, "project_appendices" => [], "user" => nil
             }
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put conn, project_path(conn, :update, project), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      result_conn = delete conn, project_path(conn, :delete, project)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, project_path(conn, :show, project)
      end
    end
  end

  defp create_project(_) do
    project = fixture(:project)
    {:ok, project: project}
  end
end
