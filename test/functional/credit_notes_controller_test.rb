require 'test_helper'

class CreditNotesControllerTest < ActionController::TestCase
  setup do
    @credit_note = credit_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:credit_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create credit_note" do
    assert_difference('CreditNote.count') do
      post :create, credit_note: { credit_date: @credit_note.credit_date, credit_note_number: @credit_note.credit_note_number, posted: @credit_note.posted, remark: @credit_note.remark }
    end

    assert_redirected_to credit_note_path(assigns(:credit_note))
  end

  test "should show credit_note" do
    get :show, id: @credit_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @credit_note
    assert_response :success
  end

  test "should update credit_note" do
    put :update, id: @credit_note, credit_note: { credit_date: @credit_note.credit_date, credit_note_number: @credit_note.credit_note_number, posted: @credit_note.posted, remark: @credit_note.remark }
    assert_redirected_to credit_note_path(assigns(:credit_note))
  end

  test "should destroy credit_note" do
    assert_difference('CreditNote.count', -1) do
      delete :destroy, id: @credit_note
    end

    assert_redirected_to credit_notes_path
  end
end
