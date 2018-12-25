defmodule MateriaCommerceWeb.TaxView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.TaxView

  def render("index.json", %{taxes: taxes}) do
    %{data: render_many(taxes, TaxView, "tax.json")}
  end

  def render("show.json", %{tax: tax}) do
    %{data: render_one(tax, TaxView, "tax.json")}
  end

  def render("tax.json", %{tax: tax}) do
    %{id: tax.id,
      name: tax.name,
      tax_category: tax.tax_category,
      tax_rate: tax.tax_rate,
      start_datetime: tax.start_datetime,
      end_datetime: tax.end_datetime,
      lock_version: tax.lock_version}
  end
end
