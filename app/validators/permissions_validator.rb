class PermissionsValidator < ActiveModel::Validator
    def validate(role)
        # valid = false
        if role.permissions.nil?
            role.errors[:permissions] << 'must not be null'
        elsif !role.permissions.is_a?(Hash)
            role.errors[:permissions] << 'must be a JSON object (aka associative array, aka hash map), not a regular array or bare string'
        else
            template = Role.permissions_template
            # byebug
            if (template.keys & role.permissions.keys).sort == template.keys.sort # the root-level keys match the template
                template.each do |resource, settings|
                    if settings.is_a?(Hash) && role.permissions[resource].is_a?(Hash) # the value is a Hash of... something
                        if (settings.keys & role.permissions[resource].keys).sort == settings.keys.sort # the permission key names match the template, as well
                            other_values = role.permissions[resource].values.uniq - [true, false]
                            if other_values == [] # the values are only of boolean type.
                            # This particular resource permission set looks good!
                            else
                              role.errors[:permissions] << "associate array for '#{resource}' must only contain boolean values"
                            end
                        else
                            role.errors[:permissions] << "must be a '#{resource}' object with permissions for #{template[resource].keys.join(', ')}"
                        end
                    else
                        role.errors[:permissions] << 'must be an associative array of associative arrays'
                    end
                end
            else
                role.errors[:permissions] << "must contain resource permissions sets for all of: #{template.keys.join(', ')}"
            end
        end
        role.errors[:permissions].empty?
  end
end
