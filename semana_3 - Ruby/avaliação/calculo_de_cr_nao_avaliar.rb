require 'csv'

table = CSV.parse(File.read("notas.csv"), headers: true)

class Curso
  @@cursos = {}
  def initialize codigo
    @codigo = codigo
    @@cursos[@codigo] = {}
  end

  def self.cria_bd_cursos table
    table.each do |linha|
      codigo = linha["COD_CURSO"]
      @@cursos.has_key?(codigo) ? next : @@cursos[codigo] = []
    end
  end

  def self.mostra_cursos
    print @@cursos
  end
end

class Disciplina
  @@disciplinas = {}
  def initialize table
    table.each do |linha|
      @carga = linha["CARGA_HORARIA"]
      @codigo = linha["COD_DISCIPLINA"]
      @codigo = linha["COD_CURSO"]

    end
  end
end

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

  def self.monta_bd_dos_alunos table
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
  end

  def self.calcular_cr_de_todos
    @@alunos.each_key { |matricula| calcular_cr matricula}
  end

end

Curso.cria_bd_cursos table
Curso.mostra_cursos


# Aluno.monta_bd_dos_alunos table
# Aluno.calcular_cr_de_todos
# Aluno.mostrar_cr_de_todos_os_alunos
