json.extract! voucher, :id, :product_license_id, :entitlement_id, :code, :issued_at, :expires_at, :redeemed_at, :redeemed_by, :created_at, :updated_at
json.url voucher_url(voucher, format: :json)
