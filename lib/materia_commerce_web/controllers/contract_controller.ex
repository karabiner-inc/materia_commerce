defmodule MateriaCommerceWeb.ContractController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Contract

  action_fallback MateriaCommerceWeb.FallbackController

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
end
