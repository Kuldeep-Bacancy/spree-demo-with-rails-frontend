module Spree
  module ProductDecorator
    def test_method
      p "Hello world!!!!!!"
    end

    Spree::Product.instance_eval do
      def self.to_csv
        attributes = column_names

        CSV.generate(headers: true) do |csv|
          csv << attributes

          all.find_each do |prd|
            csv << attributes.map{ |attr| prd.send(attr) }
          end
        end
      end
    end
  end
end

::Spree::Product.prepend Spree::ProductDecorator if ::Spree::Product.included_modules.exclude?(Spree::ProductDecorator)