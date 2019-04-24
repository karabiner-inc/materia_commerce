defmodule MateriaCommerceWeb.ContractView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ContractView
  alias MateriaCommerceWeb.ContractDetailView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{contracts: contracts}) do
    render_many(contracts, ContractView, "contract.json")
  end

  def render("show.json", %{contract: contract}) do
    render_one(contract, ContractView, "contract.json")
  end

  def render("contract.json", %{contract: contract}) do
    result_map = %{
      id: contract.id,
      contract_no: contract.contract_no,
      request_number: contract.request_number,
      settlement: contract.settlement,
      seller_id: contract.seller_id,
      buyer_id: contract.buyer_id,
      delivery_address: contract.delivery_address,
      delivery_start_datetime: CalendarUtil.convert_time_utc2local(contract.delivery_start_datetime),
      delivery_end_datetime: CalendarUtil.convert_time_utc2local(contract.delivery_end_datetime),
      billing_address: contract.billing_address,
      sender_address: contract.sender_address,
      shipping_fee: contract.shipping_fee,
      tax_amount: contract.tax_amount,
      total_amount: contract.total_amount,
      status: contract.status,
      expiration_date: CalendarUtil.convert_time_utc2local(contract.expiration_date),
      contracted_date: CalendarUtil.convert_time_utc2local(contract.contracted_date),
      start_datetime: CalendarUtil.convert_time_utc2local(contract.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(contract.end_datetime),
      lock_version: contract.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(contract.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(contract.updated_at)
    }

    result_map = if Map.has_key?(contract, :contract_details) and contract.contract_details != [] do
      Map.put(result_map, :contract_details, ContractDetailView.render("index.json", %{contract_details: contract.contract_details}))
    else
      Map.put(result_map, :contract_details, [])
    end

    result_map = cond do
      Ecto.assoc_loaded?(contract.buyer) and contract.buyer != nil ->
        Map.put(result_map, :buyer, UserView.render("user.json", %{user: contract.buyer}))
      true ->
        Map.put(result_map, :buyer, nil)
    end

    result_map = cond do
      Ecto.assoc_loaded?(contract.seller) and contract.seller != nil ->
        Map.put(result_map, :seller, UserView.render("user.json", %{user: contract.seller}))
      true ->
        Map.put(result_map, :seller, nil)
    end

    result_map = cond do
      Ecto.assoc_loaded?(contract.inserted) and contract.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: contract.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end
  end
end
