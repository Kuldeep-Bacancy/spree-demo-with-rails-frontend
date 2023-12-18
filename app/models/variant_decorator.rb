module VariantDecorator
  def test_method
    p "Hello world!!!!!!"
  end
end

::Spree::Variant.prepend VariantDecorator if ::Spree::Variant.included_modules.exclude?(VariantDecorator)