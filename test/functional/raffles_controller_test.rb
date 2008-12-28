require File.dirname(__FILE__) + '/../test_helper'
require 'raffles_controller'

# Re-raise errors caught by the controller.
class RafflesController; def rescue_action(e) raise e end; end

class RafflesControllerTest < Test::Unit::TestCase
  fixtures :raffles, :users
  
  def setup
    @controller = RafflesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_page_title_assigns_and_success
  end
  
  def test_new
    get :new
    assert_page_title_assigns_and_success(:raffle)
  end
  
  def test_create
    title = 'Austin on Rails Raffle'
    post :create, :raffle => {:title => title}, :users => "Shane Sherman\r\nGeorge Bush\r\nBill Clinton"
    assert_response :redirect
    raffle = Raffle.find_by_title(title)
    assert_valid raffle
    assert_equal 3, raffle.users.length
  end
  
  def test_show
    get :show, :id => raffles(:one)
    assert_page_title_assigns_and_success(:raffle)
    users = raffles(:one).users
    assert_equal users, @request.session[:users], "users in session are the same users in the raffle"
  end
  
end
