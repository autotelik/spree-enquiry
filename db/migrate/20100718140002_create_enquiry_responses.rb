class CreateEnquiryResponses < ActiveRecord::Migration

  def self.up

    create_table :enquiry_responses do |t|
      t.references  :enquiry
      t.text        :message
      t.references  :response_user
      t.timestamps
    end
  end

  def self.down
    drop_table :enquiry_responses
  end

end