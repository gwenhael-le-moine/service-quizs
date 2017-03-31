Sequel.migration do
  change do
  	alter_table(:suggestions) do
  		add_column :leurre_id, Integer
  	end
  end
end
