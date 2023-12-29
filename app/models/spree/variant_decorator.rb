module Spree
  module VariantDecorator
    def test_method
      p "Hello world!!!!!!"
    end
  end
end

::Spree::Variant.prepend Spree::VariantDecorator if ::Spree::Variant.included_modules.exclude?(Spree::VariantDecorator)