class Clearance::InvitesController < ApplicationController
  unloadable
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :find_invite, :except => [:index, :new, :create]
  
  def index
    @invites = ::Invite.all
  end
  
  def new
    @invite = ::Invite.new
  end
  
  def create
    @invite = ::Invite.new(params[:invite])
    if @invite.save
      flash_notice_after_create
      redirect_to(url_after_create)
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @invite.update_attributes(params[:invite])
      flash[:notice] = "Successfully updated invite."
      redirect_to @invite
    else
      render :action => 'edit'
    end
  end
  
  def destroy    
    @invite.destroy
    flash[:notice] = "Successfully destroyed invite."
    redirect_to invites_url
  end

protected
  def find_invite
    @invite = Invite.find(params[:id])
  end
  
private
  def flash_notice_after_create
    flash[:notice] = translate(:invite_request,
      :scope   => [:clearance, :controllers, :invites],
      :default => "Thank you for your interest in our application.")
  end

  def url_after_create
    root_url
  end
  
end
