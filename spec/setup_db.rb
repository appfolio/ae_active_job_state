# frozen_string_literal: true

require 'generators/ae_active_job_state/templates/create_ae_active_job_state_tables'

ActiveRecord::Base.logger = Logger.new(File.join('log', 'test.log'))

ActiveRecord::Tasks::DatabaseTasks.env = 'test'
ActiveRecord::Base.configurations = {
  'test' => {
    adapter: 'mysql2',
    database: 'ae_active_job_state_test',
    username: 'root',
    host: '127.0.0.1',
    encoding: 'utf8mb4',
    port: 3307        # assume that Mysql 5.6 runs at port 3306 and 5.7 runs at port 3307
  }
}
ActiveRecord::Base.logger = Logger.new(File.join('log', 'test.log'))
ActiveRecord::Tasks::DatabaseTasks.drop_current
ActiveRecord::Tasks::DatabaseTasks.create_current

CreateAeActiveJobStateTables.suppress_messages do
  CreateAeActiveJobStateTables.migrate(:up)
end
