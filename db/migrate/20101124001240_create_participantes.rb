class CreateParticipantes < ActiveRecord::Migration
  def self.up
    create_table :participantes do |t|
      t.string :nome
      t.string :email
      t.string :endereco
      t.string :bairro
      t.string :zona
      t.string :cep
      t.string :cidade
      t.string :estado
      t.string :telefone
      t.string :celular
      t.string :recado
      t.string :nasc
      t.integer :idade
      t.string :peso

      t.timestamps
    end
  end

  def self.down
    drop_table :participantes
  end
end
