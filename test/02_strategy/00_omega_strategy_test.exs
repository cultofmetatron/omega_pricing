defmodule PriceTracker.OmegaStrategyTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias PriceTracker.Repo
  alias PriceTracker.Product
  import PriceTracker.Factory
  alias PriceTracker.Transactor
  alias PriceTracker.OmegaPricingStrategy
  import Ecto
  import Ecto.Query

  setup_all do
    HTTPoison.start
  end

  setup_all do
    ExVCR.Config.cassette_library_dir(
      Path.expand("../fixture/vcr_cassettes", __DIR__),
      Path.expand("../fixture/custom_cassettes", __DIR__))
    :ok
  end
  
  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PriceTracker.Repo)
  end

  
  describe "omega strategy" do

    # stub to test the mock
    test "custom with valid response" do
      use_cassette "mocking_response", custom: true do
        {:ok, val} = HTTPoison.get("http://example.com", [])
        assert val.body["testcode"] == "alpha"
      end
    end

    test "on_reply should properly process the body response" do
      use_cassette "omega_yesterday_response", custom: true do
        {:ok, %{body: body}} = HTTPoison.get("https://omegapricinginc.com/pricing/records.json", [])
        #IO.inspect(body)
        products = OmegaPricingStrategy.on_reply(body)
        #IO.inspect(products)
        %{
          company_code: "OMEGA",
          product_name: "Nice Chair",
          external_product_id: "123456",
          price: 3525,
          discontinued: false
        } = Enum.at(products, 0)

        %{
          company_code: "OMEGA",
          product_name: "Black & White TV",
          external_product_id: "234567",
          price: 5077,
          discontinued: false
        } = Enum.at(products, 1)


      end
    end

    #currently testing by looking at the log
    test "make_reply should properly process the body response" do
      use_cassette "omega_yesterday_response", custom: true do
        OmegaPricingStrategy.make_request()
        
        product1 = Product.find_by_company_code_and_external_id("OMEGA", "123456")
        product2 = Product.find_by_company_code_and_external_id("OMEGA", "234567")
        product3 = Product.find_by_company_code_and_external_id("OMEGA", "234567")

      end
    end

  end


end
