defmodule MateriaCommerce.Deliveries do
  @moduledoc """
  The Deliveries context.
  """

  import Ecto.Query, warn: false
  @repo Application.get_env(:materia, :repo)

  alias MateriaCommerce.Deliveries.Delivery

  @doc false
  def list_deliveries do
    Delivery
    |> @repo.all()
    |> @repo.preload([:snd_user, :rcv_user, :clt_user, :inserted, :updated])
  end

  @doc false
  def get_delivery!(id) do
    Delivery
    |> @repo.get!(id)
    |> @repo.preload([:snd_user, :rcv_user, :clt_user, :inserted, :updated])
  end

  @doc false
  def create_delivery(_results, attrs, user_id) do
    %Delivery{}
    |> Delivery.changeset(attrs)
    |> @repo.insert()
  end

  @doc false
  def update_delivery(_results, %Delivery{} = delivery, attrs, user_id) do
    delivery
    |> Delivery.update_changeset(attrs)
    |> @repo.update()
  end

  @doc false
  def delete_delivery(_results, %Delivery{} = delivery, user_id) do
    delivery
    |> @repo.delete()
  end
end
