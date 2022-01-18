class Api::V1::ProductsController < Api::V1::BaseApiController
  before_action :set_product, only: %i[ show update destroy ]

  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    @product = current_user.products.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
  end

  # POST /products/1/buy
  # We can move all this business logic to a service class object
  def buy
    @product = Product.find(buy_product_params[:product_id])
    amount = buy_product_params[:amount].to_i
    total_price = amount * @product.cost

    if @product.amount_available < amount
      render json: { errors: "#{@product.product_name} are only #{@product.amount_available} in stock" }, status: :unprocessable_entity
    elsif current_user.deposit < total_price
      render json: { errors: "Balance not enough to buy #{amount} piece(s)." }, status: :unprocessable_entity
    else
      stock_left = @product.amount_available - amount
      @product.update_attribute(:amount_available, stock_left)

      balance = current_user.deposit - total_price
      current_user.update_attribute(:deposit, balance)

      render json: {
        total_spent: total_price,
        product: @product,
        balance_left: convert_into_coins(balance)
      }, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = current_user.products.find(params[:id])
    end

    def buy_product_params
      params.permit(:amount, :product_id)
    end

    def convert_into_coins(balance)
      denominations = [100, 50, 20, 10, 5]
      balance_in_coins = []

      denominations.each do |denomination|
        balance_in_coins << (balance/denomination)
        balance = balance % denomination
      end

      balance_in_coins.reverse
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:amount, :cost, :product_name)
    end
end
