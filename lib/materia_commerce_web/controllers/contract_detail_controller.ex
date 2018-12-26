defmodule MateriaCommerceWeb.ContractDetailController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.ContractDetail

  action_fallback MateriaCommerceWeb.FallbackController

  def index(conn, _params) do
    contract_details = Commerces.list_contract_details()
    render(conn, "index.json", contract_details: contract_details)
  end

  def create(conn, %{"contract_detail" => contract_detail_params}) do
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

  def update(conn, %{"id" => id, "contract_detail" => contract_detail_params}) do
    contract_detail = Commerces.get_contract_detail!(id)

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
end
