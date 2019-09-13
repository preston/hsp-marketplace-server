json.extract! build, :id, :product_id, :version, :release_notes, :permissions, :container_repository, :container_tag, :validated_at, :published_at, :created_at, :updated_at

json.asset_available build.asset.attached?

json.path product_build_path(build.product, build)
json.url product_build_url(build.product, build)
