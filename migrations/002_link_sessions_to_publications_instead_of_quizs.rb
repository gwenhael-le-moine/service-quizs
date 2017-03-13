Sequel.migration do
	change do
 		alter_table(:sessions) do
 			drop_foreign_key(:quiz_id)
 			add_foreign_key :publication_id, :publications
		end
	end
end