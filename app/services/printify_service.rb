class PrintifyService
  include HTTParty
  base_uri 'https://api.printify.com/v1'
  
  def initialize
    @headers = {
      'Authorization': "Bearer #{ENV['PRINTIFY_API_KEY']}",
      'Content-Type': 'application/json'
    }
  end

  def get_products
    self.class.get("/shops/#{ENV['PRINTIFY_SHOP_ID']}/products.json", headers: @headers)
  end

  def get_product(product_id)
    self.class.get("/shops/#{ENV['PRINTIFY_SHOP_ID']}/products/#{product_id}.json", headers: @headers)
  end

  def create_order(order_data)
    self.class.post(
      "/shops/#{ENV['PRINTIFY_SHOP_ID']}/orders.json",
      headers: @headers,
      body: order_data.to_json
    )
  end
end 