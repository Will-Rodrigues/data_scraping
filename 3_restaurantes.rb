require 'mongo'
require 'csv'

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'teste')

for ano in 1950...2023 do
    ano_str = ano.to_s
    restaurantes = client[:CNPJ].count(:cnae_principal => /561/, :data_inicio_atividades => /#{ano_str}/)
    puts "#{restaurantes} restaurantes abertos em #{ano}"
end

restaurantes = client[:CNPJ].find(:cnae_principal => /561/)

column_names = restaurantes.first.keys

s = CSV.generate do |csv|
    csv << column_names
    restaurantes.each do |x|
      csv << x.values
    end
  end
  File.write('restaurantes.csv', s)

client.close