json.extract! build, :id, :product_id, :version, :container_repository, :container_tag, :validated_at, :published_at, :permissions, :release_notes, :created_at, :updated_at

json.asset build.asset.attached?
json.path product_build_path(build.product, build)
json.url product_build_url(build.product, build)
