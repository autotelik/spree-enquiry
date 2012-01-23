class ExtendProductsVariants < ActiveRecord::Migration

  def self.up
    
    # Enable/disable whether enquiry button appears next to a product
    add_column :variants, :is_enquirable,  :boolean, :default => false
  end

  def self.down                   
    change_table :variants do |t|
      t.remove   :is_enquirable
    end
  end

end
