class AddTypeToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :type, :string
  end

  def self.down
    remove_column :students, :type
  end
end
