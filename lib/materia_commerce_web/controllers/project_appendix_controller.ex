defmodule MateriaCommerceWeb.ProjectAppendixController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Projects
  alias MateriaCommerce.Projects.ProjectAppendix
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    project_appendices = Projects.list_project_appendices()
    render(conn, "index.json", project_appendices: project_appendices)
  end

  def create(conn, project_appendix_params) do
    with {:ok, %ProjectAppendix{} = project_appendix} <- Projects.create_project_appendix(project_appendix_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", project_appendix_path(conn, :show, project_appendix))
      |> render("show.json", project_appendix: project_appendix)
    end
  end

  def show(conn, %{"id" => id}) do
    project_appendix = Projects.get_project_appendix!(id)
    render(conn, "show.json", project_appendix: project_appendix)
  end

  def update(conn, project_appendix_params) do
    project_appendix = Projects.get_project_appendix!(project_appendix_params["id"])

    with {:ok, %ProjectAppendix{} = project_appendix} <- Projects.update_project_appendix(project_appendix, project_appendix_params) do
      render(conn, "show.json", project_appendix: project_appendix)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_appendix = Projects.get_project_appendix!(id)
    with {:ok, %ProjectAppendix{}} <- Projects.delete_project_appendix(project_appendix) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_project_appendices(conn, %{"key_words" => key_words}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    project_appendices = Projects.get_current_project_appendices(now, key_words)
    render(conn, "index.json", project_appendices: project_appendices)
  end

  def current_project_appendices(conn, %{"key_words" => key_words, "params" => params}) do
    user_id = MateriaWeb.ControllerBase.get_user_id(conn)
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    MateriaWeb.ControllerBase.transaction_flow(conn, :project_appendices, Projects, :create_new_project_appendix_history, [now, key_words, params, user_id])
  end
end
