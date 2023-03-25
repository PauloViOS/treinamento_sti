require 'csv'

table = CSV.parse(File.read("notas.csv"), headers: true)

class Aluno
  @@alunos = {}

  def self.alunos
    @@alunos
  end
  
  def initialize matricula, curso
    @matricula = matricula
    @@alunos[@matricula] = {}
    @@alunos[@matricula]["cr"] = 0
    @@alunos[@matricula]["curso"] = curso
    @@alunos[@matricula]["disciplinas"] =  []
  end
  
  def self.adicionar_nota matricula, disciplina, nota, carga_horaria, ano_semestre
    @@alunos[matricula]["disciplinas"] << {
      "disciplina": disciplina,
      "nota": nota,
      "ano_semestre": ano_semestre,
      "carga_horaria": carga_horaria
    }
  end

  def self.calcular_cr matricula
    carga_total = 0
    nota_vezes_carga_total = 0
    for disciplina in @@alunos[matricula]["disciplinas"]
      carga = disciplina[:carga_horaria].to_i
      nota = disciplina[:nota].to_f.round(2)
      carga_total += carga
      nota_vezes_carga_total += carga*nota
    end
    calculo_cr = nota_vezes_carga_total/carga_total
    @@alunos[matricula]["cr"] = calculo_cr.round(2)
  end

  def self.mostrar_cr_de_todos_os_alunos
    puts "----- O CR dos alunos é -----"
    @@alunos.each do |aluno, dict|
      puts "#{aluno}  -  #{dict["cr"]}"
    end
    puts "-----------------------------"
  end

end

table.each { |linha|
  matricula = linha["MATRICULA"]
  curso = linha["COD_CURSO"]
  Aluno.alunos.key?(matricula) ? next : Aluno.new(matricula, curso)
}

table.each { |linha|
  matricula = linha["MATRICULA"]
  disciplina = linha["COD_DISCIPLINA"]
  nota = linha["NOTA"]
  carga_horaria = linha["CARGA_HORARIA"]
  ano_semestre = linha["ANO_SEMESTRE"]
  Aluno.adicionar_nota matricula, disciplina, nota, carga_horaria, ano_semestre
}

table.each { |linha|
  matricula = linha["MATRICULA"]
  Aluno.calcular_cr matricula
}

Aluno.mostrar_cr_de_todos_os_alunos
