defmodule MateriaCommerceWeb.ContractDetailController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.ContractDetail
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    contract_details = Commerces.list_contract_details()
    render(conn, "index.json", contract_details: contract_details)
  end

  def create(conn, contract_detail_params) do
    with {:ok, %ContractDetail{} = contract_detail} <- Commerces.create_contract_detail(contract_detail_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", contract_detail_path(conn, :show, contract_detail))
      |> render("show.json", contract_detail: contract_detail)
    end
  end

  def show(conn, %{"id" => id}) do
    contract_detail = Commerces.get_contract_detail!(id)
    render(conn, "show.json", contract_detail: contract_detail)
  end

  def update(conn, contract_detail_params) do
    contract_detail = Commerces.get_contract_detail!(contract_detail_params["id"])

    with {:ok, %ContractDetail{} = contract_detail} <- Commerces.update_contract_detail(contract_detail, contract_detail_params) do
      render(conn, "show.json", contract_detail: contract_detail)
    end
  end

  def delete(conn, %{"id" => id}) do
    contract_detail = Commerces.get_contract_detail!(id)
    with {:ok, %ContractDetail{}} <- Commerces.delete_contract_detail(contract_detail) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_contract_details(conn, params) do
    base_datetime = CalendarUtil.now()
    contract_details = Commerces.get_current_contract_details(base_datetime, params)
    render(conn, "index.json", contract_details: contract_details)
  end

  def current_contract_details(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()
    key_words = [{:contract_no, params["contract_no"]}]
    contract_details = params["contract_details"]
    MateriaWeb.ControllerBase.transaction_flow(conn, :contract_details, Commerces, :create_new_contract_detail_history, [now, key_words, contract_details, user_id])
  end
end
