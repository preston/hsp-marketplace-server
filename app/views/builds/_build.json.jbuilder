json.extract! build, :id, :service_id, :service_version, :version, :container_repository, :container_tag, :validated_at, :published_at, :permissions, :release_notes, :created_at, :updated_at
json.url service_build_url(build.service, build)
