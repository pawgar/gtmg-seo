class AddAttachmentEffortFileToUploads < ActiveRecord::Migration
  def self.up
    change_table :uploads do |t|
      t.attachment :effort_file
    end
  end

  def self.down
    remove_attachment :uploads, :effort_file
  end
end
