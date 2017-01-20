json.extract! identity, :id,
              :user_id,
              :identity_provider_id,
              :sub,
              :iat,
              :hd,
              :locale,
              :email,
              :jwt,
              :notify_via_email,
              :notify_via_sms,
			  :created_at,
			  :updated_at
json.url user_identity_url(identity.user, identity)
