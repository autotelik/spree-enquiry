class Admin::EnquiryResponsesController < Admin::BaseController
  resource_controller

  actions :all, :except => [:new, :create]
  
  before_filter :load_object, :only => [:respond]

  def create
    
    @body  = params[:response][:body]
    @body += Spree::Config[:enquiry_signature] || "\nThankyou for your enquiry"

    enquiry = Enquiry.find( params[:enquiry_id] )

    EnquiryMailer.deliver_enquiry_response(enquiry, @body)

    er = EnquiryResponse.create( :enquiry => enquiry, :message => @body, :response_user_id => current_user )

    flash[:notice] = t('enquiry_response_sent')
    redirect_to :back
  end

  update.after do
    puts "HERE", params.inspect
    if(params['response'] && params['response']['response_sent'] == '1' )

      @enquiry.responses << EnquiryResponse.new( :message => params['response']['body'],
        :response_user_id => current_user )
      puts "CREATED", @enquiry.responses
    end
  end

  update.response do |wants|
    # override the default redirect behavior of r_c
    wants.html { redirect_to edit_admin_enquiry_url(@enquiry) }
  end

  def collection
    @search = EnquiryResponse.search(params[:search])
 
    @collection = @search.paginate(:include => :enquiry, :per_page => 20, :page=> params[:page])

    @collection
  end
end