defmodule MateriaCommerceWeb.RequestController do
  use MateriaCommerceWeb, :controller

  alias MateriaCommerce.Commerces
  alias MateriaCommerce.Commerces.Request
  alias MateriaUtils.Calendar.CalendarUtil

  action_fallback MateriaWeb.FallbackController

  def index(conn, _params) do
    requests = Commerces.list_requests()
    render(conn, "index.json", requests: requests)
  end

  def create(conn, request_params) do
    with {:ok, %Request{} = request} <- Commerces.create_request(request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", request_path(conn, :show, request))
      |> render("show.json", request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Commerces.get_request!(id)
    render(conn, "show.json", request: request)
  end

  def update(conn, request_params) do
    request = Commerces.get_request!(request_params["id"])

    with {:ok, %Request{} = request} <- Commerces.update_request(request, request_params) do
      render(conn, "show.json", request: request)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Commerces.get_request!(id)
    with {:ok, %Request{}} <- Commerces.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end

  def search_current_requests(conn, %{"key_words" => key_words}) do
    now = CalendarUtil.now()
    key_words = key_words
                |> Enum.reduce([],
                     fn (key_word, acc) ->
                       key = Map.keys(key_word)
                             |> List.first
                       acc ++ [{String.to_atom(key), Map.get(key_word, key)}]
                     end
                   )
    requests = Commerces.get_current_request(now, key_words)
    render(conn, "index.json", requests: requests)
  end

  def current_requests(conn, %{"key_words" => key_words, "params" => params}) do
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
    MateriaWeb.ControllerBase.transaction_flow(conn, :request, Commerces, :create_new_request_history, [now, key_words, params, user_id])
  end
end
