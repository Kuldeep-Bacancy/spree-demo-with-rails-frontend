class UploadProductsJob < ActiveJob::Base

  def perform(product_row, file_upload_id)
    @file_upload = FileUpload.find(file_upload_id)
    @errors = []
    process_row(product_row)
    update_file_upload
  end

  private

  def process_row(row)
    ActiveRecord::Base.transaction do
      product = Spree::Product.find_by(slug: row["slug"])

      if product.present?
        update_product(product, row)
      else
        product = create_new_product(row)
        product.stores << spree_store(row["store_name"])
      end
    end
  rescue => e
    handle_error(e)
  end

  def update_product(product, row)
    product.update!(product_params(row).except(:slug))
  end

  def create_new_product(row)
    product = Spree::Product.find_or_initialize_by(
      name: row["name"],
      description: row["description"],
      available_on: row["availability_date"],
      slug: row["slug"],
      shipping_category_id: default_shipping_category.id,
      status: "active"
    )
    product.save(validate: false)
    product
  end

  def handle_error(e)
    message = if e.try(:record).present?
                e.record.errors.full_messages.join(", ")
              else
                e.message.sub(/.+:/, "")
              end

    @errors << "#{message}"
  end

  def default_shipping_category
    @_default_shipping_category ||= Spree::ShippingCategory.first_or_create!(name: "default")
  end

   def update_file_upload
    @file_upload.update(
      error_data: @errors,
      state: FileUpload::STATES[:done]
    )
  end

  def spree_store(store_name)
    store_name.present? ? Spree::Store.find_by_name(store_name) : Spree::Store.default
  end
end