defmodule MateriaCommerceWeb.DeliveryController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Deliveries
  alias MateriaCommerce.Deliveries.Delivery

  action_fallback(MateriaWeb.FallbackController)

  def index(conn, _params) do
    deliveries = Deliveries.list_deliveries()
    render(conn, "index.json", deliveries: deliveries)
  end

  def create(conn, delivery_params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)

    MateriaWeb.ControllerBase.transaction_flow(conn, :delivery, Deliveries, :create_delivery, [delivery_params, user_id])
  end

  def show(conn, %{"id" => id}) do
    delivery = Deliveries.get_delivery!(id)
    render(conn, "show.json", delivery: delivery)
  end

  def update(conn, delivery_params) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    delivery = Deliveries.get_delivery!(delivery_params["id"])

    MateriaWeb.ControllerBase.transaction_flow(conn, :delivery, Deliveries, :update_delivery, [
      delivery,
      delivery_params,
      user_id
    ])
  end

  def delete(conn, %{"id" => id}) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    delivery = Deliveries.get_delivery!(id)
    MateriaWeb.ControllerBase.transaction_flow(conn, :delivery, Deliveries, :delete_delivery, [delivery, user_id])
  end
end
