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

   {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("9999-12-31 23:59:59Z")

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
end
