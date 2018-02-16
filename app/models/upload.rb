class Upload < ActiveRecord::Base

	 has_attached_file :effort_file, presence: true

     validates_attachment_content_type :effort_file, content_type: { content_type: [
                     "application/vnd.ms-excel",
                     "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                   ]
                   },
                   message: ' Only EXCEL files are allowed.'
end
