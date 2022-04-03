require 'csv'
require 'mongo'

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'teste')

clientes_totais = client[:CNPJ].count
clientes_ativos = client[:CNPJ].count(:situacao_cadastral => "02")
porcentagem_ativos = clientes_ativos.to_f / clientes_totais.to_f * 100

ativos = client[:CNPJ].find(:situacao_cadastral => "02")

puts "#{porcentagem_ativos}% de estabelecimentos ativos em um total de #{clientes_ativos} estabelecimentos de #{clientes_totais} possíveis"

column_names = ativos.first.keys

s = CSV.generate do |csv|
    csv << column_names
    ativos.each do |x|
      csv << x.values
    end
  end
  File.write('estabelecimentos_ativos.csv', s)

client.close