defmodule MateriaCommerceWeb.ProjectAppendixController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Projects
  alias MateriaCommerce.Projects.ProjectAppendix

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
end
