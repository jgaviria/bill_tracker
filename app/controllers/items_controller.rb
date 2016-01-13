class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]


  # GET /items
  # GET /items.json
  def index
    if current_user.bills.first.nil?
      redirect_to bills_path
    else

      @items = current_user.bills.first.items
      charts
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
    @item.bill_id   = current_user.bills.first.id
    @item.sub_total = (@item.amount.to_i - @item.paid.to_i)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
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
    @item.sub_total = (@item.amount.to_i - @item.paid.to_i)

    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
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

  def charts
    @income = current_user.bills.first.income
    sum     = 0
    current_user.bills.first.items.each { |a| sum+=a.paid }
    @paid = sum
    @left = @income - @paid

    credits = current_user.bills.first.items.where(item_type: 'credit')
    @credit = 0
    credits.each { |a| @credit+=a.paid }

    home_bills = current_user.bills.first.items.where(item_type: 'home')
    @home      = 0
    home_bills.each { |a| @home+=a.paid }

    others = current_user.bills.first.items.where(item_type: 'other')
    @other = 0
    others.each { |a| @other+=a.paid }

    @chart1 = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => "pie", :margin => [60, 50, 50, 50]})
      series = {
        :type => 'pie',
        :name => 'Browser share',
        :data => [
          ['income', @income],
          [' total paid', @paid],
          {
            :name => 'total left',
            :y    => @left,

          },
        ]
      }
      f.series(series)
      f.options[:title][:text] = "Metrics"
      f.legend(:layout => 'vertical', :style => {:left => 'auto', :bottom => 'auto', :right => '50px', :top => '50px'})
      f.plot_options(:pie => {
        :allowPointSelect => true,
        :cursor           => "pointer",
        :dataLabels       => {
          :enabled => true,
          :color   => "black",
          :style   => {
            :font => "13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end

    @chart2 = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => "pie", :margin => [70, 60, 60, 50]})
      series = {
        :type => 'pie',
        :name => 'Browser share',
        :data => [
          ['total credit', @credit],
          ['total home', @home],
          {
            :name => 'total other',
            :y    => @other,

          },
        ]
      }
      f.series(series)
      f.options[:title][:text] = "Totals"
      f.legend(:layout => 'vertical', :style => {:left => 'auto', :bottom => 'auto', :right => '50px', :top => '50px'})
      f.plot_options(:pie => {
        :allowPointSelect => true,
        :cursor           => "pointer",
        :dataLabels       => {
          :enabled => true,
          :color   => "black",
          :style   => {
            :font => "13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
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
end
