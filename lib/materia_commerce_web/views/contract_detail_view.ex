defmodule MateriaCommerceWeb.ContractDetailView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.ContractDetailView
  alias MateriaWeb.UserView
  alias MateriaCommerceWeb.DeliveryView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{contract_details: contract_details}) do
    render_many(contract_details, ContractDetailView, "contract_detail.json")
  end

  def render("show.json", %{contract_detail: contract_detail}) do
    render_one(contract_detail, ContractDetailView, "contract_detail.json")
  end

  def render("show.json", %{contract_details: contract_details}) do
    render_many(contract_details, ContractDetailView, "contract_detail.json")
  end

  def render("contract_detail.json", %{contract_detail: contract_detail}) do
    result_map = %{
      id: contract_detail.id,
      contract_detail_no: contract_detail.contract_detail_no,
      contract_name: contract_detail.contract_name,
      contract_no: contract_detail.contract_no,
      branch_type: contract_detail.branch_type,
      branch_number: contract_detail.branch_number,
      amount: contract_detail.amount,
      price: contract_detail.price,
      purchase_amount: contract_detail.purchase_amount,
      merchandise_cost: contract_detail.merchandise_cost,
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
      datetime1: CalendarUtil.convert_time_utc2local(contract_detail.datetime1),
      datetime2: CalendarUtil.convert_time_utc2local(contract_detail.datetime2),
      datetime3: CalendarUtil.convert_time_utc2local(contract_detail.datetime3),
      datetime4: CalendarUtil.convert_time_utc2local(contract_detail.datetime4),
      delivery_area: contract_detail.delivery_area,
      manufacturer: contract_detail.manufacturer,
      color: contract_detail.color,
      tax_category: contract_detail.tax_category,
      start_datetime: CalendarUtil.convert_time_utc2local(contract_detail.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(contract_detail.end_datetime),
      lock_version: contract_detail.lock_version,
      inserted_at: CalendarUtil.convert_time_utc2local(contract_detail.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(contract_detail.updated_at)
    }

    result_map = cond do
      Ecto.assoc_loaded?(contract_detail.inserted) and contract_detail.inserted != nil ->
        Map.put(result_map, :inserted, UserView.render("user.json", %{user: contract_detail.inserted}))
      true ->
        Map.put(result_map, :inserted, nil)
    end

    cond do
      Ecto.assoc_loaded?(contract_detail.delivery) and contract_detail.delivery != nil ->
        Map.put(result_map, :delivery, DeliveryView.render("delivery.json", %{delivery: contract_detail.delivery}))
      true ->
        Map.put(result_map, :delivery, nil)
    end
  end
end
