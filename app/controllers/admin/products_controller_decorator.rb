module Admin
  module ProductsControllerDecorator
    def self.prepended(base)
      base.before_action :authorize_admin, only: [:upload, :process_upload, :upload_status]
    end

    def upload
    end

    def process_upload
      file = params["file"]
      unless UploadProducts.valid_file_format?(file)
        flash.now[:error] = I18n.t("products.upload.file_error")
        return render :upload
      end

      file_upload = FileUpload.create_upload(file, spree_current_user.id)
      UploadProducts.new(file, file_upload.id).call

      flash[:notice] = I18n.t("products.upload.processing")
      redirect_to admin_products_upload_status_path(upload_id: file_upload.id)
    end

    def upload_status
      @file_upload = FileUpload.file_upload_for(params[:upload_id], spree_current_user.id)

      if @file_upload.nil?
        flash[:notice] = I18n.t("products.upload.status_error")
        redirect_to admin_products_upload_path
      end
    end

    private

    def authorize_admin
      authorize! :create, Spree::Product
    end
  end
end

Spree::Admin::ProductsController.prepend Admin::ProductsControllerDecorator