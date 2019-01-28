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
    status: 1,
    tax_amount: "80",
    total_amount: "1180.01",
  },
  %{
    billing_address: nil,
    buyer_id: nil,
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
  },
  %{
    billing_address: nil,
    buyer_id: nil,
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
    status: 3,
    tax_amount: "80",
    total_amount: "1280",
  },
  %{
    billing_address: nil,
    buyer_id: nil,
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
    status: 0,
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
  status: 1,
  tax_amount: "80",
  total_amount: "1180.01",
  }
  """
  def get_contract!(id), do: @repo.get!(Contract, id)

  @doc """
  Creates a contract.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attrs = %{"contract_no" => "TEST","settlement" => "TEST","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => 0,"start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59"}
  iex(2)> {:ok, contract} = MateriaCommerce.Commerces.create_contract(attrs)
  iex(3)> view = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(4)> view = [view] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
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
    status: 1,
    tax_amount: "80",
    total_amount: "1180.01"
  },
  %{
    billing_address: nil,
    buyer_id: nil,
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
    total_amount: "1190.01"
  },
  %{
    billing_address: nil,
    buyer_id: nil,
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
    status: 0,
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
  status: 2,
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
  status: 2,
  tax_amount: "80",
  total_amount: "1190.01"
  }
  iex(5)> attrs = %{"contract_no" => "0000-0000-0000","settlement" => "9999-9999-9999","shipping_fee" => 9999,"tax_amount" => 99,"total_amount" => 9999,"status" => 0, "lock_version" => recent.lock_version}
  iex(6)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, base_datetime, key_word_list, attrs)
  iex(7)> contract = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(8)> contract = [contract] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
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
  iex(13)> {:ok, contract} = MateriaCommerce.Commerces.create_new_contract_history(%{}, next_start_date, key_word_list, attrs)
  iex(14)> contract = MateriaCommerceWeb.ContractView.render("show.json", %{contract: contract}) |> Map.delete(:id)
  iex(15)> contract = [contract] |> Enum.map(fn x -> x =  Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at) end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
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
  iex(1)> contract_details = MateriaCommerce.Commerces.list_contract_details
  iex(2)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(3)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  iex(4)> Enum.count(view)
  6
  """
  def list_contract_details do
    @repo.all(ContractDetail)
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
  amount: 1,
  category1: "Single Detail",
  category2: nil,
  category3: nil,
  category4: nil,
  color: nil,
  contract_name: nil,
  contract_no: "0000-0000-0000",
  delivery_area: nil,
  description: nil,
  end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
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
  start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
  tax_category: nil,
  thumbnail: nil,
  weight1: nil,
  weight2: nil,
  weight3: nil,
  weight4: nil
  }
  """
  def get_contract_detail!(id), do: @repo.get!(ContractDetail, id)

  @doc """
  Creates a contract_detail.

  ## Examples
  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> attr = %{"contract_name" => "TEST1", "contract_no" => "0000-0000-0000", "start_datetime" => "2018-01-01 09:00:00","end_datetime" => "2999-12-31 23:59:59"}
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
  weight4: nil
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
  weight4: nil
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
    weight4: nil
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
    weight4: nil
  }
  ]
  """
  def get_current_contract_detail_history(base_datetime, key_word_list) do
    MateriaUtils.Ecto.EctoUtil.list_current_history(@repo, ContractDetail, base_datetime, key_word_list)
  end

  @doc """
  start_datetimeに指定した以降の先日付の登録データがある場合、削除する｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> MateriaCommerce.Commerces.delete_future_contract_detail_histories(base_datetime, key_word_list)
  iex(4)> contract_details = MateriaCommerce.Commerces.list_contract_details
  iex(5)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(6)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
  %{
    amount: 1,
    category1: "Single Detail",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: nil,
    contract_no: "0000-0000-0000",
    delivery_area: nil,
    description: nil,
    end_datetime: "2018-12-01 17:59:59.000000+09:00 JST Asia/Tokyo",
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
    start_datetime: "2018-11-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
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
    weight4: nil
  },
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
    weight4: nil
  },
  %{
    amount: 1,
    category1: "Single Detail",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: nil,
    contract_no: "1111-1111-1111",
    delivery_area: nil,
    description: nil,
    end_datetime: "3000-01-01 08:59:59.000000+09:00 JST Asia/Tokyo",
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
    start_datetime: "2018-01-01 18:00:00.000000+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  }
  ]
  """
  def delete_future_contract_detail_histories(base_datetime, key_word_list) do
    MateriaUtils.Ecto.EctoUtil.delete_future_histories(@repo, ContractDetail, base_datetime, key_word_list)
  end

  @doc """
  現在以前の直近のContractDetails情報を取得する
  Contract -> 1: ContractDetail -> N の関係のため複数件を返す｡

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> contract_details = MateriaCommerce.Commerces.get_recent_contract_detail_history(base_datetime, key_word_list)
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
    end_datetime: "2019-01-01 17:59:59+09:00 JST Asia/Tokyo",
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
    start_datetime: "2018-12-01 18:00:00+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
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
    end_datetime: "2019-01-01 17:59:59+09:00 JST Asia/Tokyo",
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
    start_datetime: "2018-12-01 18:00:00+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  }
  ]
  """
  def get_recent_contract_detail_history(base_datetime, key_word_list) do
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
    weight4: nil
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
    end_datetime: "2019-01-01 08:59:59Z",
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
    start_datetime: "2018-12-01 09:00:00Z",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  }
  ]
  iex(5)> attrs = [%{"contract_no" => "0000-0000-0000","contract_name" => "TEST2","id" => 2,"lock_version" => 0,"price" => 2000,},%{"contract_no" => "0000-0000-0000","contract_name" => "TEST3","id" => 3,"lock_version" => 0,"price" => 3000,},%{"contract_no" => "0000-0000-0000","contract_name" => "TEST1","amount" => 1,"price" => 1000,}]
  iex(6)> {:ok, contract_details} = MateriaCommerce.Commerces.create_new_contract_detail_history(%{}, base_datetime, key_word_list, attrs)
  iex(7)> view = MateriaCommerceWeb.ContractDetailView.render("index.json", %{contract_details: contract_details})
  iex(8)> view = view |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end)
  [
  %{
    amount: 2,
    category1: "Multiple Details:1",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: "TEST2",
    contract_no: "0000-0000-0000",
    delivery_area: nil,
    description: nil,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    image_url: nil,
    item_code: nil,
    jan_code: nil,
    lock_version: 1,
    manufacturer: nil,
    merchandise_cost: "",
    model_number: nil,
    name: nil,
    price: "2000",
    purchase_amount: "",
    size1: nil,
    size2: nil,
    size3: nil,
    size4: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  },
  %{
    amount: 3,
    category1: "Multiple Details:2 With Item",
    category2: nil,
    category3: nil,
    category4: nil,
    color: nil,
    contract_name: "TEST3",
    contract_no: "0000-0000-0000",
    delivery_area: nil,
    description: nil,
    end_datetime: "3000-01-01 08:59:59+09:00 JST Asia/Tokyo",
    image_url: nil,
    item_code: "ICZ1000",
    jan_code: nil,
    lock_version: 1,
    manufacturer: nil,
    merchandise_cost: "",
    model_number: nil,
    name: nil,
    price: "3000",
    purchase_amount: "",
    size1: nil,
    size2: nil,
    size3: nil,
    size4: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  },
  %{
    amount: 1,
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
    lock_version: 1,
    manufacturer: nil,
    merchandise_cost: "",
    model_number: nil,
    name: nil,
    price: "1000",
    purchase_amount: "",
    size1: nil,
    size2: nil,
    size3: nil,
    size4: nil,
    start_datetime: "2018-12-17 18:00:00+09:00 JST Asia/Tokyo",
    tax_category: nil,
    thumbnail: nil,
    weight1: nil,
    weight2: nil,
    weight3: nil,
    weight4: nil
  }
  ]
  """
  def create_new_contract_detail_history(%{}, start_datetime, key_word_list, attrs) do

    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_contract_detail = get_recent_contract_detail_history(start_datetime, key_word_list)

    #未来日付のデータがある場合削除する
    {i, _reason} = delete_future_contract_detail_histories(start_datetime, key_word_list)
    contract_detail =
      if recent_contract_detail == [] do
        # 新規登録
        contract_detail = attrs
                          |> Enum.map(
                               fn attr ->
                                 attr = attr
                                        |> Map.put("start_datetime", start_datetime)
                                        |> Map.put("end_datetime", end_datetime)
                                 {:ok, contract_detail} = create_contract_detail(attr)
                                 contract_detail
                               end
                             )
        {:ok, contract_detail}
      else
        # 2回目以降のヒストリー登録の場合
        # 楽観排他チェック
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
  iex(8)>view = MateriaCommerceWeb.ContractDetailView.render("show.json", %{contract_detail: result})
  iex(9)>view = [view] |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id) end) |> List.first
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
  end_datetime: "2019-01-01 17:59:59+09:00 JST Asia/Tokyo",
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
  start_datetime: "2018-12-01 18:00:00+09:00 JST Asia/Tokyo",
  tax_category: nil,
  thumbnail: nil,
  weight1: nil,
  weight2: nil,
  weight3: nil,
  weight4: nil
  }
  """
  def check_recent_contract_detail(recent_contract_detail, id, lock_version) do
    filter = Enum.filter(recent_contract_detail, fn x -> x.id == id end) |> List.first
    cond do
      filter != nil and filter.lock_version != lock_version -> false
      true -> filter
    end
  end


  @doc """
  主キーを想定したパラメータで現在のContract情報を取得し､
  ・Contract情報のcontract_noからContractDetail情報を取得

  Returns: [%{contact: %Contract{}, contract_details: [%ContractDetail{}]}]

  iex(1)> Application.put_env(:materia_utils, :calender_locale, "Asia/Tokyo")
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:contract_no, "0000-0000-0000"}]
  iex(3)> current_commerces = MateriaCommerce.Commerces.get_current_commerces(base_datetime, key_word_list)
  iex(4)> first_data = current_commerces |> List.first
  iex(5)> [first_data.contract] |> Enum.map(fn x -> x = Map.put(x, :tax_amount, to_string(x.tax_amount)); x = Map.put(x, :shipping_fee, to_string(x.shipping_fee)); x = Map.put(x, :total_amount, to_string(x.total_amount)); x = Map.put(x, :delivery_start_datetime, to_string(x.delivery_start_datetime)); x = Map.put(x, :delivery_end_datetime, to_string(x.delivery_end_datetime)); x = Map.put(x, :expiration_date, to_string(x.expiration_date)); x = Map.put(x, :contracted_date, to_string(x.contracted_date)); x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id); x = Map.delete(x, :__meta__); x = Map.delete(x, :__struct__); end) |> List.first
  %{
  billing_address: nil,
  buyer_id: nil,
  contract_no: "0000-0000-0000",
  contracted_date: "",
  delivery_address: nil,
  delivery_end_datetime: "",
  delivery_start_datetime: "",
  end_datetime: "2019-01-01 08:59:59.000000Z",
  expiration_date: "",
  lock_version: 0,
  seller_id: nil,
  sender_address: nil,
  settlement: "9999-9999-9999",
  shipping_fee: "110.01",
  start_datetime: "2018-12-01 09:00:00.000000Z",
  status: 2,
  tax_amount: "80",
  total_amount: "1190.01"
  }
  iex(6)> first_data.contract_details |> Enum.map(fn x -> x =  Map.put(x, :price, to_string(x.price)); x = Map.put(x, :purchase_amount, to_string(x.purchase_amount)); x = Map.put(x, :merchandise_cost, to_string(x.merchandise_cost));  x = Map.put(x, :start_datetime, to_string(x.start_datetime)); x = Map.put(x, :end_datetime, to_string(x.end_datetime)); x = Map.delete(x, :inserted_at); x = Map.delete(x, :updated_at); x = Map.delete(x, :id); x = Map.delete(x, :__meta__); x = Map.delete(x, :__struct__); end)
  [
  %{
    price: "300",
    category1: "Multiple Details:2 With Item",
    lock_version: 0,
    size2: nil,
    manufacturer: nil,
    size1: nil,
    end_datetime: "2019-01-01 08:59:59.000000Z",
    weight3: nil,
    contract_name: nil,
    delivery_area: nil,
    image_url: nil,
    description: nil,
    category2: nil,
    category4: nil,
    weight4: nil,
    color: nil,
    size4: nil,
    weight2: nil,
    weight1: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    start_datetime: "2018-12-01 09:00:00.000000Z",
    size3: nil,
    model_number: nil,
    category3: nil,
    thumbnail: nil,
    item_code: "ICZ1000",
    jan_code: nil,
    merchandise_cost: "",
    amount: 3,
    name: nil,
    purchase_amount: ""
  },
  %{
    price: "200",
    category1: "Multiple Details:1",
    lock_version: 0,
    size2: nil,
    manufacturer: nil,
    size1: nil,
    end_datetime: "2019-01-01 08:59:59.000000Z",
    weight3: nil,
    contract_name: nil,
    delivery_area: nil,
    image_url: nil,
    description: nil,
    category2: nil,
    category4: nil,
    weight4: nil,
    color: nil,
    size4: nil,
    weight2: nil,
    weight1: nil,
    tax_category: nil,
    contract_no: "0000-0000-0000",
    start_datetime: "2018-12-01 09:00:00.000000Z",
    size3: nil,
    model_number: nil,
    category3: nil,
    thumbnail: nil,
    item_code: nil,
    jan_code: nil,
    merchandise_cost: "",
    amount: 2,
    name: nil,
    purchase_amount: ""
  }
  ]
  """
  def get_current_commerces(base_datetime, key_word_list) do
    contract_detail = MateriaCommerce.Commerces.ContractDetail
                      |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)

    contract = MateriaCommerce.Commerces.Contract
          |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)

    # AddPk
    contract = [key_word_list]
               |> Enum.reduce(
                    contract,
                    fn (key_word, acc) ->
                      acc
                      |> where(^key_word)
                    end
                  )

    results = contract
              |> join(:left, [c], cd in subquery(contract_detail), contract_no: c.contract_no)
              |> select([c, cd], %{contract: c, contract_details: cd})
              |> @repo.all()
              |> Enum.group_by(fn x -> x.contract end)

    results = results
              |> Map.keys()
              |> Enum.map(
                   fn key ->
                     %{
                       contract: key,
                       contract_details: results[key]
                                         |> Enum.map(fn result -> result.contract_details end)
                     }
                   end
                 )
  end
end


