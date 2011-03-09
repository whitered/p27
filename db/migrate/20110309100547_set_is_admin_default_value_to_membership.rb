class SetIsAdminDefaultValueToMembership < ActiveRecord::Migration
  def self.up
    change_column_default :memberships, :is_admin, :false
  end

  def self.down
    change_column_default :memberships, :is_admin, :nil
  end
end
