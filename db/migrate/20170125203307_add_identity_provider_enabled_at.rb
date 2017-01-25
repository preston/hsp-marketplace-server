class AddIdentityProviderEnabledAt < ActiveRecord::Migration[5.0]
    def change
        add_column :identity_providers, :enabled_at, :datetime
		IdentityProvider.update(enabled_at: Time.now) # so we don't lock ourselves out.
    end
end
