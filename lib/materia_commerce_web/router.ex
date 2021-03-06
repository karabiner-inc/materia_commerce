defmodule MateriaCommerceWeb.Router do
  use MateriaCommerceWeb, :router

  # pipeline :browser do
  #  plug :accepts, ["html"]
  #  plug :fetch_session
  #  plug :fetch_flash
  #  plug :protect_from_forgery
  #  plug :put_secure_browser_headers
  # end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :guardian_auth do
    plug(Materia.UserAuthPipeline)
  end

  pipeline :guardian_auth_acount do
    plug(Materia.AccountAuthPipeline)
  end

  pipeline :tmp_user_auth do
    plug(Materia.UserRegistrationAuthPipeline)
  end

  pipeline :pw_reset_auth do
    plug(Materia.PasswordResetAuthPipeline)
  end

  pipeline :grant_check do
    repo = Application.get_env(:materia, :repo)
    plug(Materia.Plug.GrantChecker, repo: repo)
  end

  scope "/api", MateriaWeb do
    pipe_through(:api)

    post("sign-in", AuthenticatorController, :sign_in)
    post("refresh", AuthenticatorController, :refresh)
    post("tmp-registration", UserController, :registration_tmp_user)
    post("request-password-reset", UserController, :request_password_reset)

    # resources "/items", ItemController, except: [:new, :edit]
    # resources "/taxes", TaxController, except: [:new, :edit]
  end

  scope "/api", MateriaCommerceWeb do
    pipe_through([:api, :guardian_auth])

    resources("/items", ItemController, except: [:new, :edit])
    resources("/taxes", TaxController, except: [:new, :edit])
    resources("/prices", PriceController, except: [:new, :edit])
    resources("/contracts", ContractController, except: [:new, :edit])
    resources("/contract_details", ContractDetailController, except: [:new, :edit])
    resources("/requests", RequestController, except: [:new, :edit])
    resources("/request_appendices", RequestAppendixController, except: [:new, :edit])
    resources("/deliveries", DeliveryController, except: [:new, :edit])

    post("/search-items", ItemController, :search_current_items)
    post("/search-taxes", TaxController, :search_current_taxes)
    post("/search-prices", PriceController, :search_current_prices)
    post("/search-contracts", ContractController, :search_current_contracts)
    post("/search-contract-details", ContractDetailController, :search_current_contract_details)
    post("/search-my-contracts", ContractController, :search_my_current_contracts)
    post("/search-requests", RequestController, :search_current_requests)
    post("/search-request-appendices", RequestAppendixController, :search_current_request_appendices)

    post("/current-items", ItemController, :current_items)
    post("/current-taxes", TaxController, :current_taxes)
    post("/current-prices", PriceController, :current_prices)
    post("/current-contracts", ContractController, :current_contracts)
    post("/create-my-contract-history", ContractController, :create_my_new_contract_history)
    post("/current-contract-details", ContractDetailController, :current_contract_details)
    post("/current-requests", RequestController, :current_requests)
    post("/create-my-request-hystory", RequestController, :create_my_new_request_history)
    post("/current-request-appendices", RequestAppendixController, :current_request_appendices)
  end

  scope "/api", MateriaWeb do
    pipe_through([:api, :tmp_user_auth])

    get("varidation-tmp-user", AuthenticatorController, :is_varid_token)
    post("user-registration", UserController, :registration_user)
    post("user-registration-and-sign-in", UserController, :registration_user_and_sign_in)
  end

  scope "/api", MateriaWeb do
    pipe_through([:api, :pw_reset_auth])

    get("varidation-pw-reset", AuthenticatorController, :is_varid_token)
    post("reset-my-password", UserController, :reset_my_password)
  end

  scope "/api", MateriaWeb do
    pipe_through([:api, :guardian_auth])

    get("/user", UserController, :show_me)
    post("/grant", GrantController, :get_by_role)
    post("sign-out", AuthenticatorController, :sign_out)
    get("auth-check", AuthenticatorController, :is_authenticated)
    post("search-users", UserController, :list_users_by_params)
    resources("/addresses", AddressController, except: [:new, :edit])
    post("create-my-addres", AddressController, :create_my_address)
  end

  scope "/api/ops", MateriaWeb do
    pipe_through([:api, :guardian_auth, :grant_check])

    resources("/grants", GrantController, except: [:new, :edit])
    resources("/mail-templates", MailTemplateController, except: [:new, :edit])

    resources("/users", UserController, except: [:edit, :new])
    resources("/organizations", OrganizationController, except: [:new, :edit])
  end
end
