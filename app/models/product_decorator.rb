module ProductDecorator
  def test_method
    p "Hello world!!!!!!"
  end
end

::Spree::Product.prepend ProductDecorator if ::Spree::Product.included_modules.exclude?(ProductDecorator)