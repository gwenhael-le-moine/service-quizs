# coding: utf-8
#
# model for 'quizs' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# created_at                     | datetime                      | true     |           |                   |
# updated_at                     | datetime                      | true     |          |                   |
# user_id                       | varchar(8)                     | false    |          |                   |
# label                         | varchar(100)                   | true     |          |                   |
# opt_show_score                | enum('after_each', 'at_end')   | true     |          |                   |
# opt_show_correct              | enum('after_each', 'at_end')   | true     |          |                   |
# opt_can_redo                  | boolean                        | false    |          |                   |
# opt_can_rewind                | boolean                        | false    |          |                   |
# opt_rand_question_order       | boolean                        | false    |          |                   |
# opt_shared                    | boolean                        | false    |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Quizs < Sequel::Model(:quizs)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  one_to_many :questions
  one_to_many :publications

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:user_id, :opt_show_score, :opt_show_correct, :opt_can_redo, :opt_can_rewind, :opt_rand_question_order, :opt_shared]
  end
end
