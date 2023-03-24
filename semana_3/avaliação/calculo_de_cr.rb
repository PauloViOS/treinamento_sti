require 'csv'

table = CSV.parse(File.read("notas.csv"), headers: true)
puts table[0]["ANO_SEMESTRE"]