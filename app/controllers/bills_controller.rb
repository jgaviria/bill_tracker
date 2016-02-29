class BillsController < ApplicationController
  before_action :set_bill, only: [:show, :edit, :update, :destroy]
  before_action :get_current_bill, only: [:index, :create, :charts]

  def index
    @bills = current_user.bills.where.not(archive: true)
    if current_user.bills.count > 0
    @unpaid_items = current_user.bills.first.items.where(paid: 0)
    end
    charts
  end

  def index_archive
    @bills = current_user.bills.where.not(archive: false)
  end


  def show
  end

  def new
    @bill = Bill.new
  end

  def edit
  end

  def create

    if @current_bill
      @current_bill.update_attributes(archive: true)
    end

    @bill = Bill.new(bill_params)
    @bill.user_id = current_user.id
    @bill.archive = false
    respond_to do |format|
      if @bill.save
        format.html { redirect_to new_item_path, notice: 'Bill was successfully created.' }
        format.js   { redirect_to bills_path,  notice: 'Item was successfully Created.' }
      else
        format.html { render :new }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to @bill, notice: 'Bill was successfully updated.' }
        format.json { render :show, status: :ok, location: @bill }
      else
        format.html { render :edit }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @bill.destroy
    respond_to do |format|
      format.html { redirect_to bills_url, notice: 'Bill was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def charts

    if @current_bill
    @income = @current_bill.income
    sum     = 0
    @current_bill.items.each { |a| sum+=a.paid }
    @paid = sum
    @left = @income - @paid

    credits = @current_bill.items.where(item_type: 'credit')
    @credit = 0
    credits.each { |a| @credit+=a.paid }

    home_bills = @current_bill.items.where(item_type: 'home')
    @home      = 0
    home_bills.each { |a| @home+=a.paid }

    others = @current_bill.items.where(item_type: 'other')
    @other = 0
    others.each { |a| @other+=a.paid }
   end
    @chart1 = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => "pie", :margin => [60, 50, 50, 50]})
      series = {
        :size => '100%',
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
      f.chart({:defaultSeriesType => "pie"})
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
    def set_bill
      @bill = Bill.find(params[:id])
    end

  def get_current_bill
    min_id_for_user = current_user.bills.where.not(archive: true).minimum(:id)
    @current_bill = Bill.find(min_id_for_user) unless min_id_for_user.nil?
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit(:name, :income)
    end
end
