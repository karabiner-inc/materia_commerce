defmodule MateriaCommerceWeb.ContractController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Contract
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

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

  def search_current_contracts(conn, %{"key_words" => key_words}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    contracts = Commerces.get_current_commerces(now, key_words)
    render(conn, "index.json", contracts: contracts)
  end

  def current_contracts(conn, %{"key_words" => key_words, "contracts" => contracts}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    MateriaWeb.ControllerBase.transaction_flow(conn, :contract, Commerces, :create_new_contract_history, [now, key_words, contracts])
  end
end
