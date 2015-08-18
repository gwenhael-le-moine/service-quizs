# coding: utf-8
#
# model for 'question' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# quiz_id                       | int(11)                        | false    | MUL      |                   |
# type                          | enum('QCM', 'TAT', 'ASS')      | false    |           |                   |
# question                      | varchar(256                    | false    |          |                   |
# hint                          | varchar(2000)                  | true     |          |                   |
# correction_comment            | varchar(2000)                  | true     |          |                   |
# order                         | int(11)                        | false    |          |                   |
# medium_id                     | boolean                        | true     | MUL      |                   |
# opt_rand_suggestion_order     | boolean                        | false    |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Question < Sequel::Model(:question)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :quiz
  one_to_one :medium
  one_to_many :suggestion

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:quiz_id, :type, :question, :order, :opt_rand_suggestion_order]
  end
end
