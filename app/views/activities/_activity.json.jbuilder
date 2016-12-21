if activity
    json.extract! activity, :id, :name, :description, :started_at, :ended_at, :semantic_uri, :place_id, :system, :parent_id, :next_id, :scope_id
    json.extract! activity, :created_at,	:updated_at
    json.url activity_url(activity)
    json.path activity_path(activity)
    json.actor_roles do
        json.partial! 'actor_roles/actor_role', collection: activity.actor_roles, as: :actor_role
    end
    json.usage_roles do
        json.partial! 'usage_roles/usage_role', collection: activity.usage_roles, as: :usage_role
    end
    json.objectives do
        json.partial! 'objectives/objective', collection: activity.objectives, as: :objective
    end

    if recurse
        json.parent do
            json.partial! 'activities/activity', activity: activity.parent, recurse: false
        end
        json.child_activities do
            json.array! activity.child_activities do |a|
                json.partial! 'activities/activity', activity: a, recurse: false
            end
        end
        json.scope do
            json.partial! 'activities/activity', activity: activity.scope, recurse: false
        end
        json.scoped_activities do
            json.array! activity.scoped_activities do |a|
                json.partial! 'activities/activity', activity: a, recurse: false
            end
        end
        json.next do
            json.partial! 'activities/activity', activity: activity.next, recurse: false
        end
        json.previous_activities do
            json.array! activity.previous_activities do |a|
                json.partial! 'activities/activity', activity: a, recurse: false
            end
        end
    end
end
