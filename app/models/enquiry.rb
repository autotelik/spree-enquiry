class Enquiry < ActiveRecord::Base
  belongs_to :customer
  delegate :firstname, :lastname, :company_name, :to => :customer

  has_one :user, :through => :customer

  belongs_to :product

  has_many :enquiry_responses
  alias_method :responses, :enquiry_responses
 
  validates_presence_of :customer
  validates_presence_of :message
  validates_associated  :customer, :user

  named_scope :responded, :include => [:customer],
                          :conditions => ["id IN (select distinct enquiry_id from enquiry_responses)"]
                         
  named_scope :awaiting_response, :include => [:customer],
                                  :conditions => ["id NOT IN (select distinct enquiry_id from enquiry_responses)"]

  def email
    self.customer.user.email
  end

  def status
    (response_sent) ? "responded" :  "awaiting_response"
  end

  def response_sent
    (responses.size > 0)
  end

end
