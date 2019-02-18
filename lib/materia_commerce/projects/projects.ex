defmodule MateriaCommerce.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias MateriaCommerce.Repo

  alias MateriaCommerce.Projects.Project
  alias MateriaCommerce.Projects.ProjectAppendix

  alias MateriaUtils.Ecto.EctoUtil
  alias MateriaUtils.Calendar.CalendarUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Project
    |> @repo.all()
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> @repo.get!(id)
    |> @repo.preload([:user, :inserted])
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    @repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  @doc """
  Returns the list of project_appendices.

  ## Examples

      iex> list_project_appendices()
      [%ProjectAppendix{}, ...]

  """
  def list_project_appendices do
    ProjectAppendix
    |> @repo.all()
    |> @repo.preload([:inserted])
  end

  @doc """
  Gets a single project_appendix.

  Raises `Ecto.NoResultsError` if the Project appendix does not exist.

  ## Examples

      iex> get_project_appendix!(123)
      %ProjectAppendix{}

      iex> get_project_appendix!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_appendix!(id) do
    ProjectAppendix
    |> @repo.get!(id)
    |> @repo.preload([:inserted])
  end

  @doc """
  Creates a project_appendix.

  ## Examples

      iex> create_project_appendix(%{field: value})
      {:ok, %ProjectAppendix{}}

      iex> create_project_appendix(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_appendix(attrs \\ %{}) do
    %ProjectAppendix{}
    |> ProjectAppendix.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a project_appendix.

  ## Examples

      iex> update_project_appendix(project_appendix, %{field: new_value})
      {:ok, %ProjectAppendix{}}

      iex> update_project_appendix(project_appendix, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_appendix(%ProjectAppendix{} = project_appendix, attrs) do
    project_appendix
    |> ProjectAppendix.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a ProjectAppendix.

  ## Examples

      iex> delete_project_appendix(project_appendix)
      {:ok, %ProjectAppendix{}}

      iex> delete_project_appendix(project_appendix)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_appendix(%ProjectAppendix{} = project_appendix) do
    @repo.delete(project_appendix)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_appendix changes.

  ## Examples

      iex> change_project_appendix(project_appendix)
      %Ecto.Changeset{source: %ProjectAppendix{}}

  """
  def change_project_appendix(%ProjectAppendix{} = project_appendix) do
    ProjectAppendix.changeset(project_appendix, %{})
  end

  def get_current_project_history(base_datetime, keywords) do
    projects = EctoUtil.list_current_history(@repo, Project, base_datetime, keywords)
    if projects == [] do
      nil
    else
      [project] = projects
      project
    end
  end

  def get_recent_project_history(base_datetime, keywords) do
    projects = EctoUtil.list_recent_history(@repo, Project, base_datetime, keywords)
    if projects == [] do
      nil
    else
      [project] = projects
      project
    end
  end

  def create_new_project_history(%{}, start_datetime, keywords, attr, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent = get_recent_project_history(start_datetime, keywords)
    {i, _reason} = delete_future_project_histories(start_datetime, keywords)
    project =
      if recent == nil do
        attr = attr
               |> Map.put("start_datetime", start_datetime)
               |> Map.put("end_datetime", end_datetime)
               |> Map.put("inserted_id", user_id)
        {:ok, project} = create_project(attr)
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

        {:ok, project} = create_project(attr)
        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        struct_project = struct(Project, recent)
        update_project(struct_project, %{end_datetime: recent_end_datetime})
        {:ok, project}
      end
  end

  def delete_future_project_histories(base_datetime, keywords) do
    projects = EctoUtil.delete_future_histories(@repo, Project, base_datetime, keywords)
  end

  def get_current_project_appendix_history(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, ProjectAppendix, base_datetime, keywords)
  end

  def get_recent_project_appendix_history(base_datetime, keywords) do
    EctoUtil.list_recent_history(@repo, ProjectAppendix, base_datetime, keywords)
  end

  def create_new_project_appendix_history(%{}, start_datetime, keywords, attrs, user_id) do
    {ok, end_datetime} = CalendarUtil.parse_iso_extended_z("2999-12-31 23:59:59Z")
    recent_project_appendix = get_recent_project_appendix_history(start_datetime, keywords)
    {i, _reason} = delete_future_project_appendix_histories(start_datetime, keywords)
    project_appendix =
      if recent_project_appendix == [] do
        project_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  attr = attr
                                         |> Map.put("start_datetime", start_datetime)
                                         |> Map.put("end_datetime", end_datetime)
                                         |> Map.put("inserted_id", user_id)
                                  {:ok, project_appendix} = create_project_appendix(attr)
                                  project_appendix
                                end
                              )
        {:ok, project_appendix}
      else
        attrs
        |> Enum.map(
             fn attr ->
               cond do
                 Map.has_key?(attr, "id") and !Map.has_key?(attr, "lock_version") ->
                   raise KeyError, message: "parameter have not lock_version"
                 Map.has_key?(attr, "id") and !check_recent_project_appendix(recent_project_appendix, attr["id"], attr["lock_version"]) ->
                   raise Ecto.StaleEntryError, message: "attempted to update a stale entry"
                 true -> :ok
               end
             end
           )

        project_appendix = attrs
                           |> Enum.map(
                                fn attr ->
                                  recent = check_recent_project_appendix(
                                    recent_project_appendix,
                                    attr["id"],
                                    attr["lock_version"]
                                  )
                                  unless recent do
                                    recent = Map.from_struct(%ProjectAppendix{})
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
                                  {:ok, project_appendix} = create_project_appendix(attr)
                                  project_appendix
                                end
                              )

        recent_end_datetime = Timex.shift(start_datetime, seconds: -1)
        recent_project_appendix
        |> Enum.map(
             fn recent ->
               struct_project_appendix = struct(ProjectAppendix, recent)
               update_project_appendix(struct_project_appendix, %{end_datetime: recent_end_datetime})
             end
           )
        {:ok, project_appendix}
      end
  end

  def delete_future_project_appendix_histories(base_datetime, keywords) do
    EctoUtil.delete_future_histories(@repo, ProjectAppendix, base_datetime, keywords)
  end

  def check_recent_project_appendix(recent_project_appendix, id, lock_version) do
    filter = Enum.filter(recent_project_appendix, fn x -> x.id == id end) |> List.first
    cond do
      filter != nil and filter.lock_version != lock_version -> false
      filter == nil -> false
      true -> filter
    end
  end

  def get_current_project(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, Project, base_datetime, keywords)
  end

  def get_current_project_appendices(base_datetime, keywords) do
    EctoUtil.list_current_history(@repo, ProjectAppendix, base_datetime, keywords)
  end
end
