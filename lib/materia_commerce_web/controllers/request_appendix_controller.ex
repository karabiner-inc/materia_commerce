defmodule MateriaCommerceWeb.RequestAppendixController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.RequestAppendix
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    request_appendices = Commerces.list_request_appendices()
    render(conn, "index.json", request_appendices: request_appendices)
  end

  def create(conn, request_appendix_params) do
    with {:ok, %RequestAppendix{} = request_appendix} <- Commerces.create_request_appendix(request_appendix_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_appendix_path(conn, :show, request_appendix))
      |> render("show.json", request_appendix: request_appendix)
    end
  end

  def show(conn, %{"id" => id}) do
    request_appendix = Commerces.get_request_appendix!(id)
    render(conn, "show.json", request_appendix: request_appendix)
  end

  def update(conn, request_appendix_params) do
    request_appendix = Commerces.get_request_appendix!(request_appendix_params["id"])

    with {:ok, %RequestAppendix{} = request_appendix} <-
           Commerces.update_request_appendix(request_appendix, request_appendix_params) do
      render(conn, "show.json", request_appendix: request_appendix)
    end
  end

  def delete(conn, %{"id" => id}) do
    request_appendix = Commerces.get_request_appendix!(id)

    with {:ok, %RequestAppendix{}} <- Commerces.delete_request_appendix(request_appendix) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_request_appendices(conn, params) do
    base_datetime = CalendarUtil.now()
    request_appendices = Commerces.get_current_request_appendices(base_datetime, params)
    render(conn, "index.json", request_appendices: request_appendices)
  end

  def current_request_appendices(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()
    key_words = [{:request_number, params["request_number"]}]
    request_appendices = params["request_appendices"]

    MateriaWeb.ControllerBase.transaction_flow(
      conn,
      :request_appendices,
      Commerces,
      :create_new_request_appendix_history,
      [now, key_words, request_appendices, user_id]
    )
  end
end
