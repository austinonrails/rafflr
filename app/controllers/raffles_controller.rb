class RafflesController < ApplicationController
  #TODO: add validations to prevent create from being called via get, and raffle from being called from a non-ajax request.
  protect_from_forgery :only => [:create, :update, :destroy] 

  def index
    render :layout => false
  end

  def list
    @page_title = "Rafflr"
    @raffles = Raffle.paginate :page => params[:page], :order => 'created_on DESC', :per_page => 5
  end
  
  def new
    @page_title = "New Raffle"
    @raffle = Raffle.new
  end
          
  def create
    @raffle = Raffle.new(params[:raffle])
    @users = params[:users]
    users = @users.gsub("\r","").split("\n").map{|u| u.strip}
    users.each {|user| @raffle.users << User.new(:name => user, :raffle => @raffle)}
     
    if @raffle.save
      redirect_to raffle_url(:id => @raffle)
    else
      render :action => 'new'
    end
  end
  
  def show
    # TODO: maybe we should just display it if it's already been run
    # or give them the option to re-run it
    @raffle = Raffle.find(params[:id])
    @users = @raffle.users
    @users.each { |user| user.winner = false; user.save }
    session[:users] = @users # going to need this in "raffle"
    session[:number_of_winners] = @raffle.number_of_winners.to_i
    @page_title = "#{@raffle.title}"
  end
     
  # only called via ajax
  def raffle
    
    # randomize the users
    session[:users] = session[:users].sort_by { rand }
    
    begin
      # haha you're a loser
      loser = session[:users].pop
      begin
        session[:users].each do |user|
          user.winner = true
          user.save
        end
      end if (session[:users].size == session[:number_of_winners])
      
      render :update do |page|
        page << "remove_user(#{loser.id})" # remove the user from the page
      end
    end if session[:users].size > session[:number_of_winners]
  
  end

  def test
  end
  
end
