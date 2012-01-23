class EnquiryMailer < ActionMailer::Base
  helper "spree/base"

  def enquiry(enquiry)
    @subject    = 'Enquiry received Ref #' + enquiry.id.to_s
    @body       = "\n\n###### Details of Enquiry ################\n\n"
    @body       += enquiry.message
    @body       += "\n\n###### From ################\n\n"
    @body       += enquiry.email
    @recipients = Spree::Enquiry::Config[:enquiry_to_email]
    @from       = Spree::Enquiry::Config[:enquiry_from_email]
    @sent_on    = Time.now
  end
  
  def enquiry_response(enquiry, response)
    @subject    = 'Response from ' + Spree::Config[:site_name] + ' ' + ' Ref #' + enquiry.id.to_s
    @body       = response
    @body       += "\n\n###### Details of Your Enquiry ################\n\n"
    @body       += enquiry.message
    @recipients = enquiry.email
    @from       = Spree::Enquiry::Config[:enquiry_response_from]
    @bcc        = enquiry_bcc
    @sent_on    = Time.now
  end
  
  private
  def enquiry_bcc
    [Spree::Config[:enquiry_bcc], Spree::Config[:mail_bcc]].delete_if { |email| email.blank? }.uniq
  end
end
