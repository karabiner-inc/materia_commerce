defmodule MateriaCommerceWeb.ContractView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ContractView

  def render("index.json", %{contracts: contracts}) do
    %{data: render_many(contracts, ContractView, "contract.json")}
  end

  def render("show.json", %{contract: contract}) do
    %{data: render_one(contract, ContractView, "contract.json")}
  end

  def render("contract.json", %{contract: contract}) do
    %{id: contract.id,
      contract_no: contract.contract_no,
      settlement: contract.settlement,
      seller_id: contract.seller_id,
      buyer_id: contract.buyer_id,
      delivery_address: contract.delivery_address,
      delivery_start_datetime: contract.delivery_start_datetime,
      delivery_end_datetime: contract.delivery_end_datetime,
      billing_address: contract.billing_address,
      sender_address: contract.sender_address,
      shipping_fee: contract.shipping_fee,
      tax_amount: contract.tax_amount,
      total_amount: contract.total_amount,
      status: contract.status,
      expiration_date: contract.expiration_date,
      contracted_date: contract.contracted_date,
      start_datetime: contract.start_datetime,
      end_datetime: contract.end_datetime,
      lock_version: contract.lock_version}
  end
end
