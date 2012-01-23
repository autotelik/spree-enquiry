class CreateEnquiries < ActiveRecord::Migration

  def self.up
    create_table :enquiries do |t|
      t.references  :customer
      t.references  :product
      t.text        :message
      t.timestamps
    end

  end

  def self.down
    drop_table :enquiries
  end

end