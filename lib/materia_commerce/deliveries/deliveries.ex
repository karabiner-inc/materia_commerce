defmodule MateriaCommerce.Deliveries do
  @moduledoc """
  The Deliveries context.
  """

  import Ecto.Query, warn: false
  @repo Application.get_env(:materia, :repo)

  alias MateriaCommerce.Deliveries.Delivery

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Deliveries.list_deliveries
  iex(3)> view = MateriaCommerceWeb.DeliveryView.render("index.json", %{deliveries: results}) |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); end)
  iex(4)> view = view |> List.first
  iex(5)> view |> Map.delete(:inserted) |> Map.delete(:updated) |> Map.delete(:snd_user) |> Map.delete(:clt_user) |> Map.delete(:rcv_user)
  %{
    clt_notation_org_name: "××会社",
    clt_phone_number: "444-4444-4444",
    snd_condition2: "条件2",
    snd_note2: "備考2",
    clt_fax_number: "555-5555-5555",
    rcv_notation_org_name: "△△会社",
    snd_note1: "備考1",
    rcv_phone_number: "222-2222-2222",
    rcv_address3: "△△ビル",
    clt_address2_p: "ばつばつ",
    clt_notation_name_p: "ばつばつ",
    rcv_note1: "備考1",
    snd_address1_p: "ふくおかけんふくおかしまるまるく",
    rcv_condition1: "条件1",
    clt_address1_p: "ふくおかけんふくおかしばつばつく",
    snd_time: "23:59:59",
    lock_version: 0,
    clt_address1: "福岡県福岡市××区",
    clt_address2: "××x-x-x",
    clt_notation_name: "××",
    snd_notation_name_p: "まるまる",
    snd_notation_org_name: "〇〇会社",
    rcv_address3_p: "さんかくさんかくびる",
    clt_zip_code: "810-XXXX",
    rcv_notation_org_name_p: "さんかくさんかくかいしゃ",
    snd_address3_p: "まるまるびる",
    snd_notation_org_name_p: "まるまるかいしゃ",
    snd_address2_p: "まるまる",
    rcv_address2: "△△x-x-x",
    rcv_note2: "備考2",
    snd_address2: "〇〇x-x-x",
    rcv_note3: "備考3",
    rcv_notation_name: "△△",
    clt_notation_org_name_p: "ばつばつかいしゃ",
    rcv_condition3: "条件3",
    rcv_notation_name_p: "さんかくさんかく",
    rcv_address1: "福岡県福岡市△△区",
    snd_condition1: "条件1",
    snd_notation_name: "〇〇",
    rcv_time: "00:00:01",
    rcv_zip_code: "810-YYYY",
    clt_address3_p: "ばつばつびる",
    snd_date: "2019/01/01",
    snd_condition3: "条件3",
    snd_phone_number: "000-0000-0000",
    snd_fax_number: "111-1111-1111",
    snd_address1: "福岡県福岡市○○区",
    rcv_address1_p: "ふくおかけんふくおかしさんかくさんかくく",
    clt_address3: "××ビル",
    snd_address3: "○○ビル",
    rcv_address2_p: "さんかくさんかく",
    rcv_condition2: "条件2",
    rcv_date: "2019/01/02",
    rcv_fax_number: "333-3333-3333",
    snd_note3: "備考3",
    snd_zip_code: "810-ZZZZ",
    status: 0
  }
  iex(6)> view[:inserted]
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(7)> view[:updated]
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(8)> view[:snd_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(9)> view[:clt_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(10)> view[:rcv_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  """
  def list_deliveries do
    Delivery
    |> @repo.all()
    |> @repo.preload(
         snd_user: [:addresses],
         rcv_user: [:addresses],
         clt_user: [:addresses],
         inserted: [],
         updated: [],
       )
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Deliveries.get_delivery!(1) |> List.wrap()
  iex(3)> view = MateriaCommerceWeb.DeliveryView.render("index.json", %{deliveries: results}) |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); end)
  iex(4)> view = view |> List.first
  iex(5)> view |> Map.delete(:inserted) |> Map.delete(:updated) |> Map.delete(:snd_user) |> Map.delete(:clt_user) |> Map.delete(:rcv_user)
  %{
    clt_notation_org_name: "××会社",
    clt_phone_number: "444-4444-4444",
    snd_condition2: "条件2",
    snd_note2: "備考2",
    clt_fax_number: "555-5555-5555",
    rcv_notation_org_name: "△△会社",
    snd_note1: "備考1",
    rcv_phone_number: "222-2222-2222",
    rcv_address3: "△△ビル",
    clt_address2_p: "ばつばつ",
    clt_notation_name_p: "ばつばつ",
    rcv_note1: "備考1",
    snd_address1_p: "ふくおかけんふくおかしまるまるく",
    rcv_condition1: "条件1",
    clt_address1_p: "ふくおかけんふくおかしばつばつく",
    snd_time: "23:59:59",
    lock_version: 0,
    clt_address1: "福岡県福岡市××区",
    clt_address2: "××x-x-x",
    clt_notation_name: "××",
    snd_notation_name_p: "まるまる",
    snd_notation_org_name: "〇〇会社",
    rcv_address3_p: "さんかくさんかくびる",
    clt_zip_code: "810-XXXX",
    rcv_notation_org_name_p: "さんかくさんかくかいしゃ",
    snd_address3_p: "まるまるびる",
    snd_notation_org_name_p: "まるまるかいしゃ",
    snd_address2_p: "まるまる",
    rcv_address2: "△△x-x-x",
    rcv_note2: "備考2",
    snd_address2: "〇〇x-x-x",
    rcv_note3: "備考3",
    rcv_notation_name: "△△",
    clt_notation_org_name_p: "ばつばつかいしゃ",
    rcv_condition3: "条件3",
    rcv_notation_name_p: "さんかくさんかく",
    rcv_address1: "福岡県福岡市△△区",
    snd_condition1: "条件1",
    snd_notation_name: "〇〇",
    rcv_time: "00:00:01",
    rcv_zip_code: "810-YYYY",
    clt_address3_p: "ばつばつびる",
    snd_date: "2019/01/01",
    snd_condition3: "条件3",
    snd_phone_number: "000-0000-0000",
    snd_fax_number: "111-1111-1111",
    snd_address1: "福岡県福岡市○○区",
    rcv_address1_p: "ふくおかけんふくおかしさんかくさんかくく",
    clt_address3: "××ビル",
    snd_address3: "○○ビル",
    rcv_address2_p: "さんかくさんかく",
    rcv_condition2: "条件2",
    rcv_date: "2019/01/02",
    rcv_fax_number: "333-3333-3333",
    snd_note3: "備考3",
    snd_zip_code: "810-ZZZZ",
    status: 0
  }
  iex(6)> view[:inserted]
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(7)> view[:updated]
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(8)> view[:snd_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(9)> view[:clt_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  iex(10)> view[:rcv_user]
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: nil,
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: nil,
    phone_number: nil,
    role: "admin",
    status: 1
  }
  """
  def get_delivery!(id) do
    Delivery
    |> @repo.get!(id)
    |> @repo.preload(
         snd_user: [:addresses],
         rcv_user: [:addresses],
         clt_user: [:addresses],
         inserted: [],
         updated: [],
       )
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> attrs = %{"snd_zip_code" => "000-0000","snd_address1" => "snd_address1","rcv_zip_code" => "111-1111","rcv_address1" => "rcv_address1","clt_zip_code" => "222-2222","clt_address1" => "clt_address1","snd_user_id" => 1,"rcv_user_id" => 1,"clt_user_id" => 1}
  iex(3)> {:ok, result} = MateriaCommerce.Deliveries.create_delivery(%{}, attrs, 1)
  iex(4)> results = List.wrap(result)
  iex(5)> view = MateriaCommerceWeb.DeliveryView.render("index.json", %{deliveries: results}) |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); end)
  iex(6)> view = view |> List.first
  iex(7)> view |> Map.delete(:inserted) |> Map.delete(:updated) |> Map.delete(:snd_user) |> Map.delete(:clt_user) |> Map.delete(:rcv_user)
  %{
    clt_notation_org_name: nil,
    clt_phone_number: nil,
    snd_condition2: nil,
    snd_note2: nil,
    clt_fax_number: nil,
    rcv_notation_org_name: nil,
    snd_note1: nil,
    rcv_phone_number: nil,
    rcv_address3: nil,
    clt_address2_p: nil,
    clt_notation_name_p: nil,
    rcv_note1: nil,
    snd_address1_p: nil,
    rcv_condition1: nil,
    clt_address1_p: nil,
    snd_time: nil,
    lock_version: 0,
    clt_address1: "clt_address1",
    clt_address2: nil,
    clt_notation_name: nil,
    snd_notation_name_p: nil,
    snd_notation_org_name: nil,
    rcv_address3_p: nil,
    clt_zip_code: "222-2222",
    rcv_notation_org_name_p: nil,
    snd_address3_p: nil,
    snd_notation_org_name_p: nil,
    snd_address2_p: nil,
    rcv_address2: nil,
    rcv_note2: nil,
    snd_address2: nil,
    rcv_note3: nil,
    rcv_notation_name: nil,
    clt_notation_org_name_p: nil,
    rcv_condition3: nil,
    rcv_notation_name_p: nil,
    rcv_address1: "rcv_address1",
    snd_condition1: nil,
    snd_notation_name: nil,
    rcv_time: nil,
    rcv_zip_code: "111-1111",
    clt_address3_p: nil,
    snd_date: nil,
    snd_condition3: nil,
    snd_phone_number: nil,
    snd_fax_number: nil,
    snd_address1: "snd_address1",
    rcv_address1_p: nil,
    clt_address3: nil,
    snd_address3: nil,
    rcv_address2_p: nil,
    rcv_condition2: nil,
    rcv_date: nil,
    rcv_fax_number: nil,
    snd_note3: nil,
    snd_zip_code: "000-0000",
    status: 1
  }
  """
  def create_delivery(_results, attrs, user_id) do
    attrs = attrs
            |> Map.put("inserted_id", user_id)
            |> Map.put("updated_id", user_id)
    %Delivery{}
    |> Delivery.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> delivery = MateriaCommerce.Deliveries.get_delivery!(1)
  iex(3)> {:ok, result} = MateriaCommerce.Deliveries.update_delivery(%{}, delivery, %{"snd_zip_code" => "000-0000"}, 1)
  iex(4)> results = List.wrap(result)
  iex(5)> view = MateriaCommerceWeb.DeliveryView.render("index.json", %{deliveries: results}) |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); end)
  iex(6)> view = view |> List.first
  iex(7)> view |> Map.delete(:inserted) |> Map.delete(:updated) |> Map.delete(:snd_user) |> Map.delete(:clt_user) |> Map.delete(:rcv_user)
  %{
    clt_notation_org_name: "××会社",
    clt_phone_number: "444-4444-4444",
    snd_condition2: "条件2",
    snd_note2: "備考2",
    clt_fax_number: "555-5555-5555",
    rcv_notation_org_name: "△△会社",
    snd_note1: "備考1",
    rcv_phone_number: "222-2222-2222",
    rcv_address3: "△△ビル",
    clt_address2_p: "ばつばつ",
    clt_notation_name_p: "ばつばつ",
    rcv_note1: "備考1",
    snd_address1_p: "ふくおかけんふくおかしまるまるく",
    rcv_condition1: "条件1",
    clt_address1_p: "ふくおかけんふくおかしばつばつく",
    snd_time: "23:59:59",
    lock_version: 1,
    clt_address1: "福岡県福岡市××区",
    clt_address2: "××x-x-x",
    clt_notation_name: "××",
    snd_notation_name_p: "まるまる",
    snd_notation_org_name: "〇〇会社",
    rcv_address3_p: "さんかくさんかくびる",
    clt_zip_code: "810-XXXX",
    rcv_notation_org_name_p: "さんかくさんかくかいしゃ",
    snd_address3_p: "まるまるびる",
    snd_notation_org_name_p: "まるまるかいしゃ",
    snd_address2_p: "まるまる",
    rcv_address2: "△△x-x-x",
    rcv_note2: "備考2",
    snd_address2: "〇〇x-x-x",
    rcv_note3: "備考3",
    rcv_notation_name: "△△",
    clt_notation_org_name_p: "ばつばつかいしゃ",
    rcv_condition3: "条件3",
    rcv_notation_name_p: "さんかくさんかく",
    rcv_address1: "福岡県福岡市△△区",
    snd_condition1: "条件1",
    snd_notation_name: "〇〇",
    rcv_time: "00:00:01",
    rcv_zip_code: "810-YYYY",
    clt_address3_p: "ばつばつびる",
    snd_date: "2019/01/01",
    snd_condition3: "条件3",
    snd_phone_number: "000-0000-0000",
    snd_fax_number: "111-1111-1111",
    snd_address1: "福岡県福岡市○○区",
    rcv_address1_p: "ふくおかけんふくおかしさんかくさんかくく",
    clt_address3: "××ビル",
    snd_address3: "○○ビル",
    rcv_address2_p: "さんかくさんかく",
    rcv_condition2: "条件2",
    rcv_date: "2019/01/02",
    rcv_fax_number: "333-3333-3333",
    snd_note3: "備考3",
    snd_zip_code: "000-0000",
    status: 0
  }
  """
  def update_delivery(_results, %Delivery{} = delivery, attrs, user_id) do
    attrs = attrs
            |> Map.put("updated_id", user_id)
    delivery
    |> Delivery.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> delivery = MateriaCommerce.Deliveries.get_delivery!(1)
  iex(3)> {:ok, result} = MateriaCommerce.Deliveries.delete_delivery(%{}, delivery, 1)
  iex(4)> results = List.wrap(result)
  iex(5)> view = MateriaCommerceWeb.DeliveryView.render("index.json", %{deliveries: results}) |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); end)
  iex(6)> view = view |> List.first
  iex(7)> view |> Map.delete(:inserted) |> Map.delete(:updated) |> Map.delete(:snd_user) |> Map.delete(:clt_user) |> Map.delete(:rcv_user)
  %{
    clt_notation_org_name: "××会社",
    clt_phone_number: "444-4444-4444",
    snd_condition2: "条件2",
    snd_note2: "備考2",
    clt_fax_number: "555-5555-5555",
    rcv_notation_org_name: "△△会社",
    snd_note1: "備考1",
    rcv_phone_number: "222-2222-2222",
    rcv_address3: "△△ビル",
    clt_address2_p: "ばつばつ",
    clt_notation_name_p: "ばつばつ",
    rcv_note1: "備考1",
    snd_address1_p: "ふくおかけんふくおかしまるまるく",
    rcv_condition1: "条件1",
    clt_address1_p: "ふくおかけんふくおかしばつばつく",
    snd_time: "23:59:59",
    lock_version: 1,
    clt_address1: "福岡県福岡市××区",
    clt_address2: "××x-x-x",
    clt_notation_name: "××",
    snd_notation_name_p: "まるまる",
    snd_notation_org_name: "〇〇会社",
    rcv_address3_p: "さんかくさんかくびる",
    clt_zip_code: "810-XXXX",
    rcv_notation_org_name_p: "さんかくさんかくかいしゃ",
    snd_address3_p: "まるまるびる",
    snd_notation_org_name_p: "まるまるかいしゃ",
    snd_address2_p: "まるまる",
    rcv_address2: "△△x-x-x",
    rcv_note2: "備考2",
    snd_address2: "〇〇x-x-x",
    rcv_note3: "備考3",
    rcv_notation_name: "△△",
    clt_notation_org_name_p: "ばつばつかいしゃ",
    rcv_condition3: "条件3",
    rcv_notation_name_p: "さんかくさんかく",
    rcv_address1: "福岡県福岡市△△区",
    snd_condition1: "条件1",
    snd_notation_name: "〇〇",
    rcv_time: "00:00:01",
    rcv_zip_code: "810-YYYY",
    clt_address3_p: "ばつばつびる",
    snd_date: "2019/01/01",
    snd_condition3: "条件3",
    snd_phone_number: "000-0000-0000",
    snd_fax_number: "111-1111-1111",
    snd_address1: "福岡県福岡市○○区",
    rcv_address1_p: "ふくおかけんふくおかしさんかくさんかくく",
    clt_address3: "××ビル",
    snd_address3: "○○ビル",
    rcv_address2_p: "さんかくさんかく",
    rcv_condition2: "条件2",
    rcv_date: "2019/01/02",
    rcv_fax_number: "333-3333-3333",
    snd_note3: "備考3",
    snd_zip_code: "810-ZZZZ",
    status: 9
  }
  """
  def delete_delivery(_results, %Delivery{} = delivery, user_id) do
    attrs = %{}
            |> Map.put("updated_id", user_id)
            |> Map.put("status", Delivery.status().cancel)
    delivery
    |> Delivery.update_changeset(attrs)
    |> @repo.update()
  end
end
