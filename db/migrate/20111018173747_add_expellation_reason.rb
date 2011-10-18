class AddExpellationReason < ActiveRecord::Migration
  def self.up
    add_column :students, :expellation_reason, :text
  end

  def self.down
    remove_column :students, :expellation_reason
  end
end
