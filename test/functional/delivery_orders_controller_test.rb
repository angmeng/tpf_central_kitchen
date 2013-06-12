require 'test_helper'

class DeliveryOrdersControllerTest < ActionController::TestCase
  setup do
    @delivery_order = delivery_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:delivery_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create delivery_order" do
    assert_difference('DeliveryOrder.count') do
      post :create, delivery_order: { company_id: @delivery_order.company_id, delivery_date: @delivery_order.delivery_date, delivery_order_number: @delivery_order.delivery_order_number, invoice_id: @delivery_order.invoice_id, outlet_id: @delivery_order.outlet_id, remark: @delivery_order.remark, void: @delivery_order.void }
    end

    assert_redirected_to delivery_order_path(assigns(:delivery_order))
  end

  test "should show delivery_order" do
    get :show, id: @delivery_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @delivery_order
    assert_response :success
  end

  test "should update delivery_order" do
    put :update, id: @delivery_order, delivery_order: { company_id: @delivery_order.company_id, delivery_date: @delivery_order.delivery_date, delivery_order_number: @delivery_order.delivery_order_number, invoice_id: @delivery_order.invoice_id, outlet_id: @delivery_order.outlet_id, remark: @delivery_order.remark, void: @delivery_order.void }
    assert_redirected_to delivery_order_path(assigns(:delivery_order))
  end

  test "should destroy delivery_order" do
    assert_difference('DeliveryOrder.count', -1) do
      delete :destroy, id: @delivery_order
    end

    assert_redirected_to delivery_orders_path
  end
end
