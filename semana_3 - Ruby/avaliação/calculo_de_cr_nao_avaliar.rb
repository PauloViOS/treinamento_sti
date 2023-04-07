require 'csv'

table = CSV.parse(File.read("notas.csv"), headers: true)

class Curso
  @@cursos = {}

  def initialize codigo
    @codigo = codigo
    @@cursos[@codigo] = {}
    @@cursos[@codigo]["cr"] = 0
    @@cursos[@codigo]["disciplinas"] = []
  end

  def self.cria_bd_cursos table
    table.each do |linha|
      codigo = linha["COD_CURSO"]
      @@cursos.has_key?(codigo) ? next : Curso.new(codigo)
    end
  end

  def self.mostra_cursos
    @@cursos.each do |curso, disciplinas|
      puts "#{curso}: #{disciplinas}"
    end
  end

  def self.adiciona_disciplina_no_curso(curso, hash_da_disciplina)
    @@cursos[curso]["disciplinas"] << hash_da_disciplina
  end

  def self.calcula_cr_medio_dos_cursos
    infos_cursos = {}
    @@cursos.each_key do |curso|
      infos_cursos[curso] = {
        :cr_acumulado => 0,
        :qtde_alunos => 0,
        :cr_medio => 0
      }
    end
    Aluno.alunos.each_value do |infos_aluno|
      curso = infos_aluno[:curso]
      infos_cursos[curso][:cr_acumulado] += infos_aluno[:cr]
      infos_cursos[curso][:qtde_alunos] += 1
    end
    infos_cursos.each_value do |infos|
      infos[:cr_medio] = (infos[:cr_acumulado]/infos[:qtde_alunos]).round(2)
    end
    @@cursos.each do |curso, infos|
      infos["cr"] = infos_cursos[curso][:cr_medio]
    end
  end

  def self.mostrar_cr_de_todos_os_cursos
    puts "----- Média de CR dos Cursos -----"
    @@cursos.each do |curso, dict|
      # puts "#{curso}  -  #{dict["cr"]}"
      printf "%-4s - %4d\n", curso, dict["cr"]
    end
    puts "----------------------------------"
  end
end

class Disciplina
  @@disciplinas = {}

  def initialize codigo, carga, curso
    @codigo = codigo
    @carga = carga
    @curso = curso
    @@disciplinas[@codigo.to_sym] = {
      "carga" => @carga,
      "curso" => @curso
    }
  end

  def self.cria_bd_disciplinas table
    table.each do |linha|
      carga = linha["CARGA_HORARIA"]
      codigo = linha["COD_DISCIPLINA"]
      curso = linha["COD_CURSO"]
      @@disciplinas.has_key?(codigo) ? next : Disciplina.new(codigo, carga, curso)
    end
  end

  def self.adiciona_disc_nos_cursos
    @@disciplinas.each do |disciplina, hash|
      carga = hash["carga"]
      curso = hash["curso"]
      disciplina_carga = {"disciplina": disciplina, "carga": carga}
      Curso.adiciona_disciplina_no_curso(curso, disciplina_carga)
    end
  end

  def self.mostra_disciplinas
    print @@disciplinas
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
    @@alunos[@matricula][:cr] = 0
    @@alunos[@matricula][:curso] = curso
    @@alunos[@matricula][:disciplinas] =  []
  end

  def self.adicionar_nota matricula, disciplina, nota, carga_horaria, ano_semestre
    @@alunos[matricula][:disciplinas] << {
      :disciplina => disciplina,
      :nota => nota,
      :ano_semestre => ano_semestre,
      :carga_horaria => carga_horaria
    }
  end

  def self.calcular_cr matricula
    carga_total = 0
    nota_vezes_carga_total = 0
    @@alunos[matricula][:disciplinas].each do |disciplina|
      carga = disciplina[:carga_horaria].to_i
      nota = disciplina[:nota].to_f.round(2)
      carga_total += carga
      nota_vezes_carga_total += carga*nota
    end
    calculo_cr = nota_vezes_carga_total/carga_total
    @@alunos[matricula][:cr] = calculo_cr.round(2)
  end

  def self.mostrar_cr_de_todos_os_alunos
    puts "------- O CR dos alunos é: -------"
    @@alunos.each do |aluno, dict|
      puts "#{aluno}  -  #{dict[:cr]}"
    end
    puts "----------------------------------"
  end

  def self.cria_bd_dos_alunos table
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

  def self.mostra_alunos
    @@alunos.each do |aluno, infos|
      puts "#{aluno}: #{infos}"
    end
  end

end

Curso.cria_bd_cursos table
Disciplina.cria_bd_disciplinas table
Aluno.cria_bd_dos_alunos table

Disciplina.adiciona_disc_nos_cursos
Aluno.calcular_cr_de_todos
Curso.calcula_cr_medio_dos_cursos

Aluno.mostrar_cr_de_todos_os_alunos
Curso.mostrar_cr_de_todos_os_cursos
