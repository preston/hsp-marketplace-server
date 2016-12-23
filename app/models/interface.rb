class Interface < ApplicationRecord

	has_many	:substitutes,	class_name: 'Surrogate', foreign_key: :interface_id
	has_many	:surrogates, foreign_key: :substitute_id

	has_many	:surrogated_interfaces,	through: :surrogates
	has_many	:substituted_interfaces,	class_name: 'Interface'

    has_many	:exposures,	dependent: :destroy
    has_many	:dependencies,	dependent: :destroy

end
