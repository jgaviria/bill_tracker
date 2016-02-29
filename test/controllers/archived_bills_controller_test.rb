require 'test_helper'

class ArchivedBillsControllerTest < ActionController::TestCase
  setup do
    @archived_bill = archived_bills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:archived_bills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create archived_bill" do
    assert_difference('ArchivedBill.count') do
      post :create, archived_bill: { amount: @archived_bill.amount, bill_name: @archived_bill.bill_name, item_name: @archived_bill.item_name, item_type: @archived_bill.item_type, paid: @archived_bill.paid, sub_total: @archived_bill.sub_total }
    end

    assert_redirected_to archived_bill_path(assigns(:archived_bill))
  end

  test "should show archived_bill" do
    get :show, id: @archived_bill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @archived_bill
    assert_response :success
  end

  test "should update archived_bill" do
    patch :update, id: @archived_bill, archived_bill: { amount: @archived_bill.amount, bill_name: @archived_bill.bill_name, item_name: @archived_bill.item_name, item_type: @archived_bill.item_type, paid: @archived_bill.paid, sub_total: @archived_bill.sub_total }
    assert_redirected_to archived_bill_path(assigns(:archived_bill))
  end

  test "should destroy archived_bill" do
    assert_difference('ArchivedBill.count', -1) do
      delete :destroy, id: @archived_bill
    end

    assert_redirected_to archived_bills_path
  end
end
