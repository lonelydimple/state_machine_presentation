class CreateAlumnus < ActiveRecord::Migration
  def self.up
    create_table :alumnus do |t|
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end

  def self.down
    drop_table :alumnus
  end
end
