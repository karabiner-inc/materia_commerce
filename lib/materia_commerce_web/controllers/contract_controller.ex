defmodule MateriaCommerceWeb.ContractController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Contract
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    contracts = Commerces.list_contracts()
    render(conn, "index.json", contracts: contracts)
  end

  def create(conn, contract_params) do
    with {:ok, %Contract{} = contract} <- Commerces.create_contract(contract_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", contract_path(conn, :show, contract))
      |> render("show.json", contract: contract)
    end
  end

  def show(conn, %{"id" => id}) do
    contract = Commerces.get_contract!(id)
    render(conn, "show.json", contract: contract)
  end

  def update(conn, contract_params) do
    contract = Commerces.get_contract!(contract_params["id"])

    with {:ok, %Contract{} = contract} <- Commerces.update_contract(contract, contract_params) do
      render(conn, "show.json", contract: contract)
    end
  end

  def delete(conn, %{"id" => id}) do
    contract = Commerces.get_contract!(id)

    with {:ok, %Contract{}} <- Commerces.delete_contract(contract) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_contracts(conn, params) do
    base_datetime = CalendarUtil.now()
    contracts = Commerces.get_current_contracts(base_datetime, params)
    render(conn, "index.json", contracts: contracts)
  end

  def search_my_current_contracts(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    base_datetime = CalendarUtil.now()
    contracts = Commerces.search_my_current_contracts(user_id, base_datetime, params)
    render(conn, "index.json", contracts: contracts)
  end

  def current_contracts(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()
    key_words = [{:contract_no, params["contract_no"]}]

    MateriaWeb.ControllerBase.transaction_flow(conn, :contract, Commerces, :create_new_contract_history, [
      now,
      key_words,
      params,
      user_id
    ])
  end

  def create_my_new_contract_history(conn, params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()

    MateriaWeb.ControllerBase.transaction_flow(conn, :contract, Commerces, :create_my_new_contract_history, [
      now,
      params,
      user_id
    ])
  end
end
