defmodule MateriaCommerceWeb.DeliveryView do
  use MateriaCommerceWeb, :view
  alias MateriaCommerceWeb.DeliveryView
  alias MateriaWeb.UserView

  def render("index.json", %{deliveries: deliveries}) do
    render_many(deliveries, DeliveryView, "delivery.json")
  end

  def render("show.json", %{delivery: delivery}) do
    render_one(delivery, DeliveryView, "delivery.json")
  end

  def render("delivery.json", %{delivery: delivery}) do
    result_map = %{
      id: delivery.id,
      snd_zip_code: delivery.snd_zip_code,
      snd_address1: delivery.snd_address1,
      snd_address1_p: delivery.snd_address1_p,
      snd_address2: delivery.snd_address2,
      snd_address2_p: delivery.snd_address2_p,
      snd_address3: delivery.snd_address3,
      snd_address3_p: delivery.snd_address3_p,
      snd_phone_number: delivery.snd_phone_number,
      snd_fax_number: delivery.snd_fax_number,
      snd_notation_org_name: delivery.snd_notation_org_name,
      snd_notation_org_name_p: delivery.snd_notation_org_name_p,
      snd_notation_name: delivery.snd_notation_name,
      snd_notation_name_p: delivery.snd_notation_name_p,
      snd_date: delivery.snd_date,
      snd_time: delivery.snd_time,
      snd_condition1: delivery.snd_condition1,
      snd_condition2: delivery.snd_condition2,
      snd_condition3: delivery.snd_condition3,
      snd_note1: delivery.snd_note1,
      snd_note2: delivery.snd_note2,
      snd_note3: delivery.snd_note3,
      rcv_zip_code: delivery.rcv_zip_code,
      rcv_address1: delivery.rcv_address1,
      rcv_address1_p: delivery.rcv_address1_p,
      rcv_address2: delivery.rcv_address2,
      rcv_address2_p: delivery.rcv_address2_p,
      rcv_address3: delivery.rcv_address3,
      rcv_address3_p: delivery.rcv_address3_p,
      rcv_phone_number: delivery.rcv_phone_number,
      rcv_fax_number: delivery.rcv_fax_number,
      rcv_notation_org_name: delivery.rcv_notation_org_name,
      rcv_notation_org_name_p: delivery.rcv_notation_org_name_p,
      rcv_notation_name: delivery.rcv_notation_name,
      rcv_notation_name_p: delivery.rcv_notation_name_p,
      rcv_date: delivery.rcv_date,
      rcv_time: delivery.rcv_time,
      rcv_condition1: delivery.rcv_condition1,
      rcv_condition2: delivery.rcv_condition2,
      rcv_condition3: delivery.rcv_condition3,
      rcv_note1: delivery.rcv_note1,
      rcv_note2: delivery.rcv_note2,
      rcv_note3: delivery.rcv_note3,
      clt_zip_code: delivery.clt_zip_code,
      clt_address1: delivery.clt_address1,
      clt_address1_p: delivery.clt_address1_p,
      clt_address2: delivery.clt_address2,
      clt_address2_p: delivery.clt_address2_p,
      clt_address3: delivery.clt_address3,
      clt_address3_p: delivery.clt_address3_p,
      clt_phone_number: delivery.clt_phone_number,
      clt_fax_number: delivery.clt_fax_number,
      clt_notation_org_name: delivery.clt_notation_org_name,
      clt_notation_org_name_p: delivery.clt_notation_org_name_p,
      clt_notation_name: delivery.clt_notation_name,
      clt_notation_name_p: delivery.clt_notation_name_p,
      lock_version: delivery.lock_version,
      status: delivery.status,
    }
    delivery_map = delivery
                   |> Map.from_struct()
    ~w/snd_user rcv_user clt_user inserted updated/
    |> Enum.reduce(
         result_map,
         fn (preload, acc) ->
           key = String.to_atom(preload)
           cond do
             Ecto.assoc_loaded?(delivery_map[key]) and delivery_map[key] != nil ->
               acc
               |> Map.put(key, UserView.render("user.json", %{user: delivery_map[key]}))
             true ->
               acc
               |> Map.put(key, nil)
           end
         end
       )
  end
end
