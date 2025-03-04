class ShopController < ApplicationController
  def index
    @products = Product.where(active: true)
  end

  def show
    @product = Product.find(params[:id])
  end

  def checkout
    @product = Product.find(params[:product_id])
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: @product.stripe_price_id,
        quantity: 1
      }],
      mode: 'payment',
      success_url: success_shop_url(product_id: @product.id),
      cancel_url: product_url(@product)
    )

    respond_to do |format|
      format.html
      format.json { render json: { id: @session.id } }
    end
  end

  def success
    @product = Product.find(params[:product_id])
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)

    # Create order in your database
    @order = Order.create!(
      product: @product,
      amount: @product.price,
      status: 'paid',
      stripe_payment_intent_id: @payment_intent.id,
      customer_email: @session.customer_details.email,
      shipping_address: @session.shipping_details.address.to_json
    )

    # Create order in Printify
    printify_service = PrintifyService.new
    printify_response = printify_service.create_order({
      external_id: @order.id,
      line_items: [{
        product_id: @product.printify_id,
        quantity: 1,
        variant_id: 1  # You'll need to adjust this based on your product variants
      }],
      shipping_method: 1,  # You'll need to adjust this based on available shipping methods
      shipping_address: {
        first_name: @session.shipping_details.name,
        address1: @session.shipping_details.address.line1,
        city: @session.shipping_details.address.city,
        state: @session.shipping_details.address.state,
        country: @session.shipping_details.address.country,
        zip: @session.shipping_details.address.postal_code
      }
    })

    if printify_response.success?
      @order.update(printify_order_id: printify_response['id'])
    end
  end
end
