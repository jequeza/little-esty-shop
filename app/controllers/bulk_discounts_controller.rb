class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_bulk_discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to "/merchant/#{merchant.id}/bulk_discounts"
    else
      flash[:notice] = "Fields Missing: Fill in all fields"
      redirect_to "/merchant/#{merchant.id}/bulk_discounts/new"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @mechant_bulk_discount = BulkDiscount.find(params[:id])
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/#{merchant.id}/bulk_discounts"
  end

  private
  def bulk_discount_params
    params[:bulk_discount].permit(:quantity_treshold, :percentage_discount)
  end
end