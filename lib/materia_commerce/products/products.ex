defmodule MateriaCommerce.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias MateriaCommerce.Repo

  alias MateriaCommerce.Products.Item
  alias MateriaUtils.Calendar.CalendarUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of items.

  ## Examples
  #    iex> list_items()
  #    [%Item{}, ...]

  """
  def list_items do
    @repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples
  #    iex> get_item!(123)
  #    %Item{}
  #
  #    iex> get_item!(456)
  #    ** (Ecto.NoResultsError)

  """
  def get_item!(id) do
    @repo.get!(Item, id)
  end

  @doc """
  Creates a item.

  ## Examples
  #    iex> create_item(%{field: value})
  #    {:ok, %Item{}}
  #
  #    iex> create_item(%{field: bad_value})
  #    {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples
  #    iex> update_item(item, %{field: new_value})
  #    {:ok, %Item{}}
  #
  #    iex> update_item(item, %{field: bad_value})
  #    {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Item.

  ## Examples
  #    iex> delete_item(item)
  #    {:ok, %Item{}}
  #
  #    iex> delete_item(item)
  #    {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    @repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

  #    iex> change_item(item)
  #    %Ecto.Changeset{source: %Item{}}

  """
  #def change_item(%Item{} = item) do
  #  Item.changeset(item, %{})
  #end

  @doc """
  主キーを想定したパラメータで現在のItem情報を取得する

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> current_item = MateriaCommerce.Products.get_current_item_history(base_datetime, [{:item_code, "ICZ1000"}]) |> Map.delete(:id)
  iex(3)> current_item.status
  1
  """
  def get_current_item_history(base_datetime, key_word_list) do
    items = MateriaUtils.Ecto.EctoUtil.list_current_history(
      @repo,
      MateriaCommerce.Products.Item,
      base_datetime,
      key_word_list
    )
    item =
    if items == [] do
      nil
    else
      [item] = items
      item
    end
  end

  @doc false
  def delete_future_item_histories(base_datetime, key_word_list) do
    items = MateriaUtils.Ecto.EctoUtil.delete_future_histories(
      @repo,
      MateriaCommerce.Products.Item,
      base_datetime,
      key_word_list
    )
  end

  @doc """
  現在以前の直近のitem情報を取得する
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> recent_item = MateriaCommerce.Products.get_recent_item_history(base_datetime, [{:item_code, "ICZ1000"}]) |> Map.delete(:id)
  iex(3)> recent_item.status
  0
  """
  def get_recent_item_history(base_datetime, key_word_list) do
    items = MateriaUtils.Ecto.EctoUtil.list_recent_history(
      @repo,
      MateriaCommerce.Products.Item,
      base_datetime,
      key_word_list
    )
    if items == [] do
      nil
    else
      [item] = items
      item
    end
  end

  @doc """
  新規のitem情報履歴を登録する
  start_datetimeに指定した以降の先日付の登録データがある場合、削除して登録する。

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> attr = %{"name" => "新商品", "item_code" => "CZ3000"}
  iex(3)> {:ok, item} = MateriaCommerce.Products.create_new_item_history(%{}, base_datetime, [{:item_code, "CZ3000"}], attr)
  iex(4)> item.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(5)> item.end_datetime
  #DateTime<9999-12-31 23:59:59Z>
  iex(6)> {:ok, next_start_date} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
  iex(7)> attr = %{"name" => "新商品改訂版", "item_code" => "CZ3000", "lock_version" => 0}
  iex(8)> {:ok, item} = MateriaCommerce.Products.create_new_item_history(%{}, next_start_date, [{:item_code, "CZ3000"}], attr)
  iex(9)> MateriaCommerce.Products.get_recent_item_history(base_datetime, [{:item_code, "CZ3000"}])
  nil
  iex(10)> item = MateriaCommerce.Products.get_current_item_history(base_datetime, [{:item_code, "CZ3000"}])
  iex(11)> item.start_datetime
  #DateTime<2018-12-17 09:00:00.000000Z>
  iex(12)> item.end_datetime
  #DateTime<2019-12-17 08:59:59.000000Z>
  iex(13)> item = MateriaCommerce.Products.get_current_item_history(next_start_date, [{:item_code, "CZ3000"}])
  iex(14)> item.start_datetime
  #DateTime<2019-12-17 09:00:00.000000Z>
  iex(15)> item.end_datetime
  #DateTime<9999-12-31 23:59:59.000000Z>
  iex(16)> item = MateriaCommerce.Products.get_recent_item_history(next_start_date, [{:item_code, "CZ3000"}])
  iex(17)> item.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(18)> item.end_datetime
  #DateTime<2019-12-17 08:59:59Z>
  """
  def create_new_item_history(%{}, start_datetime, key_word_list, attr) do

   {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")

    recent_item = get_recent_item_history(start_datetime, key_word_list)

    #未来日付のデータがある場合削除する
    {i, _reason} = delete_future_item_histories(start_datetime, key_word_list)
    item =
    if recent_item == nil do
      # 新規登録
      attr = attr
      |> Map.put("start_datetime", start_datetime)
      |> Map.put("end_datetime", end_datetime)
      attr =
      #if Map.has_key?(attr, "end_datetime") do
      #  attr
      #else
      #   Map.put(attr, "end_datetime", end_datetime)
      #end
      {:ok, item} = create_item(attr)
    else
      # 2回目以降のヒストリー登録の場合
      # 楽観排他チェック
      if !Map.has_key?(attr, "lock_version") || attr["lock_version"] != recent_item.lock_version do
        raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
      end

      attr = Map.keys(attr)
      |> Enum.reduce(recent_item, fn(key, acc) ->
        acc = acc
        |> Map.put(String.to_atom(key), attr[key])
      end)

      attr = attr
      |> Map.put(:lock_version, recent_item.lock_version + 1)
      |> Map.put(:start_datetime, start_datetime)
      |> Map.put(:end_datetime, end_datetime)
      #if !Map.has_key?(attr, :end_datetime) do
      #  attr = Map.put(attr, :end_datetime, end_datetime)
      #end
      {:ok, item} =create_item(attr)
      # 直近の履歴のend_datetimeを更新する
      recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
      struct_item = struct(Item, recent_item)
      update_item(struct_item, %{end_datetime: recent_end_datetime})
      {:ok, item}
    end


  end


  alias MateriaCommerce.Products.Tax

  @doc """
  Returns the list of taxes.

  ## Examples

      iex> list_taxes()
      [%Tax{}, ...]

  """
  def list_taxes do
    @repo.all(Tax)
  end

  @doc """
  Gets a single tax.

  Raises `Ecto.NoResultsError` if the Tax does not exist.

  ## Examples

      iex> get_tax!(123)
      %Tax{}

      iex> get_tax!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tax!(id), do: @repo.get!(Tax, id)

  @doc """
  主キーを想定したパラメータで現在のTax情報を取得する

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> current_tax = MateriaCommerce.Products.get_current_tax_history(base_datetime, [{:tax_category, "category1"}])
  iex(3)> current_tax.name
  "test2 tax"
  """
  def get_current_tax_history(base_datetime, key_word_list) do
    taxes = MateriaUtils.Ecto.EctoUtil.list_current_history(
      @repo,
      MateriaCommerce.Products.Tax,
      base_datetime,
      key_word_list
    )
    tax =
    if taxes == [] do
      nil
    else
      [tax] = taxes
      tax
    end
  end

  @doc false
  def delete_future_tax_histories(base_datetime, key_word_list) do
    MateriaUtils.Ecto.EctoUtil.delete_future_histories(
      @repo,
      MateriaCommerce.Products.Tax,
      base_datetime,
      key_word_list
    )
  end

  @doc """
  現在以前の直近のtax情報を取得する
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> current_tax = MateriaCommerce.Products.get_recent_tax_history(base_datetime, [{:tax_category, "category1"}])
  iex(3)> current_tax.name
  "test1 tax"
  """
  def get_recent_tax_history(base_datetime, key_word_list) do
    taxes = MateriaUtils.Ecto.EctoUtil.list_recent_history(
      @repo,
      MateriaCommerce.Products.Tax,
      base_datetime,
      key_word_list
    )
    if taxes == [] do
      nil
    else
      [tax] = taxes
      tax
    end
  end

  @doc """
  新規のtax情報履歴を登録する
  start_datetimeに指定した以降の先日付の登録データがある場合、削除して登録する。

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> attr = %{"name" => "test1 tax", "tax_category" => "category1", tax_rate => 0.3}
  iex(3)> {:ok, tax} = MateriaCommerce.Products.create_new_tax_history(%{}, base_datetime, [{:tax_category, "category1"}], attr)
  iex(4)> tax.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(5)> tax.end_datetime
  #DateTime<9999-12-31 23:59:59Z>
  iex(6)> {:ok, next_start_date} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
  iex(7)> attr = %{"name" => "test1 tax", "tax_category" => "category1", tax_rate => 0.3, "lock_version" => 0}
  iex(8)> {:ok, tax} = MateriaCommerce.Products.create_new_tax_history(%{}, next_start_date, [{:tax_category, "category1"}], attr)
  iex(9)> MateriaCommerce.Products.get_recent_tax_history(base_datetime, [{:tax_category, "category1"}])
  nil
  iex(10)> tax = MateriaCommerce.Products.get_current_tax_history(base_datetime, [{:tax_category, "category1"}])
  iex(11)> tax.start_datetime
  #DateTime<2018-12-17 09:00:00.000000Z>
  iex(12)> tax.end_datetime
  #DateTime<2019-12-17 08:59:59.000000Z>
  iex(13)> tax = MateriaCommerce.Products.get_current_tax_history(next_start_date, [{:tax_category, "category1"}])
  iex(14)> tax.start_datetime
  #DateTime<2019-12-17 09:00:00.000000Z>
  iex(15)> tax.end_datetime
  #DateTime<9999-12-31 23:59:59.000000Z>
  iex(16)> tax = MateriaCommerce.Products.get_recent_tax_history(next_start_date, [{:tax_category, "category1"}])
  iex(17)> tax.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(18)> tax.end_datetime
  #DateTime<2019-12-17 08:59:59Z>
  """
  def create_new_tax_history(%{}, start_datetime, key_word_list, attr) do

    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
 
     recent_tax = get_recent_tax_history(start_datetime, key_word_list)

     #未来日付のデータがある場合削除する
     {i, _reason} = delete_future_tax_histories(start_datetime, key_word_list)
     tax =
     if recent_tax == nil do
       # 新規登録
       attr = attr
       |> Map.put("start_datetime", start_datetime)
       |> Map.put("end_datetime", end_datetime)
       attr =
       #if Map.has_key?(attr, "end_datetime") do
       #  attr
       #else
       #   Map.put(attr, "end_datetime", end_datetime)
       #end
       {:ok, tax} = create_tax(attr)
     else
       # 2回目以降のヒストリー登録の場合
       # 楽観排他チェック
       _ = cond do
        !Map.has_key?(attr, "lock_version") -> raise KeyError, message: "parameter have not lock_version"
        attr["lock_version"] != recent_tax.lock_version -> raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
        true -> :ok
       end
 
       attr = Map.keys(attr)
       |> Enum.reduce(recent_tax, fn(key, acc) ->
         acc = acc
         |> Map.put(String.to_atom(key), attr[key])
       end)
 
       attr = attr
       |> Map.put(:lock_version, recent_tax.lock_version + 1)
       |> Map.put(:start_datetime, start_datetime)
       |> Map.put(:end_datetime, end_datetime)
       #if !Map.has_key?(attr, :end_datetime) do
       #  attr = Map.put(attr, :end_datetime, end_datetime)
       #end
       {:ok, tax} = create_tax(attr)
       # 直近の履歴のend_datetimeを更新する
       recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
       struct_tax = struct(Tax, recent_tax)
       update_tax(struct_tax, %{end_datetime: recent_end_datetime})
       {:ok, tax}
     end
 
   end
  
  @doc """
  Creates a tax.

  ## Examples

      iex> create_tax(%{field: value})
      {:ok, %Tax{}}

      iex> create_tax(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tax(attrs \\ %{}) do
    %Tax{}
    |> Tax.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a tax.

  ## Examples

      iex> update_tax(tax, %{field: new_value})
      {:ok, %Tax{}}

      iex> update_tax(tax, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tax(%Tax{} = tax, attrs) do
    tax
    |> Tax.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Tax.

  ## Examples

      iex> delete_tax(tax)
      {:ok, %Tax{}}

      iex> delete_tax(tax)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tax(%Tax{} = tax) do
    @repo.delete(tax)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tax changes.

  ## Examples

      iex> change_tax(tax)
      %Ecto.Changeset{source: %Tax{}}

  """
  def change_tax(%Tax{} = tax) do
    Tax.changeset(tax, %{})
  end

  alias MateriaCommerce.Products.Price

  @doc """
  Returns the list of prices.

  ## Examples

      iex> list_prices()
      [%Price{}, ...]

  """
  def list_prices do
    @repo.all(Price)
  end

  @doc """
  Gets a single price.

  Raises `Ecto.NoResultsError` if the Price does not exist.

  ## Examples

      iex> get_price!(123)
      %Price{}

      iex> get_price!(456)
      ** (Ecto.NoResultsError)

  """
  def get_price!(id), do: @repo.get!(Price, id)


  @doc """
  主キーを想定したパラメータで現在のPrice情報を取得する

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> current_price = MateriaCommerce.Products.get_current_price_history(base_datetime, [{:item_code, "ICZ1000"}])
  iex(3)> current_price.unit_price
  Decimal.new(200)
  """
  def get_current_price_history(base_datetime, key_word_list) do
    prices = MateriaUtils.Ecto.EctoUtil.list_current_history(
      @repo,
      MateriaCommerce.Products.Price,
      base_datetime,
      key_word_list
    )
    if prices == [] do
      nil
    else
      [price] = prices
      price
    end
  end

  @doc false
  def delete_future_price_histories(base_datetime, key_word_list) do
    MateriaUtils.Ecto.EctoUtil.delete_future_histories(
      @repo,
      MateriaCommerce.Products.Price,
      base_datetime,
      key_word_list
    )
  end

  @doc """
  現在以前の直近のPrice情報を取得する
  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> current_price = MateriaCommerce.Products.get_recent_price_history(base_datetime, [{:item_code, "ICZ1000"}])
  iex(3)> current_price.unit_price
  Decimal.new(100)
  """
  def get_recent_price_history(base_datetime, key_word_list) do
    prices = MateriaUtils.Ecto.EctoUtil.list_recent_history(
      @repo,
      MateriaCommerce.Products.Price,
      base_datetime,
      key_word_list
    )
    if prices == [] do
      nil
    else
      [price] = prices
      price
    end
  end

  @doc """
  新規のprice情報履歴を登録する
  start_datetimeに指定した以降の先日付の登録データがある場合、削除して登録する。

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> recent = MateriaCommerce.Products.get_recent_price_history(base_datetime, [{:item_code, "ICZ1000"}])
  iex(3)> recent.start_datetime
  #DateTime<2018-12-01 09:00:00Z>
  iex(4)> recent.end_datetime
  #DateTime<2019-01-01 08:59:59Z>
  iex(5)> recent.lock_version
  0
  iex(6)> attr = %{"description" => "add price", "item_code" => "ICZ1000", "unit_price" => 400, "lock_version" => recent.lock_version}
  iex(7)> {:ok, price} = MateriaCommerce.Products.create_new_price_history(%{}, base_datetime, [{:item_code, "ICZ1000"}], attr)
  iex(8)> price.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(9)> price.end_datetime
  #DateTime<9999-12-31 23:59:59Z>
  iex(10)> recent = MateriaCommerce.Products.get_recent_price_history(base_datetime, [{:item_code, "ICZ1000"}])
  iex(11)> recent.start_datetime
  #DateTime<2018-12-01 09:00:00Z>
  iex(12)> recent.end_datetime
  #DateTime<2018-12-17 08:59:59Z>
  iex(13)> {:ok, next_start_date} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2019-12-17 09:00:00Z")
  iex(14)> recent = MateriaCommerce.Products.get_recent_price_history(next_start_date, [{:item_code, "ICZ1000"}])
  iex(15)> recent.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(16)> recent.end_datetime
  #DateTime<9999-12-31 23:59:59Z>
  iex(17)> recent.lock_version
  1
  iex(18)> attr = %{"description" => "add price", "item_code" => "ICZ1000", "unit_price" => 400, "lock_version" => recent.lock_version}
  iex(19)> {:ok, price} = MateriaCommerce.Products.create_new_price_history(%{}, next_start_date, [{:item_code, "ICZ1000"}], attr)
  iex(20)> price.start_datetime
  #DateTime<2019-12-17 09:00:00Z>
  iex(21)> price.end_datetime
  #DateTime<9999-12-31 23:59:59Z>
  iex(22)> recent = MateriaCommerce.Products.get_recent_price_history(next_start_date, [{:item_code, "ICZ1000"}])
  iex(23)> recent.start_datetime
  #DateTime<2018-12-17 09:00:00Z>
  iex(24)> recent.end_datetime
  #DateTime<2019-12-17 08:59:59Z>
  """
  def create_new_price_history(%{}, start_datetime, key_word_list, attr) do

    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")

    recent_price = get_recent_price_history(start_datetime, key_word_list)

    #未来日付のデータがある場合削除する
    {i, _reason} = delete_future_price_histories(start_datetime, key_word_list)
    tax =
      if recent_price == nil do
        # 新規登録
        attr = attr
               |> Map.put("start_datetime", start_datetime)
               |> Map.put("end_datetime", end_datetime)
        attr =
          #if Map.has_key?(attr, "end_datetime") do
          #  attr
          #else
          #   Map.put(attr, "end_datetime", end_datetime)
          #end
          {:ok, price} = create_price(attr)
      else
        # 2回目以降のヒストリー登録の場合
        # 楽観排他チェック
        _ = cond do
          !Map.has_key?(attr, "lock_version") -> raise KeyError, message: "parameter have not lock_version"
          attr["lock_version"] != recent_price.lock_version -> raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
          true -> :ok
        end

        attr = Map.keys(attr)
               |> Enum.reduce(recent_price, fn(key, acc) ->
          acc = acc
                |> Map.put(String.to_atom(key), attr[key])
        end)

        attr = attr
               |> Map.put(:lock_version, recent_price.lock_version + 1)
               |> Map.put(:start_datetime, start_datetime)
               |> Map.put(:end_datetime, end_datetime)
        #if !Map.has_key?(attr, :end_datetime) do
        #  attr = Map.put(attr, :end_datetime, end_datetime)
        #end
        {:ok, price} = create_price(attr)
        # 直近の履歴のend_datetimeを更新する
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_price = struct(Price, recent_price)
        update_price(struct_price, %{end_datetime: recent_end_datetime})
        {:ok, price}
      end

  end

  @doc """
  Creates a price.

  ## Examples

      iex> create_price(%{field: value})
      {:ok, %Price{}}

      iex> create_price(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_price(attrs \\ %{}) do
    %Price{}
    |> Price.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a price.

  ## Examples

      iex> update_price(price, %{field: new_value})
      {:ok, %Price{}}

      iex> update_price(price, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_price(%Price{} = price, attrs) do
    price
    |> Price.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Price.

  ## Examples

      iex> delete_price(price)
      {:ok, %Price{}}

      iex> delete_price(price)
      {:error, %Ecto.Changeset{}}

  """
  def delete_price(%Price{} = price) do
    @repo.delete(price)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking price changes.

  ## Examples

      iex> change_price(price)
      %Ecto.Changeset{source: %Price{}}

  """
  def change_price(%Price{} = price) do
    Price.changeset(price, %{})
  end


  @doc """
  主キーを想定したパラメータで現在のItem情報を取得し､
  ・Item情報のitem_codeからPrice情報を取得
  ・Item情報のtax_categoryからTax情報を取得する｡
  Returns: [%{product: %{item: %Item{}, price: %Price{}, tax: %Tax{}}}]

  iex(1)> {:ok, base_datetime} = MateriaUtils.Calendar.CalendarUtil.parse_iso_extended_z("2018-12-17 09:00:00Z")
  iex(2)> key_word_list = [{:item_code, "ICZ1000"}]
  iex(3)> current_product = MateriaCommerce.Products.get_current_products(base_datetime, key_word_list)
  iex(4)> current_product |> List.first()
  %{
  product: %{
    item: %MateriaCommerce.Products.Item{
      __meta__: #Ecto.Schema.Metadata<:loaded, "items">,
      category1: "電化製品",
      category2: "調理器具",
      category3: "炊飯器",
      category4: "2020年モデル",
      color: "Blue",
      delivery_area: "離島のぞく",
      description: "高級炊飯器",
      end_datetime: #DateTime<2019-12-31 08:59:59.000000Z>,
      id: 2,
      image_url: "http://z1000.com/img.png",
      inserted_at: ~N[2019-01-17 09:44:41.048099],
      item_code: "ICZ1000",
      jan_code: "123456789123",
      lock_version: 0,
      manufacturer: "松芝電気",
      model_number: "Z1000",
      name: "炊飯器Z1000",
      size1: "H30cm",
      size2: "W40cm",
      size3: "D40cm",
      size4: "外装 60cm×60cm×50cm",
      start_datetime: #DateTime<2018-12-17 09:00:00.000000Z>,
      status: 1,
      tax_category: "一般消費税",
      thumbnail: "hogehoge",
      updated_at: ~N[2019-01-17 09:44:41.048106],
      weight1: "本体重量 1.2kg",
      weight2: "梱包重量 1.5kg",
      weight3: "最大重量 2.0kg",
      weight4: "最小重量 1.0kg"
    },
    price: %MateriaCommerce.Products.Price{
      __meta__: #Ecto.Schema.Metadata<:loaded, "prices">,
      description: "test2 price",
      end_datetime: #DateTime<2019-01-01 08:59:59.000000Z>,
      id: 2,
      inserted_at: ~N[2019-01-17 09:44:41.088508],
      item_code: "ICZ1000",
      lock_version: 0,
      start_datetime: #DateTime<2018-12-01 09:00:00.000000Z>,
      unit_price: #Decimal<200>,
      updated_at: ~N[2019-01-17 09:44:41.088514]
    },
    tax: %MateriaCommerce.Products.Tax{
      __meta__: #Ecto.Schema.Metadata<:loaded, "taxes">,
      end_datetime: #DateTime<9999-12-31 23:59:59.000000Z>,
      id: 5,
      inserted_at: ~N[2019-01-17 09:44:41.086082],
      lock_version: 0,
      name: "一般消費税",
      start_datetime: #DateTime<2018-01-01 09:00:00.000000Z>,
      tax_category: "一般消費税",
      tax_rate: #Decimal<100>,
      updated_at: ~N[2019-01-17 09:44:41.086086]
    }
  }
  }
  """
  def get_current_products(base_datetime, key_word_list) do

    tax = MateriaCommerce.Products.Tax
          |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)
    price = MateriaCommerce.Products.Price
            |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)
    item = MateriaCommerce.Products.Item
           |> where([q], q.start_datetime <= ^base_datetime and q.end_datetime >= ^base_datetime)

    # AddPk
    item = [key_word_list]
          |> Enum.reduce(item, fn(key_word, acc) ->
      acc
      |> where(^key_word)
    end)

    item
    |> join(:left, [i], p in subquery(price), item_code: i.item_code)
    |> join(:left, [i], t in subquery(tax), tax_category: i.tax_category)
    |> select([i, p, t], %{item: i, price: p, tax: t})
    |> @repo.all()
    |> Enum.map(
         fn result ->
           item = result.item
           item =
             cond do
               result.price.id != nil ->
                 Map.put(item, :price, result.price)
               true ->
                 Map.put(item, :price, nil)
             end
           item =
             cond do
               result.tax.id != nil ->
                 Map.put(item, :tax, result.tax)
               true ->
                 Map.put(item, :tax, nil)
             end
         end
       )
  end
end
