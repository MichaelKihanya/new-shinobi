class Product < ApplicationRecord
  def self.find_or_create_default_product
    find_or_create_by(title: "Civil Rights Activists X Anime Characters T-Shirt") do |product|
      product.description = "A unique blend of civil rights activists and anime characters printed on a comfortable and durable T-shirt. This shirt exudes a cool and edgy vibe, perfect for those who appreciate art and social activism."
      product.price = 35.00
      product.active = true
      # Using placeholder IDs for development
      product.stripe_price_id = 'price_placeholder'
      product.printify_id = 'printify_placeholder'
    end
  end
end
