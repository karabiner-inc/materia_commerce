defmodule MateriaCommerceWeb.TaxView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.TaxView
  alias MateriaWeb.UserView
  alias MateriaUtils.Calendar.CalendarUtil

  def render("index.json", %{taxes: taxes}) do
    render_many(taxes, TaxView, "tax.json")
  end

  def render("show.json", %{tax: tax}) do
    render_one(tax, TaxView, "tax.json")
  end

  def render("tax.json", %{tax: tax}) do
    result_map = %{
      id: tax.id,
      name: tax.name,
      tax_category: tax.tax_category,
      tax_rate: tax.tax_rate,
      lock_version: tax.lock_version,
      start_datetime: CalendarUtil.convert_time_utc2local(tax.start_datetime),
      end_datetime: CalendarUtil.convert_time_utc2local(tax.end_datetime),
      inserted_at: CalendarUtil.convert_time_utc2local(tax.inserted_at),
      updated_at: CalendarUtil.convert_time_utc2local(tax.updated_at)
    }

    result_map =
      cond do
        Ecto.assoc_loaded?(tax.inserted) and tax.inserted != nil ->
          Map.put(result_map, :inserted, UserView.render("user.json", %{user: tax.inserted}))

        true ->
          Map.put(result_map, :inserted, nil)
      end
  end
end
