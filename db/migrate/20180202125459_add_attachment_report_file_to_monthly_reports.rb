class AddAttachmentReportFileToMonthlyReports < ActiveRecord::Migration
  def self.up
    change_table :monthly_reports do |t|
      t.attachment :report_file
    end
  end

  def self.down
    remove_attachment :monthly_reports, :report_file
  end
end
