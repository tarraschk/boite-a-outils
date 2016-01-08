require 'test_helper'

class GadgetFilesControllerTest < ActionController::TestCase
  setup do
    @gadget_file = gadget_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gadget_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gadget_file" do
    assert_difference('GadgetFile.count') do
      post :create, gadget_file: { html: @gadget_file.html, url: @gadget_file.url }
    end

    assert_redirected_to gadget_file_path(assigns(:gadget_file))
  end

  test "should show gadget_file" do
    get :show, id: @gadget_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @gadget_file
    assert_response :success
  end

  test "should update gadget_file" do
    patch :update, id: @gadget_file, gadget_file: { html: @gadget_file.html, url: @gadget_file.url }
    assert_redirected_to gadget_file_path(assigns(:gadget_file))
  end

  test "should destroy gadget_file" do
    assert_difference('GadgetFile.count', -1) do
      delete :destroy, id: @gadget_file
    end

    assert_redirected_to gadget_files_path
  end
end
