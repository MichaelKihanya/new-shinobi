class ShopController < ApplicationController
  def index
    @product = Product.find_or_create_default_product
    @images = ["Front-2.jpg", "Back.jpg", "Front 2.jpg", "Back 2.jpg", "Person 4.jpg"]
    @sizes = ['S', 'M', 'L', 'XL', '2XL']
  end

  def update_image
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  def select_size
    size = params[:size]
    session[:selected_size] = size
    
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end

  def checkout
    unless session[:selected_size]
      render json: { error: 'Please select a size' }, status: :unprocessable_entity
      return
    end

    begin
      @product = Product.find(params[:id])
      quantity = params[:quantity] || 1
      
      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          price: @product.stripe_price_id,
          quantity: quantity
        }],
        mode: 'payment',
        success_url: success_shop_url(@product),
        cancel_url: shop_url(@product)
      )

      render json: { id: stripe_session.id }
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def success
    # Handle successful payment
    render :success
  end

  private

  def product_params
    params.require(:product).permit(:size, :quantity)
  end
end
