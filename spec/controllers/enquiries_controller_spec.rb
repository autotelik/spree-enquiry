require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EnquiriesController do
  before(:each) do
    fixtures :users
    fixtures :products

    @customer = mock_model(Customer, :company_name => "Enquirty Spec Ltd",
      :lastname => "Tom", :firstname => "Brown")
    Customer.stub!(:find, :return => @customer)

    @enquiry = Enquiry.create
  end

  describe "create" do
    it "should add the current_user to the enquiry" do

      
      ApplicationController.stub!(:current_user, :return => users[:customer] )

      controller.stub!(:object, :return => @enquiry)
      @enquiry.should_receive(:customer).with(current_user.customer)
      post :create, :product => products[:products_000024], :message => "Spec test current user"
    end
  end

  describe "update" do
  end
  
end