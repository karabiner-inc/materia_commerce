defmodule MateriaCommerceWeb.RequestAppendixControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.RequestAppendix

  @create_attrs %{appendix_category: "some appendix_category", appendix_date: "2010-04-17 14:00:00.000000Z", appendix_description: "some appendix_description", appendix_name: "some appendix_name", appendix_number: "120.5", appendix_status: 42, end_datetime: "2010-04-17 14:00:00.000000Z", lock_version: 42, request_key1: "some request_key1", request_key2: "some request_key2", request_key3: "some request_key3", request_key4: "some request_key4", request_number: "some request_number", start_datetime: "2010-04-17 14:00:00.000000Z", inserted_id: 1}
  @update_attrs %{appendix_category: "some updated appendix_category", appendix_date: "2011-05-18 15:01:01.000000Z", appendix_description: "some updated appendix_description", appendix_name: "some updated appendix_name", appendix_number: "456.7", appendix_status: 43, end_datetime: "2011-05-18 15:01:01.000000Z", lock_version: 43, request_key1: "some updated request_key1", request_key2: "some updated request_key2", request_key3: "some updated request_key3", request_key4: "some updated request_key4", request_number: "some updated request_number", start_datetime: "2011-05-18 15:01:01.000000Z", inserted_id: 1}
  @invalid_attrs %{appendix_category: nil, appendix_date: nil, appendix_description: nil, appendix_name: nil, appendix_number: nil, appendix_status: nil, end_datetime: nil, lock_version: nil, request_key1: nil, request_key2: nil, request_key3: nil, request_key4: nil, request_number: nil, start_datetime: nil}
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin",
  }

  def fixture(:request_appendix) do
    {:ok, request_appendix} = Commerces.create_request_appendix(@create_attrs)
    request_appendix
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
    %{"access_token" => token } = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all request_appendices", %{conn: conn} do
      conn = get conn, request_appendix_path(conn, :index)
      assert json_response(conn, 200) != []
    end
  end

  describe "create request_appendix" do
    test "renders request_appendix when data is valid", %{conn: conn} do
      result_conn = post conn, request_appendix_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get conn, request_appendix_path(conn, :show, id)
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
               "request_key1" => "some request_key1",
               "request_key2" => "some request_key2",
               "request_key3" => "some request_key3",
               "request_key4" => "some request_key4",
               "request_number" => "some request_number",
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "hogehoge@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 1, "lock_version" => 2, "name" => "hogehoge", "organization" => [], "phone_number" => nil, "role" => "admin", "status" => 1}
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, request_appendix_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request_appendix" do
    setup [:create_request_appendix]

    test "renders request_appendix when data is valid", %{conn: conn, request_appendix: %RequestAppendix{id: id} = request_appendix} do
      result_conn = put conn, request_appendix_path(conn, :update, request_appendix), @update_attrs
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get conn, request_appendix_path(conn, :show, id)
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
               "request_key1" => "some updated request_key1",
               "request_key2" => "some updated request_key2",
               "request_key3" => "some updated request_key3",
               "request_key4" => "some updated request_key4",
               "request_number" => "some updated request_number",
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
               "inserted" => %{"addresses" => [], "back_ground_img_url" => nil, "descriptions" => nil, "email" => "hogehoge@example.com", "external_user_id" => nil, "icon_img_url" => nil, "id" => 1, "lock_version" => 2, "name" => "hogehoge", "organization" => [], "phone_number" => nil, "role" => "admin", "status" => 1}
             }
    end

    test "renders errors when data is invalid", %{conn: conn, request_appendix: request_appendix} do
      conn = put conn, request_appendix_path(conn, :update, request_appendix), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request_appendix" do
    setup [:create_request_appendix]

    test "deletes chosen request_appendix", %{conn: conn, request_appendix: request_appendix} do
      result_conn = delete conn, request_appendix_path(conn, :delete, request_appendix)
      assert response(result_conn, 204)
      assert_error_sent 404, fn ->
        get conn, request_appendix_path(conn, :show, request_appendix)
      end
    end
  end

  describe "current request_appendix" do
    test "search", %{conn: conn} do
      conn = post conn, request_appendix_path(conn, :search_current_request_appendices),
                  key_words: [%{"request_number" => "PJ-01"}]
      json_response(conn, 200)
      |> Enum.map(
           fn request_appendix ->
             cond do
               request_appendix["appendix_category"] == "Category1" ->
                 assert request_appendix["appendix_number"] == "4"
                 assert request_appendix["appendix_status"] == 3
                 assert request_appendix["start_datetime"] == "2019-01-01T18:00:00.000000+09:00"
                 assert request_appendix["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
               request_appendix["appendix_category"] == "Category4" ->
                 assert request_appendix["appendix_number"] == "5"
                 assert request_appendix["appendix_status"] == 4
                 assert request_appendix["start_datetime"] == "2019-01-01T18:00:00.000000+09:00"
                 assert request_appendix["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
             end
           end
         )
    end

    test "new history", %{conn: conn} do
      create_conn = post conn, request_appendix_path(conn, :current_request_appendices),
                  key_words: [%{"request_number" => "PJ-01"}],
                  params: [
                    %{
                      "request_number" => "PJ-01",
                      "appendix_category" => "Category5",
                      "appendix_number" => "7",
                      "appendix_status" => 6,
                    },
                    %{
                      "request_number" => "PJ-01",
                      "appendix_category" => "Category4",
                      "appendix_number" => "8",
                      "appendix_status" => 7,
                      "id" => 5,
                      "lock_version" => 0,
                    }
                  ]
      conn = post conn, request_appendix_path(conn, :search_current_request_appendices),
                  key_words: [%{"request_number" => "PJ-01"}]

      json_response(conn, 200)
      |> Enum.map(
           fn request_appendix ->
             cond do
               request_appendix["appendix_category"] == "Category4" ->
                 assert request_appendix["appendix_number"] == "8"
                 assert request_appendix["appendix_status"] == 7
                 assert request_appendix["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
               request_appendix["appendix_category"] == "Category5" ->
                 assert request_appendix["appendix_number"] == "7"
                 assert request_appendix["appendix_status"] == 6
                 assert request_appendix["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
             end
           end
         )
    end
  end

  defp create_request_appendix(_) do
    request_appendix = fixture(:request_appendix)
    {:ok, request_appendix: request_appendix}
  end
end
