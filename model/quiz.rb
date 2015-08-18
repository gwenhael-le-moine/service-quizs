# coding: utf-8
#
# model for 'quiz' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# create_at                     | datetime                       | true     |           |                   |
# update_at                     | datetime                       | true     |          |                   |
# user_id                       | int(11)                        | false    |          |                   |
# label                         | varchar(8)                     | true     |          |                   |
# opt_show_score                | enum('after_each', 'at_end')   | false    |          |                   |
# opt_show_correct              | enum('after_each', 'at_end')   | false    |          |                   |
# opt_can_redo                  | boolean                        | false    |          |                   |
# opt_can_rewind                | boolean                        | false    |          |                   |
# opt_rand_question_order       | boolean                        | false    |          |                   |
# opt_share                     | varchar(45)                    | true     |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Quiz < Sequel::Model(:quiz)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  one_to_many :question
  one_to_many :publication

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:user_id, :opt_show_score, :opt_show_correct, :opt_can_redo, :opt_can_rewind, :opt_rand_question_order]
    validates_unique :user_id
  end
end
