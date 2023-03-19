require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrayAssignment < Neo::Koan
  def test_non_parallel_assignment
    names = ["John", "Smith"]
    assert_equal ["John", "Smith"], names
  end

  def test_parallel_assignments
    first_name, last_name = ["John", "Smith"]
    assert_equal "John", first_name
    assert_equal "Smith", last_name
  end

  def test_parallel_assignments_with_extra_values
    # Só pega uma quantidade de itens que preencham as variáveis declaradas
    first_name, last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal "Smith", last_name
  end

  def test_parallel_assignments_with_splat_operator
    # o splat faz com que a variável assuma o valor de uma
    # lista que contém os valores que não foram passados para uma variável
    # Exemplo: se fizesse *first_name = ["John", "Smith", "III"]
    # first_name teria o valor ["John", "Smith", "III"]
    first_name, *last_name = ["John", "Smith", "III"]
    assert_equal "John", first_name
    assert_equal ["Smith", "III"], last_name
  end

  def test_parallel_assignments_with_too_few_values
    # quando tem mais variáves que valores na lista,
    # as variáveis que tem a mais recebem o valor nil
    first_name, last_name = ["Cher"]
    assert_equal "Cher", first_name
    assert_equal nil, last_name
  end

  def test_parallel_assignments_with_subarrays
    # como o primeiro item é uma lista, ela será passada para a variável
    first_name, last_name = [["Willie", "Rae"], "Johnson"]
    assert_equal ["Willie", "Rae"], first_name
    assert_equal "Johnson", last_name
  end

  def test_parallel_assignment_with_one_variable
    # usando a vírgula depois do nome da variável, podemos pegar apenas
    # o primeiro valor da lista
    # alternativamente, poderíamos usar shift (o que altera a lista),
    # first ou [0] (que não alteram a lista)
    first_name, = ["John", "Smith"]
    assert_equal "John", first_name
  end

  def test_swapping_with_parallel_assignment
    # troca dos valores das variáveis igual python
    first_name = "Roy"
    last_name = "Rob"
    first_name, last_name = last_name, first_name
    assert_equal "Rob", first_name
    assert_equal "Roy", last_name
  end
end
