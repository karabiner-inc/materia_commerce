defmodule MateriaCommerceWeb.ContractDetailView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ContractDetailView

  def render("index.json", %{contract_details: contract_details}) do
    %{data: render_many(contract_details, ContractDetailView, "contract_detail.json")}
  end

  def render("show.json", %{contract_detail: contract_detail}) do
    %{data: render_one(contract_detail, ContractDetailView, "contract_detail.json")}
  end

  def render("contract_detail.json", %{contract_detail: contract_detail}) do
    %{id: contract_detail.id,
      contract_name: contract_detail.contract_name,
      amount: contract_detail.amount,
      price: contract_detail.price,
      description: contract_detail.description,
      name: contract_detail.name,
      category1: contract_detail.category1,
      category2: contract_detail.category2,
      category3: contract_detail.category3,
      category4: contract_detail.category4,
      item_code: contract_detail.item_code,
      model_number: contract_detail.model_number,
      jan_code: contract_detail.jan_code,
      thumbnail: contract_detail.thumbnail,
      image_url: contract_detail.image_url,
      size1: contract_detail.size1,
      size2: contract_detail.size2,
      size3: contract_detail.size3,
      size4: contract_detail.size4,
      weight1: contract_detail.weight1,
      weight2: contract_detail.weight2,
      weight3: contract_detail.weight3,
      weight4: contract_detail.weight4,
      delivery_area: contract_detail.delivery_area,
      manufacturer: contract_detail.manufacturer,
      color: contract_detail.color,
      tax_category: contract_detail.tax_category,
      lock_version: contract_detail.lock_version}
  end
end
