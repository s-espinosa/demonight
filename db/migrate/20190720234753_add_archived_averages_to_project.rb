class AddArchivedAveragesToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :archived_average_representation, :float
    add_column :projects, :archived_average_challenge, :float
    add_column :projects, :archived_average_wow, :float
    add_column :projects, :archived_average_total, :float
  end
end
