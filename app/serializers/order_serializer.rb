class OrderSerializer
  include JSONAPI::Serializer

  attribute :id, :name, :item_total, :total, :state, :payment_total, :adjustment_total, :shipment_state, :item_count, :payment_state, :email, :channel, :currency, :created_at, :updated_at

  attribute :store do |obj|
    obj.store&.name || ""
  end

  attribute :shipping_address do |obj|
    ship_address = obj.ship_address
    { name: "#{ship_address.firstname} #{ship_address.lastname}", 
      address1: ship_address.address1,
      address2: ship_address.address2,
      city: ship_address.city,
      zipcode: ship_address.zipcode,
      state: ship_address&.state&.name,
      country: ship_address&.country&.name,
      phone: ship_address.phone 
    }
  end

  attribute :billing_address do |obj|
    ship_address = obj.bill_address
    { name: "#{ship_address.firstname} #{ship_address.lastname}", 
      address1: ship_address.address1,
      address2: ship_address.address2,
      city: ship_address.city,
      zipcode: ship_address.zipcode,
      state: ship_address&.state&.name,
      country: ship_address&.country&.name,
      phone: ship_address.phone 
    }
  end

  attribute :line_items do |obj|
    obj.line_items.map do |li|
      { id: li.id, quantity: li.quantity, currency: li.currency, tax_category: li.tax_category&.name, price: li.price, pre_tax_amount: li.pre_tax_amount }
    end
  end
end