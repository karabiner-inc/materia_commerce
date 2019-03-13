defmodule MateriaCommerce.Commerces do
  @moduledoc """
  The Commerces context.
  """
  require Logger
  import Ecto.Query, warn: false

  alias MateriaCommerce.Commerces.Contract
  alias MateriaCommerce.Commerces.ContractDetail
  alias MateriaCommerce.Commerces.Request
  alias MateriaCommerce.Commerces.RequestAppendix
  alias MateriaUtils.Calendar.CalendarUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of contracts.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> list_contracts = MateriaCommerce.Commerces.list_contracts
  iex(2)> view = MateriaCommerceWeb.ContractView.render("index.json", %{contracts: list_contracts}) |> Enum.map(fn x -> Map.delete(x, :id) end)
  iex(3)> view = view |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end)
  iex(4)> view |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  expiration_date: "",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "100.01",
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  status: 1,
  tax_amount: "80",
  total_amount: "1180.01"
  }
  """
  def list_contracts do
    @repo.all(Contract)
    |> @repo.preload([:inserted])
  end

  @doc """
  Gets a single contract.

  Raises `Ecto.NoResultsError` if the Contract does not exist.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> contract = MateriaCommerce.Commerces.get_contract!(1)
  iex(2)> view = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract})
  iex(3)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  expiration_date: "",
  id: 1,
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "100.01",
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  status: 1,
  tax_amount: "80",
  total_amount: "1180.01"
  }
  """
  def get_contract!(id), do: @repo.get!(Contract, id)
                             |> @repo.preload([:inserted])

  @doc """
  Creates a contract.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attrs = %{"contract_no" => "TEST","settlement" => "TEST","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => 0,"start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59", "inserted_id" => 1}
  iex(2)> {:ok, contract} = MateriaCommerce.Commerces.create_contract(attrs)
  iex(3)> view = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(4)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "TEST",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  expiration_date: "",
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "TEST",
  shipping_fee: "9999",
  start_datetime: "2018-01-01 18:00:00+09:00 JST Asia/Tokyo",
  status: 0,
  tax_amount: "99",
  total_amount: "9999",
  inserted: nil,
  }
  """
  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a contract.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attrs = %{"contract_no" => "TEST-UPDATE"}
  iex(2)> contract = MateriaCommerce.Commerces.get_contract!(1)
  iex(3)> {:ok, contract} = MateriaCommerce.Commerces.update_contract(contract, attrs)
  iex(4)> view = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(5)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "TEST-UPDATE",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  expiration_date: "",
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "100.01",
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  status: 1,
  tax_amount: "80",
  total_amount: "1180.01",
  contract_details: [],
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  }
  """
  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Contract.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> contract = MateriaCommerce.Commerces.get_contract!(1)
  iex(2)> {:ok, contract} = MateriaCommerce.Commerces.delete_contract(contract)
  iex(3)> list_contracts = MateriaCommerce.Commerces.list_contracts |> Enum.find(fn x -> x.id == 1 end)
  nil
  """
  def delete_contract(%Contract{} = contract) do
    @repo.delete(contract)
  end

  @doc """
  主キーを想定したパラメータで現在のContract情報を取得する

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract = MateriaCommerce.Commerces.get_current_contract_history(base_datetime, key_word_list)
  iex(4)> view = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(5)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  expiration_date: "",
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "110.01",
  start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  status: 2,
  tax_amount: "80",
  total_amount: "1190.01",
  inserted: nil,
  }
  """
  def get_current_contract_history(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.get_current_contract_history -----*")
    contracts = MateriaUtils.Ecto.EctoUtil.list_current_history(@repo, Contract, base_datetime, key_word_list)
    contract =
      if contracts == [] do
        nil
      else
        [contract] = contracts
        contract
      end
  end

  @doc """
  start_datetimeに指定した以降の先日付の登録データがある場合、削除する｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract = MateriaCommerce.Commerces.delete_future_contract_histories(base_datetime, key_word_list)
  iex(4)> list_contracts = MateriaCommerce.Commerces.list_contracts
  iex(5)> view = MateriaCommerceWeb.ContractView.render("index.json", %{contracts: list_contracts}) |> Enum.map(fn x -> Map.delete(x, :id) end)
  iex(6)> view = view |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end)
  iex(7)> view |> Enum.count()
  4
  """
  def delete_future_contract_histories(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.delete_future_contract_histories -----*")
    contracts = MateriaUtils.Ecto.EctoUtil.delete_future_histories(@repo, Contract, base_datetime, key_word_list)
  end

  @doc """
  現在以前の直近のContract情報を取得する

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> view = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, key_word_list) |> Map.delete(:id)
  iex(4)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2019-01-01 08:59:59Z",
  expiration_date: "",
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "110.01",
  start_datetime: "2018-12-01 09:00:00Z",
  status: 2,
  tax_amount: "80",
  total_amount: "1190.01",
  inserted_id: 1,
  }
  """
  def get_recent_contract_history(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.get_recent_contract_history -----*")
    contracts = MateriaUtils.Ecto.EctoUtil.list_recent_history(@repo, Contract, base_datetime, key_word_list)
    if contracts == [] do
      nil
    else
      [contract] = contracts
      contract
    end
  end

  @doc """
  新規のContract情報履歴を登録する
  start_datetimeに指定した以降の先日付の登録データがある場合、削除して登録する。

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> recent = MateriaCommerce.Commerces.get_recent_contract_history(base_datetime, key_word_list) |> Map.delete(:id)
  iex(4)> recent = [recent] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2019-01-01 08:59:59Z",
  expiration_date: "",
  inserted_id: 1,
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "110.01",
  start_datetime: "2018-12-01 09:00:00Z",
  status: 2,
  tax_amount: "80",
  total_amount: "1190.01"
  }
  iex(5)> attrs = %{"contract_no" => "0000-0000-0000","settlement" => "9999-9999-9999","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => 0, "lock_version" => recent.lock_version}
  iex(6)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, key_word_list, attrs, 1)
  iex(7)> contract = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(8)> contract = [contract] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  expiration_date: "",
  inserted: nil,
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
  status: 0,
  tax_amount: "99",
  total_amount: "9999"
  }
  iex(9)> {:ok, next_start_date} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
  iex(10)> recent = MateriaCommerce.Commerces.get_recent_contract_history(next_start_date, key_word_list) |> Map.delete(:id)
  iex(11)> recent = [recent] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2999-12-31 23:59:59Z",
  expiration_date: "",
  inserted_id: 1,
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 09:00:00Z",
  status: 0,
  tax_amount: "99",
  total_amount: "9999"
  }
  iex(12)> attrs = %{"contract_no" => "0000-0000-0000","settlement" => "8888-8888-8888","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => 0, "lock_version" => recent.lock_version}
  iex(13)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, next_start_date, key_word_list, attrs, 1)
  iex(14)> contract = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(15)> contract = [contract] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_details: [],
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  expiration_date: "",
  inserted: nil,
  lock_version: 2,
  seller_id: nil,
  sender_address: nil,
  settlement: "8888-8888-8888",
  shipping_fee: "9999",
  start_datetime: "2019-12-17 18:00:00+09:00 JST Asia/Tokyo",
  status: 0,
  tax_amount: "99",
  total_amount: "9999"
  }
  iex(16)> recent = MateriaCommerce.Commerces.get_recent_contract_history(next_start_date, key_word_list) |> Map.delete(:id)
  iex(24)> recent = [recent] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2019-12-17 08:59:59Z",
  expiration_date: "",
  inserted_id: 1,
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 09:00:00Z",
  status: 0,
  tax_amount: "99",
  total_amount: "9999"
  }
  """
  def create_new_contract_history(%{}, start_datetime, key_word_list, attr, user_id) do
    Logger.debug("*-----  #{__MODULE__}.create_new_contract_history -----*")
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_contract = get_recent_contract_history(start_datetime, key_word_list)

    #未来日付のデータがある場合削除する
    {i, _reason} = delete_future_contract_histories(start_datetime, key_word_list)
    contract =
      if recent_contract == nil do
        # 新規登録
        attr = attr
               |> Map.put("start_datetime", start_datetime)
               |> Map.put("end_datetime", end_datetime)
               |> Map.put("inserted_id", user_id)
        attr =
          {:ok, contract} = create_contract(attr)
      else
        # 2回目以降のヒストリー登録の場合
        # 楽観排他チェック
        _ = cond do
          !Map.has_key?(attr, "lock_version") -> raise KeyError, message: "parameter have not lock_version"
          attr["lock_version"] != recent_contract.lock_version -> raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
          true -> :ok
        end

        attr = Map.keys(attr)
               |> Enum.reduce(recent_contract, fn(key, acc) ->
          acc = acc
                |> Map.put(String.to_atom(key), attr[key])
        end)

        attr = attr
               |> Map.put(:lock_version, recent_contract.lock_version + 1)
               |> Map.put(:start_datetime, start_datetime)
               |> Map.put(:end_datetime, end_datetime)
               |> Map.put(:inserted_id, user_id)
        {:ok, contract} = create_contract(attr)
        # 直近の履歴のend_datetimeを更新する
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_contract = struct(Contract, recent_contract)
        update_contract(struct_contract, %{end_datetime: recent_end_datetime})
        {:ok, contract}
      end
  end

  @doc """
  Returns the list of contract_details.

  ## Examples
  iex(1)> contract_details = MateriaCommerce.Commerces.list_contract_details
  iex(2)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(3)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  iex(4)> Enum.count(view)
  7
  """
  def list_contract_details do
    @repo.all(ContractDetail)
    |> @repo.preload([:inserted])
  end

  @doc """
  Gets a single contract_detail.

  Raises `Ecto.NoResultsError` if the Contract detail does not exist.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> contract_detail = MateriaCommerce.Commerces.get_contract_detail!(1)
  iex(2)> view = MateriaCommerceWeb.ContractDetailView.render("show.json", %{contract_detail: contract_detail})
  iex(3)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end) |> List.first
  %{
  size2: nil,
  tax_category: nil,
  contract_no: "0000-0000-0000",
  size4: nil,
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  category3: nil,
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  manufacturer: nil,
  merchandise_cost: "",
  image_url: nil,
  category2: nil,
  weight3: nil,
  description: nil,
  model_number: nil,
  lock_version: 0,
  color: nil,
  weight1: nil,
  contract_name: nil,
  delivery_area: nil,
  purchase_amount: "",
  weight4: nil,
  category1: "Single Detail",
  item_code: nil,
  weight2: nil,
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  jan_code: nil,
  thumbnail: nil,
  amount: 1,
  name: nil,
  price: "100",
  size1: nil,
  size3: nil,
  category4: nil
  }
  """
  def get_contract_detail!(id), do: @repo.get!(ContractDetail, id)
                                    |> @repo.preload([:inserted])

  @doc """
  Creates a contract_detail.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attr = %{"contract_name" => "TEST1", "contract_no" => "0000-0000-0000", "start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59", "inserted_id" => 1}
  iex(2)> {:ok, contract_detail} = MateriaCommerce.Commerces.create_contract_detail(attr)
  iex(3)> view = MateriaCommerceWeb.ContractDetailView.render("show.json", %{contract_detail: contract_detail})
  iex(4)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end) |> List.first
  %{
  amount: nil,
  category1: nil,
  category2: nil,
  category3: nil,
  category4: nil,
  color: nil,
  contract_name: "TEST1",
  contract_no: "0000-0000-0000",
  delivery_area: nil,
  description: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  image_url: nil,
  item_code: nil,
  jan_code: nil,
  lock_version: 0,
  manufacturer: nil,
  merchandise_cost: "",
  model_number: nil,
  name: nil,
  price: "",
  purchase_amount: "",
  size1: nil,
  size2: nil,
  size3: nil,
  size4: nil,
  start_datetime: "2018-01-01 18:00:00+09:00 JST Asia/Tokyo",
  tax_category: nil,
  thumbnail: nil,
  weight1: nil,
  weight2: nil,
  weight3: nil,
  weight4: nil,
  inserted: nil,
  }
  """
  def create_contract_detail(attrs \\ %{}) do
    %ContractDetail{}
    |> ContractDetail.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a contract_detail.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attr = %{"id" => 1, "contract_name" => "TEST1", "contract_no" => "0000-0000-0000", "start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59"}
  iex(2)> contract_detail = MateriaCommerce.Commerces.get_contract_detail!(1)
  iex(3)> {:ok, contract_detail} = MateriaCommerce.Commerces.update_contract_detail(contract_detail, attr)
  iex(4)> view = MateriaCommerceWeb.ContractDetailView.render("show.json", %{contract_detail: contract_detail})
  iex(5)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end) |> List.first
  %{
  amount: 1,
  category1: "Single Detail",
  category2: nil,
  category3: nil,
  category4: nil,
  color: nil,
  contract_name: "TEST1",
  contract_no: "0000-0000-0000",
  delivery_area: nil,
  description: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  image_url: nil,
  item_code: nil,
  jan_code: nil,
  lock_version: 0,
  manufacturer: nil,
  merchandise_cost: "",
  model_number: nil,
  name: nil,
  price: "100",
  purchase_amount: "",
  size1: nil,
  size2: nil,
  size3: nil,
  size4: nil,
  start_datetime: "2018-01-01 18:00:00+09:00 JST Asia/Tokyo",
  tax_category: nil,
  thumbnail: nil,
  weight1: nil,
  weight2: nil,
  weight3: nil,
  weight4: nil,
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  }
  """
  def update_contract_detail(%ContractDetail{} = contract_detail, attrs) do
    contract_detail
    |> ContractDetail.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ContractDetail.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> contract_detail = MateriaCommerce.Commerces.get_contract_detail!(1)
  iex(2)> {:ok, contract} = MateriaCommerce.Commerces.delete_contract_detail(contract_detail)
  iex(3)> list_contract_details = MateriaCommerce.Commerces.list_contract_details |> Enum.find(fn x -> x.id == 1 end)
  nil
  """
  def delete_contract_detail(%ContractDetail{} = contract_detail) do
    @repo.delete(contract_detail)
  end

  @doc """
  主キーを想定したパラメータで現在のContractDetail情報を取得する
  Contract -> 1: ContractDetail -> N の関係のため複数件を返す｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract_details = MateriaCommerce.Commerces.get_current_contract_detail_history(base_datetime, key_word_list)
  iex(4)> Enum.count(contract_details)
  2
  """
  def get_current_contract_detail_history(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.get_current_contract_detail_history -----*")
    MateriaUtils.Ecto.EctoUtil.list_current_history(@repo, ContractDetail, base_datetime, key_word_list)
  end

  @doc """
  start_datetimeに指定した以降の先日付の登録データがある場合、削除する｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> MateriaCommerce.Commerces.delete_future_contract_detail_histories(base_datetime, key_word_list)
  iex(4)> contract_details = MateriaCommerce.Commerces.list_contract_details
  iex(5)> Enum.count(contract_details)
  5
  """
  def delete_future_contract_detail_histories(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.delete_future_contract_detail_histories -----*")
    MateriaUtils.Ecto.EctoUtil.delete_future_histories(@repo, ContractDetail, base_datetime, key_word_list)
  end

  @doc """
  現在以前の直近のContractDetails情報を取得する
  Contract -> 1: ContractDetail -> N の関係のため複数件を返す｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract_details = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, key_word_list)
  iex(4)> view = contract_details |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "2019-01-01 08:59:59Z",
    category3: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 0,
    color: nil,
    weight1: nil,
    contract_name: nil,
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:2 With Item",
    item_code: "ICZ1000",
    weight2: nil,
    start_datetime: "2018-12-01 09:00:00Z",
    inserted_id: 1,
    jan_code: nil,
    thumbnail: nil,
    amount: 3,
    name: nil,
    price: "300",
    size1: nil,
    size3: nil,
    category4: nil
  },
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "2019-01-01 08:59:59Z",
    category3: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 0,
    color: nil,
    weight1: nil,
    contract_name: nil,
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:1",
    item_code: nil,
    weight2: nil,
    start_datetime: "2018-12-01 09:00:00Z",
    inserted_id: 1,
    jan_code: nil,
    thumbnail: nil,
    amount: 2,
    name: nil,
    price: "200",
    size1: nil,
    size3: nil,
    category4: nil
  }
  ]
  """
  def get_recent_contract_detail_history(base_datetime, key_word_list) do
    Logger.debug("*-----  #{__MODULE__}.get_recent_contract_detail_history -----*")
    MateriaUtils.Ecto.EctoUtil.list_recent_history(@repo, ContractDetail, base_datetime, key_word_list)
  end

  @doc """
  新規のContractDetails情報履歴を登録する
  start_datetimeに指定した以降の先日付の登録データがある場合、削除して登録する。

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> recent = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, key_word_list)
  iex(4)> recent = recent |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "2019-01-01 08:59:59Z",
    category3: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 0,
    color: nil,
    weight1: nil,
    contract_name: nil,
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:2 With Item",
    item_code: "ICZ1000",
    weight2: nil,
    start_datetime: "2018-12-01 09:00:00Z",
    inserted_id: 1,
    jan_code: nil,
    thumbnail: nil,
    amount: 3,
    name: nil,
    price: "300",
    size1: nil,
    size3: nil,
    category4: nil
  },
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "2019-01-01 08:59:59Z",
    category3: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 0,
    color: nil,
    weight1: nil,
    contract_name: nil,
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:1",
    item_code: nil,
    weight2: nil,
    start_datetime: "2018-12-01 09:00:00Z",
    inserted_id: 1,
    jan_code: nil,
    thumbnail: nil,
    amount: 2,
    name: nil,
    price: "200",
    size1: nil,
    size3: nil,
    category4: nil
  }
  ]
  iex(5)> attrs = [%{"contract_no" => "0000-0000-0000","contract_name" => "TEST2","id" => 2,"lock_version" => 0,"price" => 2000,},%{"contract_no" => "0000-0000-0000","contract_name" => "TEST3","id" => 3,"lock_version" => 0,"price" => 3000,},%{"contract_no" => "0000-0000-0000","contract_name" => "TEST1","amount" => 1,"price" => 1000,}]
  iex(6)> {:ok, contract_details} = MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, key_word_list, attrs, 1)
  iex(7)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(8)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
    %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    category3: nil,
    inserted: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 1,
    color: nil,
    weight1: nil,
    contract_name: "TEST2",
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:1",
    item_code: nil,
    weight2: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    jan_code: nil,
    thumbnail: nil,
    amount: 2,
    name: nil,
    price: "2000",
    size1: nil,
    size3: nil,
    category4: nil
  },
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    category3: nil,
    inserted: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 1,
    color: nil,
    weight1: nil,
    contract_name: "TEST3",
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: "Multiple Details:2 With Item",
    item_code: "ICZ1000",
    weight2: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    jan_code: nil,
    thumbnail: nil,
    amount: 3,
    name: nil,
    price: "3000",
    size1: nil,
    size3: nil,
    category4: nil
  },
  %{
    size2: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    size4: nil,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    category3: nil,
    inserted: nil,
    manufacturer: nil,
    merchandise_cost: "",
    image_url: nil,
    category2: nil,
    weight3: nil,
    description: nil,
    model_number: nil,
    lock_version: 1,
    color: nil,
    weight1: nil,
    contract_name: "TEST1",
    delivery_area: nil,
    purchase_amount: "",
    weight4: nil,
    category1: nil,
    item_code: nil,
    weight2: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    jan_code: nil,
    thumbnail: nil,
    amount: 1,
    name: nil,
    price: "1000",
    size1: nil,
    size3: nil,
    category4: nil
  }
  ]
  """
  def create_new_contract_detail_history(%{}, start_datetime, key_word_list, attrs, user_id) do
    Logger.debug("*-----  #{__MODULE__}.create_new_contract_detail_history -----*")
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_contract_detail = get_recent_contract_detail_history(start_datetime, key_word_list)

    #未来日付のデータがある場合削除する
    {i, _reason} = delete_future_contract_detail_histories(start_datetime, key_word_list)
    contract_detail =
      if recent_contract_detail == [] do
        # 新規登録
        Logger.debug("*-----  #{__MODULE__}.create_new_contract_detail_history new -----*")
        contract_detail = attrs
                          |> Enum.map(
                               fn attr ->
                                 attr = attr
                                        |> Map.put("start_datetime", start_datetime)
                                        |> Map.put("end_datetime", end_datetime)
                                        |> Map.put("inserted_id", user_id)
                                 {:ok, contract_detail} = create_contract_detail(attr)
                                 contract_detail
                               end
                             )
        {:ok, contract_detail}
      else
        # 2回目以降のヒストリー登録の場合
        # 楽観排他チェック
        Logger.debug("*-----  #{__MODULE__}.create_new_contract_detail_history recent -----*")
        attrs
        |> Enum.map(
             fn attr ->
               cond do
                 Map.has_key?(attr, "id") and !Map.has_key?(attr, "lock_version") ->
                   raise KeyError, message: "parameter have not lock_version"
                 Map.has_key?(attr, "id") and !check_recent_contract_detail(recent_contract_detail, attr["id"], attr["lock_version"]) ->
                   raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
                 true -> :ok
               end
             end
           )

        contract_detail = attrs
                          |> Enum.map(
                               fn attr ->
                                 recent = check_recent_contract_detail(
                                   recent_contract_detail,
                                   attr["id"],
                                   attr["lock_version"]
                                 )
                                 unless recent do
                                   recent = Map.from_struct(%ContractDetail{})
                                 end
                                 recent = Map.keys(attr)
                                          |> Enum.reduce(
                                               recent,
                                               fn (key, acc) ->
                                                 acc = acc
                                                       |> Map.put(String.to_atom(key), attr[key])
                                               end
                                             )
                                          |> Map.put(:lock_version, recent.lock_version + 1)
                                          |> Map.put(:start_datetime, start_datetime)
                                          |> Map.put(:end_datetime, end_datetime)
                                          |> Map.put(:inserted_id, user_id)
                               end
                             )
                          |> Enum.map(
                               fn attr ->
                                 {:ok, contract_detail} = create_contract_detail(attr)
                                 contract_detail
                               end
                             )

        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        recent_contract_detail
        |> Enum.map(
             fn recent ->
               struct_contract = struct(ContractDetail, recent)
               update_contract_detail(struct_contract, %{end_datetime: recent_end_datetime})
             end
           )
        {:ok, contract_detail}
      end
  end

  @doc """
  現在以前の直近のContractDetails情報と､入力リスト内容を比較｡
  Idが存在する(更新データ)場合は､Lock_versionの整合チェックする｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract_details = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, key_word_list)
  iex(4)> contract_details |> Enum.map(fn x -> %{"id" => x.id, "lock_version" => x.lock_version, "contract_no" => x.contract_no} end)
  [
  %{"contract_no" => "0000-0000-0000", "id" => 3, "lock_version" => 0},
  %{"contract_no" => "0000-0000-0000", "id" => 2, "lock_version" => 0}
  ]
  iex(5)> result = MateriaCommerce.Commerces.check_recent_contract_detail(contract_details, nil, nil)
  nil
  iex(6)> result = MateriaCommerce.Commerces.check_recent_contract_detail(contract_details, 3, 1)
  false
  iex(7)> result = MateriaCommerce.Commerces.check_recent_contract_detail(contract_details, 3, 0)
  iex(8)> view = [result] |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end) |> List.first
  %{
  amount: 3,
  category1: "Multiple Details:2 With Item",
  category2: nil,
  category3: nil,
  category4: nil,
  color: nil,
  contract_name: nil,
  contract_no: "0000-0000-0000",
  delivery_area: nil,
  description: nil,
  end_datetime: "2019-01-01 08:59:59Z",
  image_url: nil,
  item_code: "ICZ1000",
  jan_code: nil,
  lock_version: 0,
  manufacturer: nil,
  merchandise_cost: "",
  model_number: nil,
  name: nil,
  price: "300",
  purchase_amount: "",
  size1: nil,
  size2: nil,
  size3: nil,
  size4: nil,
  start_datetime: "2018-12-01 09:00:00Z",
  tax_category: nil,
  thumbnail: nil,
  weight1: nil,
  weight2: nil,
  weight3: nil,
  weight4: nil,
  inserted_id: 1,
  }
  """
  def check_recent_contract_detail(recent_contract_detail, id, lock_version) do
    Logger.debug("*-----  #{__MODULE__}.check_recent_contract_detail -----*")
    filter = Enum.filter(recent_contract_detail, fn x -> x.id == id end) |> List.first
    cond do
      filter != nil and filter.lock_version != lock_version -> false
      true -> filter
    end
  end


  @doc """
  主キーを想定したパラメータで現在のContract情報を取得し､
  ・Contract情報のcontract_noからContractDetail情報を取得

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = %{"and" => [%{"contract_no" => "0000-0000-0000"}]}
  iex(3)> current_commerces = MateriaCommerce.Commerces.get_current_contracts(base_datetime, key_word_list)
  iex(4)> view = MateriaCommerceWeb.ContractView.render("index.json", %{contracts: current_commerces})
  iex(5)> view |> Enum.map(fn x ->   x = Map.put(x, :contracted_date , to_string(x.contracted_date));  x = Map.put(x, :delivery_end_datetime , to_string(x.delivery_end_datetime));  x = Map.put(x, :delivery_start_datetime , to_string(x.delivery_start_datetime));  x = Map.put(x, :start_datetime , to_string(x.start_datetime));  x = Map.put(x, :end_datetime , to_string(x.end_datetime));  x = Map.put(x, :shipping_fee , to_string(x.shipping_fee));  x = Map.put(x, :tax_amount , to_string(x.tax_amount));  x = Map.put(x, :total_amount , to_string(x.total_amount));  x = Map.delete(x, :id);  x = Map.delete(x, :inserted_at);  x = Map.delete(x, :updated_at);  x = Map.put(x, :contract_details , x.contract_details |> Enum.map(    fn y ->       y = Map.put(y, :price , to_string(y.price));      y = Map.put(y, :end_datetime , to_string(y.end_datetime));      y = Map.put(y, :start_datetime , to_string(y.start_datetime));      y = Map.put(y, :merchandise_cost , to_string(y.merchandise_cost));      y = Map.put(y, :amount , to_string(y.amount));      y = Map.put(y, :purchase_amount , to_string(y.purchase_amount));      y = Map.delete(y, :id);      y = Map.delete(y, :updated_at);      y = Map.delete(y, :inserted_at);    end));end)
  [
  %{
    billing_address: nil,
    buyer_id: nil,
    contract_details: [
      %{
        amount: "3",
        category1: "Multiple Details:2 With Item",
        category2: nil,
        category3: nil,
        category4: nil,
        color: nil,
        contract_name: nil,
        contract_no: "0000-0000-0000",
        delivery_area: nil,
        description: nil,
        end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
        image_url: nil,
        item_code: "ICZ1000",
        jan_code: nil,
        lock_version: 0,
        manufacturer: nil,
        merchandise_cost: "",
        model_number: nil,
        name: nil,
        price: "300",
        purchase_amount: "",
        size1: nil,
        size2: nil,
        size3: nil,
        size4: nil,
        start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
        tax_category: nil,
        thumbnail: nil,
        weight1: nil,
        weight2: nil,
        weight3: nil,
        weight4: nil,
        inserted: nil,
      },
      %{
        amount: "2",
        category1: "Multiple Details:1",
        category2: nil,
        category3: nil,
        category4: nil,
        color: nil,
        contract_name: nil,
        contract_no: "0000-0000-0000",
        delivery_area: nil,
        description: nil,
        end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
        image_url: nil,
        item_code: nil,
        jan_code: nil,
        lock_version: 0,
        manufacturer: nil,
        merchandise_cost: "",
        model_number: nil,
        name: nil,
        price: "200",
        purchase_amount: "",
        size1: nil,
        size2: nil,
        size3: nil,
        size4: nil,
        start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
        tax_category: nil,
        thumbnail: nil,
        weight1: nil,
        weight2: nil,
        weight3: nil,
        weight4: nil,
        inserted: nil,
      }
    ],
    contract_no: "0000-0000-0000",
    contracted_date: "",
    delivery_address: nil,
    delivery_end_datetime: "",
    delivery_start_datetime: "",
    end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
    expiration_date: nil,
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "110.01",
    start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: 2,
    tax_amount: "80",
    total_amount: "1190.01",
    inserted: nil,
  }
  ]
  """
  def get_current_contracts(base_datetime, params) do
    Logger.debug("*-----  #{__MODULE__}.get_current_commerces -----*")
    contract_detail = MateriaCommerce.Commerces.ContractDetail
                      |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)

    contract = MateriaUtils.Ecto.EctoUtil.query_current_history(@repo, MateriaCommerce.Commerces.Contract, base_datetime, [], params)
    results = contract
              |> join(:left, [c], cd in subquery(contract_detail), contract_no: c.contract_no)
              |> select([c, cd], %{contract: c, contract_details: cd})
              |> @repo.all()
              |> Enum.group_by(fn x -> x.contract end)

    results = results
              |> Map.keys()
              |> Enum.map(
                   fn key ->
                     contract_details = results[key]
                                        |> Enum.flat_map(
                                             fn result ->
                                               cond do
                                                 result.contract_details.id == nil -> []
                                                 true -> [result.contract_details]
                                               end
                                             end
                                           )
                     key
                     |> Map.put(:contract_details, contract_details)
                   end
                 )
  end

  @doc """
  主キーを想定したパラメータで現在のContractDetail情報を取得

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = %{"and" => [%{"contract_no" => "0000-0000-0000"}]}
  iex(3)> contract_details = MateriaCommerce.Commerces.get_current_contract_details(base_datetime, key_word_list)
  iex(4)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(5)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
  %{
    amount: 3,
    category1: "Multiple Details:2 With Item",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: nil,
    contract_no: "0000-0000-0000",
    delivery_area: nil,
    description: nil,
    end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
    image_url: nil,
    item_code: "ICZ1000",
    jan_code: nil,
    lock_version: 0,
    manufacturer: nil,
    merchandise_cost: "",
    model_number: nil,
    name: nil,
    price: "300",
    purchase_amount: "",
    size1: nil,
    size2: nil,
    size3: nil,
    size4: nil,
    start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil,
    inserted: nil,
  },
  %{
    amount: 2,
    category1: "Multiple Details:1",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: nil,
    contract_no: "0000-0000-0000",
    delivery_area: nil,
    description: nil,
    end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
    image_url: nil,
    item_code: nil,
    jan_code: nil,
    lock_version: 0,
    manufacturer: nil,
    merchandise_cost: "",
    model_number: nil,
    name: nil,
    price: "200",
    purchase_amount: "",
    size1: nil,
    size2: nil,
    size3: nil,
    size4: nil,
    start_datetime: "2018-12-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil,
    inserted: nil,
  }
  ]
  """
  def get_current_contract_details(base_datetime, params) do
    Logger.debug("*-----  #{__MODULE__}.get_current_contract_details -----*")
    MateriaUtils.Ecto.EctoUtil.list_current_history_no_lock(@repo, MateriaCommerce.Commerces.ContractDetail, base_datetime, [], params)
  end

  @doc """
  Returns the list of requests.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Commerces.list_requests
  iex(3)> view = MateriaCommerceWeb.RequestView.render("index.json", %{requests: results})
  iex(4)> view = view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end)
  iex(5)> view |> Enum.count()
  4
  """
  def list_requests do
    Request
    |> @repo.all()
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Gets a single request.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Commerces.get_request!(1)
  iex(3)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(4)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_appendices: [],
  request_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History1",
  request_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def get_request!(id) do
    Request
    |> @repo.get!(id)
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Creates a request.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> attrs = %{"request_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Commerces.create_request(attrs)
  iex(6)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); end) |> List.first
  %{
  accuracy: nil,
  description: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 0,
  note1: nil,
  note2: nil,
  note3: nil,
  note4: nil,
  request_appendices: [],
  request_date1: "",
  request_date2: "",
  request_date3: "",
  request_date4: "",
  request_date5: "",
  request_date6: "",
  request_key1: nil,
  request_key2: nil,
  request_key3: nil,
  request_key4: nil,
  request_key5: nil,
  request_name: nil,
  request_number: "1",
  quantity1: nil,
  quantity2: nil,
  quantity3: nil,
  quantity4: nil,
  quantity5: nil,
  quantity6: nil,
  status: 0,
  user: nil
  }
  """
  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a request.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(3)> results = MateriaCommerce.Commerces.get_request!(1)
  iex(4)> attrs = %{"request_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Commerces.update_request(results, attrs)
  iex(6)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_appendices: [],
  request_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History1",
  request_number: "1",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a request.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Commerces.get_request!(1)
  iex(3)> {:ok, results} = MateriaCommerce.Commerces.delete_request(results)
  iex(4)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(5)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); x = Map.put(x, :user, Map.delete(x.user, :id)); x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_appendices: [],
  request_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History1",
  request_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 0,
  user: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  }
  }
  """
  def delete_request(%Request{} = request) do
    @repo.delete(request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  iex(1)> attrs = %MateriaCommerce.Commerces.Request{} |> Map.put(:request_number, "1") |> Map.put(:start_datetime, "1") |> Map.put(:end_datetime, "1") |> Map.put(:inserted_id, "1")
  iex(2)> change_set = MateriaCommerce.Commerces.change_request(attrs)
  iex(3)> change_set.valid?
  true
  """
  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end

  @doc """
  Returns the list of request_appendices.

  iex(1)> MateriaCommerce.Commerces.list_request_appendices() |> Enum.count()
  6
  """
  def list_request_appendices do
    RequestAppendix
    |> @repo.all()
    |> @repo.preload([:inserted])
  end

  @doc """
  Gets a single request_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> results = MateriaCommerce.Commerces.get_request_appendix!(1)
  iex(3)> view = MateriaCommerceWeb.RequestAppendixView.render("show.json", %{request_appendix: results})
  iex(4)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_number: "PJ-01"
  }
  """
  def get_request_appendix!(id) do
    RequestAppendix
    |> @repo.get!(id)
    |> @repo.preload([:inserted])
  end

  @doc """
  Creates a request_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> attrs = %{"request_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(5)> {:ok, results} = MateriaCommerce.Commerces.create_request_appendix(attrs)
  iex(6)> view = MateriaCommerceWeb.RequestAppendixView.render("show.json", %{request_appendix: results})
  iex(7)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));end) |> List.first
  %{
  appendix_category: nil,
  appendix_date: "",
  appendix_description: nil,
  appendix_name: nil,
  appendix_number: "",
  appendix_status: nil,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 0,
  request_key1: nil,
  request_key2: nil,
  request_key3: nil,
  request_key4: nil,
  request_key5: nil,
  request_number: "1"
  }
  """
  def create_request_appendix(attrs \\ %{}) do
    %RequestAppendix{}
    |> RequestAppendix.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a request_appendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> results = MateriaCommerce.Commerces.get_request_appendix!(1)
  iex(5)> attrs = %{"request_number" => "1", "start_datetime" => start_datetime, "end_datetime" => end_datetime, "inserted_id" => 1}
  iex(6)> {:ok, results} = MateriaCommerce.Commerces.update_request_appendix(results, attrs)
  iex(7)> view = MateriaCommerceWeb.RequestAppendixView.render("show.json", %{request_appendix: results})
  iex(8)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_number: "1"
  }
  """
  def update_request_appendix(%RequestAppendix{} = request_appendix, attrs) do
    request_appendix
    |> RequestAppendix.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a requestAppendix.

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> start_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> {ok, end_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
  iex(4)> results = MateriaCommerce.Commerces.get_request_appendix!(1)
  iex(6)> {:ok, results} = MateriaCommerce.Commerces.delete_request_appendix(results)
  iex(7)> view = MateriaCommerceWeb.RequestAppendixView.render("show.json", %{request_appendix: results})
  iex(8)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number));x = Map.put(x, :inserted, Map.delete(x.inserted, :id)); end) |> List.first
  %{
  appendix_category: "Category1",
  appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  appendix_description: "appendix_description",
  appendix_name: "appendix_name",
  appendix_number: "1",
  appendix_status: 0,
  end_datetime: "2019-01-01 17:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "hogehoge",
    organization: [],
    phone_number: nil,
    role: "admin",
    status: 1
  },
  lock_version: 0,
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_number: "PJ-01"
  }
  """
  def delete_request_appendix(%RequestAppendix{} = request_appendix) do
    @repo.delete(request_appendix)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request_appendix changes.

  iex(1)> attrs = %MateriaCommerce.Commerces.RequestAppendix{} |> Map.put(:request_number, "1") |> Map.put(:start_datetime, "1") |> Map.put(:end_datetime, "1") |> Map.put(:inserted_id, "1")
  iex(2)> change_set = MateriaCommerce.Commerces.change_request_appendix(attrs)
  iex(3)> change_set.valid?
  true
  """
  def change_request_appendix(%RequestAppendix{} = request_appendix) do
    RequestAppendix.changeset(request_appendix, %{})
  end

  @doc """

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Commerces.get_current_request_history(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 2,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_appendices: [],
  request_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History3",
  request_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user: nil
  }
  """
  def get_current_request_history(base_datetime, keywords) do
    requests = MateriaUtils.Ecto.EctoUtil.list_current_history(@repo, Request, base_datetime, keywords)
    if requests == [] do
      nil
    else
      [request] = requests
      request
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Commerces.get_recent_request_history(base_datetime, keywords)
  iex(5)> view = results
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "2999-12-31 23:59:59Z",
  inserted_id: 1,
  lock_version: 2,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_date1: "2999-12-31 23:59:59Z",
  request_date2: "2999-12-31 23:59:59Z",
  request_date3: "2999-12-31 23:59:59Z",
  request_date4: "2999-12-31 23:59:59Z",
  request_date5: "2999-12-31 23:59:59Z",
  request_date6: "2999-12-31 23:59:59Z",
  request_key1: "key1",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History3",
  request_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user_id: 1
  }
  """
  def get_recent_request_history(base_datetime, keywords) do
    requests = MateriaUtils.Ecto.EctoUtil.list_recent_history(@repo, Request, base_datetime, keywords)
    if requests == [] do
      nil
    else
      [request] = requests
      request
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(3)> attr = %{"request_number" => "PJ-01", "request_key1" => "key1_update", "lock_version" => 2}
  iex(4)> {:ok, results} = MateriaCommerce.Commerces.create_new_request_history(%{}, base_datetime, keywords, attr, 1)
  iex(5)> view = MateriaCommerceWeb.RequestView.render("show.json", %{request: results})
  iex(6)> view = [view] |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); end) |> List.first
  %{
  accuracy: "accuracy",
  description: "description",
  end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  inserted: nil,
  lock_version: 3,
  note1: "note1",
  note2: "note2",
  note3: "note3",
  note4: "note4",
  request_appendices: [],
  request_date1: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_date2: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_date3: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_date4: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_date5: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_date6: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
  request_key1: "key1_update",
  request_key2: "key2",
  request_key3: "key3",
  request_key4: "key4",
  request_key5: "key5",
  request_name: "History3",
  request_number: "PJ-01",
  quantity1: 0,
  quantity2: 1,
  quantity3: 2,
  quantity4: 3,
  quantity5: 4,
  quantity6: 5,
  status: 2,
  user: nil
  }
  """
  def create_new_request_history(%{}, start_datetime, keywords, attr, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent = get_recent_request_history(start_datetime, keywords)
    {i, _reason} = delete_future_request_histories(start_datetime, keywords)
    request =
      if recent == nil do
        attr = attr
               |> Map.put("start_datetime", start_datetime)
               |> Map.put("end_datetime", end_datetime)
               |> Map.put("inserted_id", user_id)
        {:ok, request} = create_request(attr)
      else
        _ = cond do
          !Map.has_key?(attr, "lock_version") ->
            raise KeyError, message: "parameter have not lock_version"
          attr["lock_version"] != recent.lock_version ->
            raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
          true -> :ok
        end

        attr = Map.keys(attr)
               |> Enum.reduce(
                    recent,
                    fn (key, acc) ->
                      acc = acc
                            |> Map.put(String.to_atom(key), attr[key])
                    end
                  )

        attr = attr
               |> Map.put(:lock_version, recent.lock_version + 1)
               |> Map.put(:start_datetime, start_datetime)
               |> Map.put(:end_datetime, end_datetime)
               |> Map.put(:inserted_id, user_id)

        {:ok, request} = create_request(attr)
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_request = struct(request, recent)
        update_request(struct_request, %{end_datetime: recent_end_datetime})
        {:ok, request}
      end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> {result, _} = MateriaCommerce.Commerces.delete_future_request_histories(base_datetime, keywords)
  {2, nil}
  """
  def delete_future_request_histories(base_datetime, keywords) do
    requests = MateriaUtils.Ecto.EctoUtil.delete_future_histories(@repo, Request, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Commerces.get_current_request_appendix_history(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.RequestAppendixView.render("index.json", %{request_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 0,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 1,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  }
  ]
  """
  def get_current_request_appendix_history(base_datetime, keywords) do
    MateriaUtils.Ecto.EctoUtil.list_current_history(@repo, RequestAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)
  iex(5)> view = results
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "2999-12-31 23:59:59Z",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "2999-12-31 23:59:59Z",
    inserted_id: 1,
    lock_version: 0,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "2999-12-31 23:59:59Z",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "2999-12-31 23:59:59Z",
    inserted_id: 1,
    lock_version: 1,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  }
  ]
  """
  def get_recent_request_appendix_history(base_datetime, keywords) do
    MateriaUtils.Ecto.EctoUtil.list_recent_history(@repo, RequestAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(3)> attr = [%{"request_number" => "PJ-01", "request_key1" => "key1_update", "lock_version" => 1, "id" => 4}]
  iex(4)> {:ok, results} = MateriaCommerce.Commerces.create_new_request_appendix_history(%{}, base_datetime, keywords, attr, 1)
  iex(5)> view = MateriaCommerceWeb.RequestAppendixView.render("index.json", %{request_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 2,
    request_key1: "key1_update",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  }
  ]
  """
  def create_new_request_appendix_history(%{}, start_datetime, keywords, attrs, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_request_appendix = get_recent_request_appendix_history(start_datetime, keywords)
    {i, _reason} = delete_future_request_appendix_histories(start_datetime, keywords)
    request_appendix =
      if recent_request_appendix == [] do
        request_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  attr = attr
                                         |> Map.put("start_datetime", start_datetime)
                                         |> Map.put("end_datetime", end_datetime)
                                         |> Map.put("inserted_id", user_id)
                                  {:ok, request_appendix} = create_request_appendix(attr)
                                  request_appendix
                                end
                              )
        {:ok, request_appendix}
      else
        attrs
        |> Enum.map(
             fn attr ->
               cond do
                 Map.has_key?(attr, "id") and !Map.has_key?(attr, "lock_version") ->
                   raise KeyError, message: "parameter have not lock_version"
                 Map.has_key?(attr, "id") and !check_recent_request_appendix(recent_request_appendix, attr["id"], attr["lock_version"]) ->
                   raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
                 true -> :ok
               end
             end
           )

        request_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  recent = check_recent_request_appendix(
                                    recent_request_appendix,
                                    attr["id"],
                                    attr["lock_version"]
                                  )
                                  unless recent do
                                    recent = Map.from_struct(%RequestAppendix{})
                                  end
                                  recent = Map.keys(attr)
                                           |> Enum.reduce(
                                                recent,
                                                fn (key, acc) ->
                                                  acc = acc
                                                        |> Map.put(String.to_atom(key), attr[key])
                                                end
                                              )
                                           |> Map.put(:lock_version, recent.lock_version + 1)
                                           |> Map.put(:start_datetime, start_datetime)
                                           |> Map.put(:end_datetime, end_datetime)
                                           |> Map.put(:inserted_id, user_id)
                                end
                              )
                           |> Enum.map(
                                fn attr ->
                                  {:ok, request_appendix} = create_request_appendix(attr)
                                  request_appendix
                                end
                              )

        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        recent_request_appendix
        |> Enum.map(
             fn recent ->
               struct_request_appendix = struct(RequestAppendix, recent)
               update_request_appendix(struct_request_appendix, %{end_datetime: recent_end_datetime})
             end
           )
        {:ok, request_appendix}
      end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-11-01 09:00:01Z")
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> {result, _} = MateriaCommerce.Commerces.delete_future_request_appendix_histories(base_datetime, keywords)
  {2, nil}
  """
  def delete_future_request_appendix_histories(base_datetime, keywords) do
    MateriaUtils.Ecto.EctoUtil.delete_future_histories(@repo, RequestAppendix, base_datetime, keywords)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = [{:request_number, "PJ-01"}]
  iex(4)> results = MateriaCommerce.Commerces.get_recent_request_appendix_history(base_datetime, keywords)
  iex(5)> result = MateriaCommerce.Commerces.check_recent_request_appendix(results, 5, 4)
  iex(6)> result == false
  true
  iex(7)> result = MateriaCommerce.Commerces.check_recent_request_appendix(results, 5, 0)
  iex(8)> result == false
  false
  """
  def check_recent_request_appendix(recent_request_appendix, id, lock_version) do
    filter = Enum.filter(recent_request_appendix, fn x -> x.id == id end) |> List.first
    cond do
      filter != nil and filter.lock_version != lock_version -> false
      filter == nil -> false
      true -> filter
    end
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = %{"and" => [%{"request_number" => "PJ-01"}]}
  iex(4)> results = MateriaCommerce.Commerces.get_current_request(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.RequestView.render("index.json", %{requests: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.put(x, :request_date1, to_string(x.request_date1)); x = Map.put(x, :request_date2, to_string(x.request_date2)); x = Map.put(x, :request_date3, to_string(x.request_date3)); x = Map.put(x, :request_date4, to_string(x.request_date4)); x = Map.put(x, :request_date5, to_string(x.request_date5)); x = Map.put(x, :request_date6, to_string(x.request_date6)); end)
  [
  %{
    accuracy: "accuracy",
    description: "description",
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 2,
    note1: "note1",
    note2: "note2",
    note3: "note3",
    note4: "note4",
    request_appendices: [],
    request_date1: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_date2: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_date3: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_date4: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_date5: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_date6: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_name: "History3",
    request_number: "PJ-01",
    quantity1: 0,
    quantity2: 1,
    quantity3: 2,
    quantity4: 3,
    quantity5: 4,
    quantity6: 5,
    status: 2,
    user: nil
  }
  ]
  """
  def get_current_request(base_datetime, params) do
    MateriaUtils.Ecto.EctoUtil.list_current_history_no_lock(@repo, Request, base_datetime, [], params)
  end

  @doc """
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(2)> base_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex(3)> keywords = %{"and" => [%{"request_number" => "PJ-01"}]}
  iex(4)> results = MateriaCommerce.Commerces.get_current_request_appendices(base_datetime, keywords)
  iex(5)> view = MateriaCommerceWeb.RequestAppendixView.render("index.json", %{request_appendices: results})
  iex(6)> view |> Enum.map(fn x -> x = Map.delete(x, :id); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :start_datetime); x = Map.put(x, :end_datetime, to_string(x.end_datetime));x = Map.put(x, :appendix_date, to_string(x.appendix_date));x = Map.put(x, :appendix_number, to_string(x.appendix_number)); end)
  [
  %{
    appendix_category: "Category4",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "5",
    appendix_status: 4,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 0,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  },
  %{
    appendix_category: "Category1",
    appendix_date: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    appendix_description: "appendix_description",
    appendix_name: "appendix_name",
    appendix_number: "4",
    appendix_status: 3,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    inserted: nil,
    lock_version: 1,
    request_key1: "key1",
    request_key2: "key2",
    request_key3: "key3",
    request_key4: "key4",
    request_key5: "key5",
    request_number: "PJ-01"
  }
  ]
  """
  def get_current_request_appendices(base_datetime, params) do
    MateriaUtils.Ecto.EctoUtil.list_current_history_no_lock(@repo, RequestAppendix, base_datetime, [], params)
  end
end
