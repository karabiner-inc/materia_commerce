defmodule MateriaCommerce.Commerces do
  @moduledoc """
  The Commerces context.
  """

  import Ecto.Query, warn: false

  alias MateriaCommerce.Commerces.Contract
  alias MateriaUtils.Calendar.CalendarUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of contracts.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> list_contracts = MateriaCommerce.Commerces.list_contracts
  iex(2)> view = MateriaCommerceWeb.ContractView.render("index.json", %{contracts: list_contracts}) |> Enum.map(fn x -> Map.delete(x, :id) end)
  iex(3)> view = view |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end)
  [
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
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "100.01",
    start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: "ステータス1",
    tax_amount: "80",
    total_amount: "1180.01",
  },
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
    status: "ステータス2",
    tax_amount: "80",
    total_amount: "1190.01",
  },
  %{
    billing_address: nil,
    buyer_id: nil,
    contract_details: [],
    contract_no: "0000-0000-0000",
    contracted_date: "",
    delivery_address: nil,
    delivery_end_datetime: "",
    delivery_start_datetime: "",
    end_datetime: "2019-02-01 17:59:59.000000+09:00 JST Asia/Tokyo",
    expiration_date: "",
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "200",
    start_datetime: "2019-01-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: "ステータス3",
    tax_amount: "80",
    total_amount: "1280",
  },
  %{
    billing_address: nil,
    buyer_id: nil,
    contract_details: [],
    contract_no: "1111-1111-1111",
    contracted_date: "",
    delivery_address: nil,
    delivery_end_datetime: "",
    delivery_start_datetime: "",
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    expiration_date: "",
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "200",
    start_datetime: "2018-01-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: "ステータス",
    tax_amount: "80",
    total_amount: "1280",
  }
  ]
  """
  def list_contracts do
    @repo.all(Contract)
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
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "100.01",
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  status: "ステータス1",
  tax_amount: "80",
  total_amount: "1180.01",
  }
  """
  def get_contract!(id), do: @repo.get!(Contract, id)

  @doc """
  Creates a contract.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attrs = %{"contract_no" => "TEST","settlement" => "TEST","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => "ステータス","start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59"}
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
  status: "ステータス",
  tax_amount: "99",
  total_amount: "9999",
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
  contract_details: [],
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
  status: "ステータス1",
  tax_amount: "80",
  total_amount: "1180.01",
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
  status: "ステータス2",
  tax_amount: "80",
  total_amount: "1190.01"
  }
  """
  def get_current_contract_history(base_datetime, key_word_list) do
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
  [
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
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "100.01",
    start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: "ステータス1",
    tax_amount: "80",
    total_amount: "1180.01"
  },
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
    status: "ステータス2",
    tax_amount: "80",
    total_amount: "1190.01"
  },
  %{
    billing_address: nil,
    buyer_id: nil,
    contract_details: [],
    contract_no: "1111-1111-1111",
    contracted_date: "",
    delivery_address: nil,
    delivery_end_datetime: "",
    delivery_start_datetime: "",
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
    expiration_date: "",
    lock_version: 0,
    seller_id: nil,
    sender_address: nil,
    settlement: "9999-9999-9999",
    shipping_fee: "200",
    start_datetime: "2018-01-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    status: "ステータス",
    tax_amount: "80",
    total_amount: "1280"
  }
  ]
  """
  def delete_future_contract_histories(base_datetime, key_word_list) do
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
  status: "ステータス2",
  tax_amount: "80",
  total_amount: "1190.01"
  }
  """
  def get_recent_contract_history(base_datetime, key_word_list) do
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
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "110.01",
  start_datetime: "2018-12-01 09:00:00Z",
  status: "ステータス2",
  tax_amount: "80",
  total_amount: "1190.01"
  }
  iex(5)> attrs = %{"contract_no" => "0000-0000-0000","settlement" => "9999-9999-9999","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => "ステータス", "lock_version" => recent.lock_version}
  iex(6)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, key_word_list, attrs)
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
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
  status: "ステータス",
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
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 09:00:00Z",
  status: "ステータス",
  tax_amount: "99",
  total_amount: "9999"
  }
  iex(12)> attrs = %{"contract_no" => "0000-0000-0000","settlement" => "8888-8888-8888","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => "ステータス", "lock_version" => recent.lock_version}
  iex(13)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, next_start_date, key_word_list, attrs)
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
  lock_version: 2,
  seller_id: nil,
  sender_address: nil,
  settlement: "8888-8888-8888",
  shipping_fee: "9999",
  start_datetime: "2019-12-17 18:00:00+09:00 JST Asia/Tokyo",
  status: "ステータス",
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
  lock_version: 1,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "9999",
  start_datetime: "2018-12-17 09:00:00Z",
  status: "ステータス",
  tax_amount: "99",
  total_amount: "9999"
  }
  """
  def create_new_contract_history(%{}, start_datetime, key_word_list, attr) do

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
        {:ok, contract} = create_contract(attr)
        # 直近の履歴のend_datetimeを更新する
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_contract = struct(Contract, recent_contract)
        update_contract(struct_contract, %{end_datetime: recent_end_datetime})
        {:ok, contract}
      end
  end


  alias MateriaCommerce.Commerces.ContractDetail

  @doc """
  Returns the list of contract_details.

  ## Examples

#      iex> list_contract_details()
#      [%ContractDetail{}, ...]

  """
  def list_contract_details do
    @repo.all(ContractDetail)
  end

  @doc """
  Gets a single contract_detail.

  Raises `Ecto.NoResultsError` if the Contract detail does not exist.

  ## Examples

#      iex> get_contract_detail!(123)
#      %ContractDetail{}
#
#      iex> get_contract_detail!(456)
#      ** (Ecto.NoResultsError)

  """
  def get_contract_detail!(id), do: @repo.get!(ContractDetail, id)

  @doc """
  Creates a contract_detail.

  ## Examples

#      iex> create_contract_detail(%{field: value})
#      {:ok, %ContractDetail{}}
#
#      iex> create_contract_detail(%{field: bad_value})
#      {:error, %Ecto.Changeset{}}

  """
  def create_contract_detail(attrs \\ %{}) do
    %ContractDetail{}
    |> ContractDetail.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a contract_detail.

  ## Examples

#      iex> update_contract_detail(contract_detail, %{field: new_value})
#      {:ok, %ContractDetail{}}
#
#      iex> update_contract_detail(contract_detail, %{field: bad_value})
#      {:error, %Ecto.Changeset{}}

  """
  def update_contract_detail(%ContractDetail{} = contract_detail, attrs) do
    contract_detail
    |> ContractDetail.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ContractDetail.

  ## Examples

#      iex> delete_contract_detail(contract_detail)
#      {:ok, %ContractDetail{}}
#
#      iex> delete_contract_detail(contract_detail)
#      {:error, %Ecto.Changeset{}}

  """
  def delete_contract_detail(%ContractDetail{} = contract_detail) do
    @repo.delete(contract_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract_detail changes.

  ## Examples

#      iex> change_contract_detail(contract_detail)
#      %Ecto.Changeset{source: %ContractDetail{}}

  """
  def change_contract_detail(%ContractDetail{} = contract_detail) do
    ContractDetail.changeset(contract_detail, %{})
  end
end
