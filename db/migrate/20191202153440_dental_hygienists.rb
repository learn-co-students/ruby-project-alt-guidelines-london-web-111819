class DentalHygienists < ActiveRecord::Migration[6.0]
  def change
    create_table :dental_hygienists do |t|
      t.string :name
      t.string :location
    end
  end
end
