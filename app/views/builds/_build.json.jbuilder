json.extract! build, :id, :product_id, :product_version, :version, :container_repository, :container_tag, :validated_at, :published_at, :permissions, :release_notes, :created_at, :updated_at
json.url product_build_url(build.product, build)
