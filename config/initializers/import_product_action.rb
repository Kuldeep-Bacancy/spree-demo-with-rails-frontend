Rails.application.config.after_initialize do
  Rails.application.config.spree_backend.actions[:products].add(
    Spree::Admin::Actions::ActionBuilder.new('import_products', Spree::Core::Engine.routes.url_helpers.admin_import_products_path).
      with_icon_key('list.svg').
      with_method(:post).
      with_style(Spree::Admin::Actions::ActionStyle::SECONDARY).
      build
  )
  Rails.application.config.spree_backend.actions[:products].add(
    Spree::Admin::Actions::ActionBuilder.new('export_products', Spree::Core::Engine.routes.url_helpers.admin_export_products_path(format: :csv)).
      with_icon_key('list.svg').
      with_style(Spree::Admin::Actions::ActionStyle::PRIMARY).
      with_method(:get).
      build
  )
end