# coding: utf-8
#
# model for 'suggestion' table
# generated 2015-08-18 12:12:38 +0200 by /home/hquenin/.rbenv/versions/2.2.2/bin/rake
#
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# COLUMN_NAME                   | DATA_TYPE                      | NULL?    | KEY      | DEFAULT           | EXTRA
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
# id                            | int(11)                        | false    | PRI      |                   |
# question_id                   | int(11)                        | false    | MUL      |                   |
# text                          | varchar(2000)                  | false    |           |                   |
# order                         | int(11)                        | true     |          |                   |
# medium_id                     | int(11)                        | true     | MUL      |                   |
# position                      | enum('L', 'R')                 | true     |          |                   |
# ------------------------------+---------------------+----------+----------+-------------------+--------------------
#
class Suggestion < Sequel::Model(:suggestion)
  # Plugins
  plugin :validation_helpers
  plugin :json_serializer
  plugin :composition

  # Referential integrity
  many_to_one :question
  one_to_many :answer, key: :left_suggestion_id
  one_to_many :answer, key: :right_suggestion_id
  one_to_many :solution, key: :left_suggestion_id
  one_to_many :solution, key: :right_suggestion_id

  # Not nullable cols and unicity validation
  def validate
    super
    validates_presence [:question_id, :text]
  end
end
