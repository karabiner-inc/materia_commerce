# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Materia.Repo.insert!(%Materia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MateriaUtils.Test.TsvParser

alias Materia.Accounts
alias Materia.Locations

Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/users" })
Accounts.create_grant(%{ role: "admin", method: "ANY", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "operator", method: "GET", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/organizations" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/mail-templates" })

{:ok, user_hogehoge} = Accounts.create_user(%{ name: "hogehoge", email: "hogehoge@example.com", password: "hogehoge", role: "admin"})
Accounts.create_user(%{ name: "fugafuga", email: "fugafuga@example.com", password: "fugafuga", role: "operator"})
Locations.create_address(%{user_id: user_hogehoge.id, subject: "living", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "港 x-x-xx"})
Locations.create_address(%{user_id: user_hogehoge.id, subject: "billing", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "大名 x-x-xx"})

alias Materia.Organizations

{:ok, organization_hogehoge} = Organizations.create_organization( %{name: "hogehoge.inc", one_line_message: "let's do this.", back_ground_img_url: "https://hogehoge.com/ib_img.jpg", profile_img_url: "https://hogehoge.com/prof_img.jpg", hp_url: "https://hogehoge.inc"})
Accounts.update_user(user_hogehoge, %{organization_id: organization_hogehoge.id})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "registry", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "天神 x-x-xx"})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "branch", location: "福岡県", zip_code: "812-ZZZZ", address1: "北九州市小倉北区", address2: "浅野 x-x-xx"})

alias Materia.Mails

Mails.create_mail_template(%{ mail_template_type: "user_registration_request", subject: "【注意！登録は完了していません】{!email}様 本登録のご案内", body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "user_registration_completed", subject: "【本登録完了しました】{!name}様 本登録完了のご案内", body: "{!name}様\nこの度は当サービスのご利用誠にありがとうございます。\n\n本登録が完了いたしました。\n\nIDの問い合わせ機能はない為、本メールを大切に保管してください。\n\n  ユーザーID: {!email}\n  パスワード: 登録時に入力いただいたパスワード\n 本サービスを末長くよろしくお願いいたします。\n\n サインイン: https://{!sign_in_url} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "password_reset_request", subject: "【パスワード再登録申請】{!email}様 パスワード再登録のご案内", body: "{!email}様\n当サービスよりパスワード再登録の申請を受け付けました。\n\n下記URLのリンクをクリックし、30分以内にパスワード再登録をお願いいたします。\n\n 本サービスを末長くよろしくお願いいたします。\n\n https://{!password_reset_url}?param=!{password_reset_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "password_reset_completed", subject: "【パスワード再登録完了】{!name}様 パスワード再登録完了のご案内", body: "{!name}様\n当サービスよりパスワードが再登録されました。\n\nユーザーID: {!email}\n  パスワード: 再登録時に入力いただいたパスワード\n\n 本サービスを末長くよろしくお願いいたします。\n\n サインイン: https://{!sign_in_url} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })

alias MateriaCommerce.Products

items = "
name	category1	category2	category3	category4	item_code	model_number	jan_code	thumbnail	image_url	size1	size2	size3	size4	weight1	weight2	weight3	weight4	delivery_area	manufacturer	status	color	description	start_datetime	end_datetime	tax_category	inserted_id
炊飯器Z1000	電化製品	調理器具	炊飯器	2020年モデル	ICZ1000	Z1000	123456789123	hogehoge	http://z1000.com/img.png	H30cm	W40cm	D40cm	外装 60cm×60cm×50cm	本体重量 1.2kg	梱包重量 1.5kg	最大重量 2.0kg	最小重量 1.0kg	離島のぞく	松芝電気	0	Blue	高級炊飯器	2018-11-01 09:00:00	2018-12-16 08:59:59	一般消費税	1
炊飯器Z1000	電化製品	調理器具	炊飯器	2020年モデル	ICZ1000	Z1000	123456789123	hogehoge	http://z1000.com/img.png	H30cm	W40cm	D40cm	外装 60cm×60cm×50cm	本体重量 1.2kg	梱包重量 1.5kg	最大重量 2.0kg	最小重量 1.0kg	離島のぞく	松芝電気	1	Blue	高級炊飯器	2018-12-17 09:00:00	2019-12-31 08:59:59	一般消費税	1
炊飯器Z1000	電化製品	調理器具	炊飯器	2020年モデル	ICZ1000	Z1000	123456789123	hogehoge	http://z1000.com/img.png	H30cm	W40cm	D40cm	外装 60cm×60cm×50cm	本体重量 1.2kg	梱包重量 1.5kg	最大重量 2.0kg	最小重量 1.0kg	離島のぞく	松芝電気	1	Blue	超高級炊飯器	2020-01-01 09:00:00	2999-12-31 08:59:59	一般消費税	1
炊飯器Z1000	電化製品	調理器具	炊飯器	2020年モデル	ICZ1001	Z1000	123456789123	hogehoge	http://z1000.com/img.png	H30cm	W40cm	D40cm	外装 60cm×60cm×50cm	本体重量 1.2kg	梱包重量 1.5kg	最大重量 2.0kg	最小重量 1.0kg	離島のぞく	松芝電気	1	Blue	超高級炊飯器	2018-11-01 09:00:00	2999-12-31 08:59:59	一般消費税	1
"
jsons = TsvParser.parse_tsv_to_json(items, "name")

    cars = jsons
    |> Enum.map(fn(json) ->
      {:ok, item} = json
      |> Products.create_item()
    end)


alias MateriaCommerce.Products.Tax
taxes = [
  %{
    name: "test1 tax",
    start_datetime: "2018-11-01 09:00:00",
    end_datetime: "2018-12-01 08:59:59",
    tax_category: "category1",
    tax_rate: 0.5,
    inserted_id: 1,
  },
  %{
    name: "test2 tax",
    start_datetime: "2018-12-01 09:00:00",
    end_datetime: "2019-01-01 08:59:59",
    tax_category: "category1",
    tax_rate: 0.5,
    inserted_id: 1,
  },
  %{
    name: "test3 tax",
    start_datetime: "2019-01-01 09:00:00",
    end_datetime: "2019-02-01 08:59:59",
    tax_category: "category1",
    tax_rate: 0.5,
    inserted_id: 1,
  },
  %{
    name: "tax category2",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    tax_category: "category2",
    tax_rate: 1,
    inserted_id: 1,
  },
  %{
    name: "一般消費税",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    tax_category: "一般消費税",
    tax_rate: 100,
    inserted_id: 1,
  },
  %{
    name: "tax category3",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    tax_category: "category3",
    tax_rate: 1,
    inserted_id: 1,
  },
]

taxes
|> Enum.map(fn(tax) -> Products.create_tax(tax) end)

alias MateriaCommerce.Products.Price
prices = [
  %{
    description: "test1 price",
    start_datetime: "2018-11-01 09:00:00",
    end_datetime: "2018-12-01 08:59:59",
    item_code: "ICZ1000",
    unit_price: 100,
    inserted_id: 1,
  },
  %{
    description: "test2 price",
    start_datetime: "2018-12-01 09:00:00",
    end_datetime: "2019-01-01 08:59:59",
    item_code: "ICZ1000",
    unit_price: 200,
    inserted_id: 1,
  },
  %{
    description: "test3 price",
    start_datetime: "2019-01-01 09:00:00",
    end_datetime: "2019-02-01 08:59:59",
    item_code: "ICZ1000",
    unit_price: 300,
    inserted_id: 1,
  },
  %{
    description: "price item_code2",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    item_code: "ICZ1001",
    unit_price: 1000,
    inserted_id: 1,
  },
  %{
    description: "price item_code3",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    item_code: "ICZ1002",
    unit_price: 1000,
    inserted_id: 1,
  },
]

prices
|> Enum.map(fn(price) -> Products.create_price(price) end)

alias MateriaCommerce.Commerces

contracts = [
  %{
    contract_no: "0000-0000-0000",
    settlement: "9999-9999-9999",
    shipping_fee: 100.01,
    tax_amount: 80,
    total_amount: 1180.01,
    status: 1,
    start_datetime: "2018-11-01 09:00:00",
    end_datetime: "2018-12-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    settlement: "9999-9999-9999",
    shipping_fee: 110.01,
    tax_amount: 80,
    total_amount: 1190.01,
    status: 2,
    start_datetime: "2018-12-01 09:00:00",
    end_datetime: "2019-01-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    settlement: "9999-9999-9999",
    shipping_fee: 200,
    tax_amount: 80,
    total_amount: 1280,
    status: 3,
    start_datetime: "2019-01-01 09:00:00",
    end_datetime: "2019-02-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "1111-1111-1111",
    settlement: "9999-9999-9999",
    shipping_fee: 200,
    tax_amount: 80,
    total_amount: 1280,
    status: 0,
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "2222-2222-2222",
    settlement: "9999-9999-9999",
    shipping_fee: 200,
    tax_amount: 80,
    total_amount: 1280,
    status: 0,
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    inserted_id: 1,
  }
]

contracts
|> Enum.map(fn(contract) -> Commerces.create_contract(contract) end)


contract_details = [
  %{
    contract_no: "0000-0000-0000",
    amount: 1,
    price: 100,
    category1: "Single Detail",
    start_datetime: "2018-11-01 09:00:00",
    end_datetime: "2018-12-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    amount: 2,
    price: 200,
    category1: "Multiple Details:1",
    start_datetime: "2018-12-01 09:00:00",
    end_datetime: "2019-01-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    amount: 3,
    price: 300,
    item_code: "ICZ1000",
    category1: "Multiple Details:2 With Item",
    start_datetime: "2018-12-01 09:00:00",
    end_datetime: "2019-01-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    amount: 4,
    price: 400,
    category1: "Multiple Details:1",
    start_datetime: "2019-01-01 09:00:00",
    end_datetime: "2019-02-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "0000-0000-0000",
    amount: 5,
    price: 500,
    item_code: "ICZ1000",
    category1: "Multiple Details:2 With Item",
    start_datetime: "2019-01-01 09:00:00",
    end_datetime: "2019-02-01 08:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "1111-1111-1111",
    amount: 1,
    price: 100,
    category1: "Single Detail",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    inserted_id: 1,
  },
  %{
    contract_no: "2222-2222-2222",
    amount: 1,
    price: 100,
    category1: "Single Detail",
    start_datetime: "2018-01-01 09:00:00",
    end_datetime: "2999-12-31 23:59:59",
    inserted_id: 1,
  },
]

contract_details
|> Enum.map(fn(contract) -> Commerces.create_contract_detail(contract) end)


request = "
request_key1	request_key2	request_key3	request_key4	request_key5	request_number	request_name	accuracy	request_date1	request_date2	request_date3	request_date4	request_date5	request_date6	quantity1	quantity2	quantity3	quantity4	quantity5	quantity6	description	note1	note2	note3	note4	start_datetime	end_datetime	status	lock_version	user_id	inserted_id
key1	key2	key3	key4	key5	PJ-01	History1	accuracy	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	0	1	2	3	4	5	description	note1	note2	note3	note4	2018-11-01 09:00:00	2018-12-01 08:59:59	0	0	1	1
key1	key2	key3	key4	key5	PJ-01	History2	accuracy	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	0	1	2	3	4	5	description	note1	note2	note3	note4	2018-12-01 09:00:00	2019-01-01 08:59:59	1	1	1	1
key1	key2	key3	key4	key5	PJ-01	History3	accuracy	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	0	1	2	3	4	5	description	note1	note2	note3	note4	2019-01-01 09:00:00	2999-12-31 23:59:59	2	2	1	1
key1	key2	key3	key4	key5	PJ-02	History1	accuracy	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	2999-12-31 23:59:59	0	1	2	3	4	5	description	note1	note2	note3	note4	2018-01-01 09:00:00	2999-12-31 23:59:59	3	0	1	1
"
TsvParser.parse_tsv_to_json(request, "request_key1")
|> Enum.map(fn j -> j |> Commerces.create_request end)

appendix = "
request_key1	request_key2	request_key3	request_key4	request_key5	request_number	appendix_category	appendix_name	appendix_date	appendix_number	appendix_description	appendix_status	start_datetime	end_datetime	lock_version	inserted_id
key1	key2	key3	key4	key5	PJ-01	Category1	appendix_name	2999-12-31 23:59:59	1	appendix_description	0	2018-11-01 09:00:00	2019-01-01 08:59:59	0	1
key1	key2	key3	key4	key5	PJ-01	Category2	appendix_name	2999-12-31 23:59:59	2	appendix_description	1	2018-11-01 09:00:00	2019-01-01 08:59:59	0	1
key1	key2	key3	key4	key5	PJ-01	Category3	appendix_name	2999-12-31 23:59:59	3	appendix_description	2	2018-11-01 09:00:00	2019-01-01 08:59:59	0	1
key1	key2	key3	key4	key5	PJ-01	Category1	appendix_name	2999-12-31 23:59:59	4	appendix_description	3	2019-01-01 09:00:00	2999-12-31 23:59:59	1	1
key1	key2	key3	key4	key5	PJ-01	Category4	appendix_name	2999-12-31 23:59:59	5	appendix_description	4	2019-01-01 09:00:00	2999-12-31 23:59:59	0	1
key1	key2	key3	key4	key5	PJ-02	Category1	appendix_name	2999-12-31 23:59:59	6	appendix_description	5	2018-01-01 09:00:00	2999-12-31 23:59:59	0	1
"
TsvParser.parse_tsv_to_json(appendix, "request_key1")
|> Enum.map(fn j -> j |> Commerces.create_request_appendix end)
