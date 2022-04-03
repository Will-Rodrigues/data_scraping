require 'mongo'
require 'csv'

time_init = DateTime.now
p 'Iniciado em: ' + time_init.inspect

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'teste')

heads = %i{CNPJ_basico CNPJ_ordem CNPJ_dv identificador_matriz_filial nome_fantasia situacao_cadastral data_situacao_cadastral motivo_situacao_cadastral nome_cidade_exterior cod_pais data_inicio_atividades cnae_principal cnae_secundario tipo_logradouro logradouro numero complemento bairro cep uf municipio ddd_1 telefone_1 ddd_2 telefone_2 ddd_fax num_fax correio_eletronico situacao_especial data_situacao_especial}

int = CSV.read("parte_estabelecimentos.csv", :col_sep => ";", liberal_parsing: true, encoding: "UTF-8:iso-8859-1", invalid: :replace, undef: :replace, replace: '?').map {|a| Hash[ heads.zip(a) ]}

int.each do |int|
  client[:CNPJ].insert_one(int)
end

time_final = DateTime.now
p 'Finalizado em: ' + time_final.inspect