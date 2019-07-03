json.extract! claim, :id, :claimant_id, :claimant_type, :entitlement_id, :authorization_count, :authorized_at, :created_at, :updated_at
json.url claim_url(claim, format: :json)
