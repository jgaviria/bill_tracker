class ArchivedBillsController < ApplicationController
  before_action :set_archived_bill, only: [:show, :edit, :update, :destroy]

  # GET /archived_bills
  # GET /archived_bills.json
  def index
    @archived_bills = ArchivedBill.all
  end

  # GET /archived_bills/1
  # GET /archived_bills/1.json
  def show
  end

  # GET /archived_bills/new
  def new
    @archived_bill = ArchivedBill.new
  end

  # GET /archived_bills/1/edit
  def edit
  end

  # POST /archived_bills
  # POST /archived_bills.json
  def create
    @archived_bill = ArchivedBill.new(archived_bill_params)

    respond_to do |format|
      if @archived_bill.save
        format.html { redirect_to @archived_bill, notice: 'Archived bill was successfully created.' }
        format.json { render :show, status: :created, location: @archived_bill }
      else
        format.html { render :new }
        format.json { render json: @archived_bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /archived_bills/1
  # PATCH/PUT /archived_bills/1.json
  def update
    respond_to do |format|
      if @archived_bill.update(archived_bill_params)
        format.html { redirect_to @archived_bill, notice: 'Archived bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @archived_bill }
      else
        format.html { render :edit }
        format.json { render json: @archived_bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archived_bills/1
  # DELETE /archived_bills/1.json
  def destroy
    @archived_bill.destroy
    respond_to do |format|
      format.html { redirect_to archived_bills_url, notice: 'Archived bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archived_bill
      @archived_bill = ArchivedBill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def archived_bill_params
      params.require(:archived_bill).permit(:bill_name, :item_name, :amount, :paid, :sub_total, :item_type)
    end
end
