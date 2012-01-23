class EnquiriesController < Spree::BaseController
  resource_controller
  
  belongs_to :product

  before_filter :load_data, :only => [:new, :edit]

  # User's should not be able to edit Enquiry once saved
  actions :all, :except => [:index, :edit, :update]

  new_action do
    respond_to do |format|    
      format.html {}
      format.js   {}
    end
  end

  create.before do
    unless @enquiry.customer
      if(current_user)
        @enquiry.customer = current_user.customer
      else
        # Create a new customer + associated user, with random password and deactivated
        # this can be activated by email/admin later
        @enquiry.build_customer( params[:customer] )
        @enquiry.customer.user = User.new_deactivated(params[:user])
      end
    end
  end

  def create
    build_object
    load_object
    before :create

    # we must check this before we save the object
    send_new_user = current_user.nil?  # send new user details if not already registered + logged in

    if object.save
      EnquiryMailer.deliver_enquiry(@enquiry)

      send_new_user_details if(send_new_user)
      
      redirect_to product_url(@product)
    else
      after :create_fails
      set_flash :create_fails
      response_for :create_fails
    end
  end

  def send_new_user_details
 
    # The following sequence looks a bit convulted but is only way I got
    # perishable_token saved in DB to match the one sent in the email !
    #
    # I don't know why but the user ends up being logged in
    # and re saved @ some point as we leave the create, and enter the show method
    # The logs for the EnquiriesController#show  were showing a
    # SELECT * FROM `users` WHERE (`users`.`persistence_token` = '40b953d46dbc1664ba4b8a312b7df601214bc5f4eb2d93475eaabab79ab547dbcb15d4a658ce9c832d701e57ab49859ce4a3a94484639415f208da5e7bd12beb')
    # so I think somehow that persistence_token is stored somewhere even though all we
    # have done is create a user not a UserSession

    sess = UserSession.find
    sess.destroy if(sess)
    @current_user = nil if(@current_user)

    # Just killing session wasn't enough though
    # had to refind the User and do a forced redirect to ensure user not resaved with new  perishable_token
    @user = User.find(@enquiry.customer.user)
    
    if @user
      UserMailer.deliver_confirm_new_account(@user)
      flash[:notice] = "Thankyou for your Enquiry. Ref: '#{@enquiry.id}'.</br></br>Login details have been emailed to you."
    end
  end

  # Data for the form
  
  def load_data

    @product = Product.find(params[:product_id]) if params[:product_id]
    
    if(current_user)
      @customer = current_user.customer
      @user     = @customer.user || current_user
    else
      @customer = Customer.new
      @user     = @customer.user || User.new_deactivated
    end
  end

end