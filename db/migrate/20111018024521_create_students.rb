class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :high_school
      t.text :suspension_reason
      t.date :registration_date
      t.float :gpa
      t.timestamps
    end
  end

  def self.down
    drop_table :students
  end
end
