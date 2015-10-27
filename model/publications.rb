# coding: utf-8
#
# model for 'publications' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# quiz_id                       | int(11)                        | false    | MUL      |                   |
# from_date                     | datetime                       | true     |           |                   |
# to_date                       | datetime                       | true     |          |                   |
# rgpt_id                       | int(11)                        | false    |          |                   |
# opt_show_score                | enum('after_each', 'at_end')   | true     |          |                   |
# opt_show_correct              | enum('after_each', 'at_end')   | true     |          |                   |
# opt_can_redo                  | boolean                        | false    |          |                   |
# opt_can_rewind                | boolean                        | false    |          |                   |
# opt_rand_question_order       | boolean                        | false    |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Publications < Sequel::Model(:publications)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :quizs
  one_to_many :sessions

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:quiz_id, :rgpt_id, :opt_show_score, :opt_show_correct, :opt_can_redo, :opt_can_rewind, :opt_rand_question_order]
    validates_unique :rgpt_id
  end
end