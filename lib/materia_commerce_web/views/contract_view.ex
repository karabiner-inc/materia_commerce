defmodule MateriaCommerceWeb.ContractView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ContractView
  alias MateriaCommerceWeb.ContractDetailView
  alias MateriaWeb.UserView
  alias MateriaCommerceWeb.DeliveryView
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
      branch_type: contract.branch_type,
      branch_number: contract.branch_number,
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
      total_size: contract.total_size,
      total_weight: contract.total_weight,
      total_count: contract.total_count,
      billing_amount: contract.billing_amount,
      other_fee: contract.other_fee,
      contract_name: contract.contract_name,
      description: contract.description,
      note1: contract.note1,
      note2: contract.note2,
      note3: contract.note3,
      note4: contract.note4,
      status: contract.status,
      expiration_date: CalendarUtil.convert_time_utc2local(contract.expiration_date),
      contracted_date: CalendarUtil.convert_time_utc2local(contract.contracted_date),
      start_datetime: CalendarUtil.convert_time_utc2local(contract.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(contract.end_datetime),
      lock_version: contract.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(contract.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(contract.updated_at)
    }

    result_map =
      if Map.has_key?(contract, :contract_details) and contract.contract_details != [] do
        Map.put(
          result_map,
          :contract_details,
          ContractDetailView.render("index.json", %{contract_details: contract.contract_details})
        )
      else
        Map.put(result_map, :contract_details, [])
      end

    result_map =
      cond do
        Ecto.assoc_loaded?(contract.buyer) and contract.buyer != nil ->
          Map.put(result_map, :buyer, UserView.render("user.json", %{user: contract.buyer}))

        true ->
          Map.put(result_map, :buyer, nil)
      end

    result_map =
      cond do
        Ecto.assoc_loaded?(contract.seller) and contract.seller != nil ->
          Map.put(result_map, :seller, UserView.render("user.json", %{user: contract.seller}))

        true ->
          Map.put(result_map, :seller, nil)
      end

    result_map =
      cond do
        Ecto.assoc_loaded?(contract.inserted) and contract.inserted != nil ->
          Map.put(result_map, :inserted, UserView.render("user.json", %{user: contract.inserted}))

        true ->
          Map.put(result_map, :inserted, nil)
      end

    cond do
      Ecto.assoc_loaded?(contract.delivery) and contract.delivery != nil ->
        Map.put(result_map, :delivery, DeliveryView.render("delivery.json", %{delivery: contract.delivery}))

      true ->
        Map.put(result_map, :delivery, nil)
    end
  end
end
