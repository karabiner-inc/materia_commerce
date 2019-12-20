defmodule MateriaCommerceWeb.RequestControllerTest do
  use MateriaCommerceWeb.ConnCase

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Request

  @create_attrs %{
    accuracy: "some accuracy",
    description: "some description",
    end_datetime: "2010-04-17 14:00:00.000000Z",
    lock_version: 42,
    note1: "some note1",
    note2: "some note2",
    note3: "some note3",
    note4: "some note4",
    quantity1: 42,
    quantity2: 42,
    quantity3: 42,
    quantity4: 42,
    quantity5: 42,
    quantity6: 42,
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
    start_datetime: "2010-04-17 14:00:00.000000Z",
    status: 42,
    inserted_id: 1,
    request_relation_number: "some request_relation_number",
    request_abbreviated: "some request_abbreviated"
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
    quantity1: 43,
    quantity2: 43,
    quantity3: 43,
    quantity4: 43,
    quantity5: 43,
    quantity6: 43,
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
    start_datetime: "2011-05-18 15:01:01.000000Z",
    status: 43,
    inserted_id: 1
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
    quantity1: nil,
    quantity2: nil,
    quantity3: nil,
    quantity4: nil,
    quantity5: nil,
    quantity6: nil,
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
    start_datetime: nil,
    status: nil
  }
  @admin_user_attrs %{
    "name" => "hogehoge",
    "email" => "hogehoge@example.com",
    "password" => "hogehoge",
    "role" => "admin"
  }

  def fixture(:request) do
    {:ok, request} = Commerces.create_request(@create_attrs)
    request
  end

  setup %{conn: conn} do
    Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
    conn = put_req_header(conn, "accept", "application/json")
    token_conn = post(conn, authenticator_path(conn, :sign_in), @admin_user_attrs)
    %{"access_token" => token} = json_response(token_conn, 201)
    {:ok, conn: conn = put_req_header(conn, "authorization", "Bearer " <> token)}
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, request_path(conn, :index))
      assert json_response(conn, 200) != []
    end
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      result_conn = post(conn, request_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(result_conn, 201)

      conn = get(conn, request_path(conn, :show, id))

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
               "request_date1" => "2010-04-17T23:00:00.000000+09:00",
               "request_date2" => "2010-04-17T23:00:00.000000+09:00",
               "request_date3" => "2010-04-17T23:00:00.000000+09:00",
               "request_date4" => "2010-04-17T23:00:00.000000+09:00",
               "request_date5" => "2010-04-17T23:00:00.000000+09:00",
               "request_date6" => "2010-04-17T23:00:00.000000+09:00",
               "request_key1" => "some request_key1",
               "request_key2" => "some request_key2",
               "request_key3" => "some request_key3",
               "request_key4" => "some request_key4",
               "request_key5" => "some request_key5",
               "request_name" => "some request_name",
               "request_number" => "some request_number",
               "quantity1" => 42,
               "quantity2" => 42,
               "quantity3" => 42,
               "quantity4" => 42,
               "quantity5" => 42,
               "quantity6" => 42,
               "start_datetime" => "2010-04-17T23:00:00.000000+09:00",
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
               "request_appendices" => [],
               "user" => nil,
               "request_abbreviated" => "some request_abbreviated",
               "request_relation_number" => "some request_relation_number"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, request_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request} do
      result_conn = put(conn, request_path(conn, :update, request), @update_attrs)
      assert %{"id" => ^id} = json_response(result_conn, 200)

      conn = get(conn, request_path(conn, :show, id))

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
               "request_date1" => "2011-05-19T00:01:01.000000+09:00",
               "request_date2" => "2011-05-19T00:01:01.000000+09:00",
               "request_date3" => "2011-05-19T00:01:01.000000+09:00",
               "request_date4" => "2011-05-19T00:01:01.000000+09:00",
               "request_date5" => "2011-05-19T00:01:01.000000+09:00",
               "request_date6" => "2011-05-19T00:01:01.000000+09:00",
               "request_key1" => "some updated request_key1",
               "request_key2" => "some updated request_key2",
               "request_key3" => "some updated request_key3",
               "request_key4" => "some updated request_key4",
               "request_key5" => "some updated request_key5",
               "request_name" => "some updated request_name",
               "request_number" => "some updated request_number",
               "quantity1" => 43,
               "quantity2" => 43,
               "quantity3" => 43,
               "quantity4" => 43,
               "quantity5" => 43,
               "quantity6" => 43,
               "start_datetime" => "2011-05-19T00:01:01.000000+09:00",
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
               "request_appendices" => [],
               "user" => nil,
               "request_abbreviated" => "some request_abbreviated",
               "request_relation_number" => "some request_relation_number"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, request: request} do
      conn = put(conn, request_path(conn, :update, request), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request" do
    setup [:create_request]

    test "deletes chosen request", %{conn: conn, request: request} do
      result_conn = delete(conn, request_path(conn, :delete, request))
      assert response(result_conn, 204)

      assert_error_sent(
        404,
        fn ->
          get(conn, request_path(conn, :show, request))
        end
      )
    end
  end

  describe "current request" do
    test "search", %{conn: conn} do
      conn =
        post(
          conn,
          request_path(conn, :search_current_requests),
          %{
            "and" => [%{"request_number" => "PJ-01"}],
            "or" => []
          }
        )

      request =
        json_response(conn, 200)
        |> List.first()

      assert request["request_number"] == "PJ-01"
      assert request["start_datetime"] == "2019-01-01T18:00:00.000000+09:00"
      assert request["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
      assert request["status"] == 2
    end

    test "new history", %{conn: conn} do
      create_conn =
        post(
          conn,
          request_path(conn, :current_requests),
          %{
            "request_number" => "PJ-01",
            "status" => 4,
            "lock_version" => 2
          }
        )

      conn =
        post(
          conn,
          request_path(conn, :search_current_requests),
          %{
            "and" => [%{"request_number" => "PJ-01"}],
            "or" => []
          }
        )

      request =
        json_response(conn, 200)
        |> List.first()

      assert request["request_number"] == "PJ-01"
      assert request["end_datetime"] == "3000-01-01T08:59:59.000000+09:00"
      assert request["status"] == 4
    end

    test "my new history", %{conn: conn} do
      create_conn =
        post(
          conn,
          request_path(conn, :create_my_new_request_history),
          %{
            "request_number" => "my new history",
            "user_id" => 99
          }
        )

      conn =
        post(
          conn,
          request_path(conn, :search_current_requests),
          %{
            "and" => [%{"request_number" => "my new history"}],
            "or" => []
          }
        )

      request =
        json_response(conn, 200)
        |> List.first()

      assert request["request_number"] == "my new history"
      assert request["user"]["id"] == 1
    end
  end

  defp create_request(_) do
    request = fixture(:request)
    {:ok, request: request}
  end
end
