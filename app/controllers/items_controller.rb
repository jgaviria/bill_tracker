class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :get_current_bill, only: [:index, :create]

  # GET /items
  # GET /items.json
  def index
    if current_user.bills.first.nil?
      redirect_to bills_path
    else
       @items = Bill.find(@current_bill.id).items
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item           = Item.new(item_params)
    @item.bill_id   = @current_bill.id
    @item.sub_total = (@item.amount.to_i - @item.paid.to_i)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_path, notice: 'Item was successfully destroyed.' }
        format.js   { redirect_to items_path,  notice: 'Item was successfully Created.' }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    sub = item_params[:amount].to_i - item_params[:paid].to_i
    items = item_params.merge({:sub_total => sub})
    puts items
    respond_to do |format|
      if @item.update(items)
        format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
        format.js   { redirect_to items_path,  notice: 'Item was successfully Created.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:item_name, :amount, :paid, :sub_total, :item_type)
  end

  def get_current_bill
    if self.params[:current_bill].present?
     bill = self.params[:current_bill][:bill_id]
     @current_bill = Bill.find(bill)
    else
      min_id_for_user = current_user.bills.where.not(archive: true).minimum(:id)
      @current_bill = Bill.find(min_id_for_user)
    end
  end

  def update_charts

  end
end
