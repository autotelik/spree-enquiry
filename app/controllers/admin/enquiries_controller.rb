class Admin::EnquiriesController < Admin::BaseController
  resource_controller

  actions :all, :except => [:new, :create]

  edit.before do
    @enquiry_response = EnquiryResponse.new
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

    puts "PARAMS", params.inspect, params[:search]
    
    if(params[:search])
      @current_status = params[:search].delete('status')
 
      @search = case(@current_status)
      when('awaiting_response') then Enquiry.awaiting_response.search(params[:search])
      when('responded') then Enquiry.responded.search(params[:search])
      else Enquiry.search(params[:search])
      end
    else
      @current_status = 'all'
      @search = Enquiry.search
    end

    @search.order ||= "ascend_by_email"
    @collection = @search.paginate(:include => :customer, :per_page => 20, :page=> params[:page])

    @collection
  end
end