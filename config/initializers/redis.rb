redis_conf = {
  host: Rails.application.secrets[:redis][:end_point],
  port: Rails.application.secrets[:redis][:port]
}
app_name = Rails.application.class.parent_name.underscore
Redis.current = Redis::Namespace.new("#{app_name}-#{Rails.env}",
                                     redis: Redis.new(redis_conf))
# To clear out the db before each test
Redis.current.flushdb if Rails.env.test?
