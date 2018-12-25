defmodule MateriaCommerce.Commerces do
  @moduledoc """
  The Commerces context.
  """

  import Ecto.Query, warn: false

  alias MateriaCommerce.Commerces.Contract

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of contracts.

  ## Examples

      iex> list_contracts()
      [%Contract{}, ...]

  """
  def list_contracts do
    @repo.all(Contract)
  end

  @doc """
  Gets a single contract.

  Raises `Ecto.NoResultsError` if the Contract does not exist.

  ## Examples

      iex> get_contract!(123)
      %Contract{}

      iex> get_contract!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract!(id), do: @repo.get!(Contract, id)

  @doc """
  Creates a contract.

  ## Examples

      iex> create_contract(%{field: value})
      {:ok, %Contract{}}

      iex> create_contract(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract(attrs \\ %{}) do
    %Contract{}
    |> Contract.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a contract.

  ## Examples

      iex> update_contract(contract, %{field: new_value})
      {:ok, %Contract{}}

      iex> update_contract(contract, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract(%Contract{} = contract, attrs) do
    contract
    |> Contract.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Contract.

  ## Examples

      iex> delete_contract(contract)
      {:ok, %Contract{}}

      iex> delete_contract(contract)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract(%Contract{} = contract) do
    @repo.delete(contract)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract changes.

  ## Examples

      iex> change_contract(contract)
      %Ecto.Changeset{source: %Contract{}}

  """
  def change_contract(%Contract{} = contract) do
    Contract.changeset(contract, %{})
  end


  alias MateriaCommerce.Commerces.ContractDetail

  @doc """
  Returns the list of contract_details.

  ## Examples

      iex> list_contract_details()
      [%ContractDetail{}, ...]

  """
  def list_contract_details do
    @repo.all(ContractDetail)
  end

  @doc """
  Gets a single contract_detail.

  Raises `Ecto.NoResultsError` if the Contract detail does not exist.

  ## Examples

      iex> get_contract_detail!(123)
      %ContractDetail{}

      iex> get_contract_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_contract_detail!(id), do: @repo.get!(ContractDetail, id)

  @doc """
  Creates a contract_detail.

  ## Examples

      iex> create_contract_detail(%{field: value})
      {:ok, %ContractDetail{}}

      iex> create_contract_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_contract_detail(attrs \\ %{}) do
    %ContractDetail{}
    |> ContractDetail.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a contract_detail.

  ## Examples

      iex> update_contract_detail(contract_detail, %{field: new_value})
      {:ok, %ContractDetail{}}

      iex> update_contract_detail(contract_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_contract_detail(%ContractDetail{} = contract_detail, attrs) do
    contract_detail
    |> ContractDetail.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ContractDetail.

  ## Examples

      iex> delete_contract_detail(contract_detail)
      {:ok, %ContractDetail{}}

      iex> delete_contract_detail(contract_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_contract_detail(%ContractDetail{} = contract_detail) do
    @repo.delete(contract_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contract_detail changes.

  ## Examples

      iex> change_contract_detail(contract_detail)
      %Ecto.Changeset{source: %ContractDetail{}}

  """
  def change_contract_detail(%ContractDetail{} = contract_detail) do
    ContractDetail.changeset(contract_detail, %{})
  end
end
