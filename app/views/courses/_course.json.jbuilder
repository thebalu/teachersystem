json.extract! course, :id, :name, :ctype, :description, :ects, :limit, :created_at, :updated_at, :signup_count
json.url course_url(course, format: :json)
