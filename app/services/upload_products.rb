# Class to process Products CSV file upload
class UploadProducts
  require 'csv'

  def initialize(file_path, file_upload_id)
    @file_path = file_path
    @file_upload = FileUpload.find(file_upload_id)
  end

  def call
    @file_upload.processing
    process_file
  rescue
    @file_upload.error
  end

  def self.valid_file_format?(file)
    return false unless file.try(:content_type).present?
    file.content_type == "text/csv"
  end

  private

  def process_file
    opened_file = File.open(@file_path)
    CSV.foreach(opened_file, headers: true) do |row|
      UploadProductsJob.perform_later(row.to_h, @file_upload.id)
    end
  end
end