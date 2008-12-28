class RafflesController < ApplicationController
  #TODO: add validations to prevent create from being called via get, and raffle from being called from a non-ajax request.

  def index
    @page_title = "Rafflr"
  end
  
  def new
    @page_title = "New Raffle"
    @raffle = Raffle.new
  end
          
  def create
    @raffle = Raffle.new(params[:raffle])
    if @raffle.save
      users = params[:users].gsub("\r","").split("\n").map{|u| u.strip}.uniq
      users.each {|user| User.create(:name => user, :raffle => @raffle)}
      redirect_to raffle_url(:id => @raffle)
    else
      render :action => 'new'
    end
  end
  
  def show
    @raffle = Raffle.find(params[:id])
    @users = @raffle.users
    session[:users] = @users # going to need this in "raffle"
    @page_title = "#{@raffle.title}"
  end
     
  # only called via ajax
  def raffle
    
    # randomize the users
    session[:users] = session[:users].sort_by { rand }
    
    begin
      # haha you're a loser
      loser = session[:users].pop
    
      render :update do |page|
        page << "dropout('user_#{loser.id}');" # remove the user from the page

        # we need to update a hidden javascript value with the number of users left so we know
        # when to stop the raffle
        page['users_left'].value = session[:users].length
      end
    end if session[:users].size > 1
  
  end

  
end
