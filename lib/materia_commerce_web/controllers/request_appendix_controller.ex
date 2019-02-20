defmodule MateriaCommerceWeb.RequestAppendixController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.RequestAppendix
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    request_appendices = Commerces.list_request_appendices()
    render(conn, "index.json", request_appendices: request_appendices)
  end

  def create(conn, request_appendix_params) do
    with {:ok, %RequestAppendix{} = request_appendix} <- Commerces.create_request_appendix(request_appendix_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_appendix_path(conn, :show, request_appendix))
      |> render("show.json", request_appendix: request_appendix)
    end
  end

  def show(conn, %{"id" => id}) do
    request_appendix = Commerces.get_request_appendix!(id)
    render(conn, "show.json", request_appendix: request_appendix)
  end

  def update(conn, request_appendix_params) do
    request_appendix = Commerces.get_request_appendix!(request_appendix_params["id"])

    with {:ok, %RequestAppendix{} = request_appendix} <- Commerces.update_request_appendix(request_appendix, request_appendix_params) do
      render(conn, "show.json", request_appendix: request_appendix)
    end
  end

  def delete(conn, %{"id" => id}) do
    request_appendix = Commerces.get_request_appendix!(id)
    with {:ok, %RequestAppendix{}} <- Commerces.delete_request_appendix(request_appendix) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_request_appendices(conn, %{"key_words" => key_words}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    request_appendices = Commerces.get_current_request_appendices(now, key_words)
    render(conn, "index.json", request_appendices: request_appendices)
  end

  def current_request_appendices(conn, %{"key_words" => key_words, "params" => params}) do
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
    MateriaWeb.ControllerBase.transaction_flow(conn, :request_appendices, Commerces, :create_new_request_appendix_history, [now, key_words, params, user_id])
  end
end
