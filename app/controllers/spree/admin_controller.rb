class Spree::AdminController < ApplicationController

  def export_products
    respond_to do |format|
      format.html
      format.csv { send_data Spree::Product.to_csv, filename: "products-#{DateTime.now.strftime("%d/%m/%Y-%s")}.csv" }
    end
  end
end