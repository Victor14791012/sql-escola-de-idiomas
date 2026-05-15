-- Banco de dados: Escola de Idiomas
CREATE DATABASE escola_idiomas;

USE escola_idiomas;

-- =========================
-- TABELA ALUNO
-- =========================
CREATE TABLE aluno (
  alun_id INT AUTO_INCREMENT PRIMARY KEY,
  alun_nome TEXT NOT NULL,
  alun_cpf VARCHAR(14) NOT NULL UNIQUE,
  alun_data_nascimento DATE NOT NULL,
  alun_telefone VARCHAR(20) NOT NULL,
  alun_endereco JSON NOT NULL,
  alun_email TEXT NOT NULL,
  alun_login VARCHAR(50) NOT NULL UNIQUE,
  alun_senha VARCHAR(255) NOT NULL
);

-- =========================
-- TABELA PROFESSOR
-- =========================
CREATE TABLE professor (
  prof_id INT AUTO_INCREMENT PRIMARY KEY,
  prof_nome TEXT NOT NULL,
  prof_cpf VARCHAR(14) NOT NULL UNIQUE,
  prof_telefone VARCHAR(20) NOT NULL,
  prof_email TEXT NOT NULL,
  prof_especialidade VARCHAR(100) NOT NULL,
  prof_login VARCHAR(50) NOT NULL UNIQUE,
  prof_senha VARCHAR(255) NOT NULL
);

-- =========================
-- TABELA FUNCIONARIO
-- =========================
CREATE TABLE funcionario (
  func_id INT AUTO_INCREMENT PRIMARY KEY,
  func_nome TEXT NOT NULL,
  func_cpf VARCHAR(14) NOT NULL UNIQUE,
  func_telefone VARCHAR(20) NOT NULL,
  func_email TEXT NOT NULL,
  func_endereco JSON NOT NULL,
  func_cargo VARCHAR(50) NOT NULL,
  func_data_contratacao DATE NOT NULL,
  func_login VARCHAR(50) NOT NULL UNIQUE,
  func_senha VARCHAR(255) NOT NULL
) ;

-- =========================
-- TABELA CURSO
-- =========================
CREATE TABLE curso (
  curs_id INT AUTO_INCREMENT PRIMARY KEY,
  curs_nome TEXT NOT NULL,
  curs_nivel ENUM('Básico', 'Intermediário', 'Avançado') NOT NULL,
  curs_carga_horaria INT NOT NULL,
  curs_duracao_meses INT NOT NULL,
  curs_descricao TEXT NOT NULL,
  curs_valor DECIMAL(10,2) NOT NULL,
  curs_status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo'
) ;

-- =========================
-- TABELA TURMA
-- =========================
CREATE TABLE turma (
  turm_id INT AUTO_INCREMENT PRIMARY KEY,
  curs_id INT NOT NULL,
  turm_nome VARCHAR(100) NOT NULL,
  turm_periodo ENUM('Manhã', 'Tarde', 'Noite') NOT NULL,
  turm_horario JSON NOT NULL,
  turm_limite_alunos INT NOT NULL DEFAULT 40,
  turm_quantidade_minima INT NOT NULL,
  turm_data_inicio DATE NOT NULL,
  turm_data_fim DATE NOT NULL,
  turm_status ENUM('ativa', 'encerrada', 'lotada', 'cancelada') NOT NULL DEFAULT 'ativa',
  CONSTRAINT fk_turma_curso
    FOREIGN KEY (curs_id) REFERENCES curso(curs_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ;

-- =========================
-- TABELA PLANO
-- =========================
CREATE TABLE plano (
  plan_id INT AUTO_INCREMENT PRIMARY KEY,
  plan_tipo ENUM('Mensal', 'Família', 'Amigos') NOT NULL UNIQUE,
  plan_descricao TEXT NOT NULL,
  plan_desconto DECIMAL(5,2) NOT NULL DEFAULT 0,
  plan_valor DECIMAL(10,2) NOT NULL,
  plan_status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo'
) ;

-- =========================
-- TABELA MATRICULA
-- =========================
CREATE TABLE matricula (
  matr_id INT AUTO_INCREMENT PRIMARY KEY,
  alun_id INT NOT NULL,
  turm_id INT NOT NULL,
  plan_id INT NOT NULL,
  matr_data DATE NOT NULL,
  matr_status ENUM('ativa', 'trancada', 'cancelada', 'concluida', 'pendente') NOT NULL DEFAULT 'pendente',
  matr_desconto DECIMAL(5,2) NOT NULL DEFAULT 0,
  matr_valor_final DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_matricula_aluno
    FOREIGN KEY (alun_id) REFERENCES aluno(alun_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_matricula_turma
    FOREIGN KEY (turm_id) REFERENCES turma(turm_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_matricula_plano
    FOREIGN KEY (plan_id) REFERENCES plano(plan_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT uq_matricula_aluno_turma UNIQUE (alun_id, turm_id)
);
-- =========================
-- TABELA PAGAMENTO
-- =========================
CREATE TABLE pagamento (
  paga_id INT AUTO_INCREMENT PRIMARY KEY,
  matr_id INT NOT NULL,
  paga_valor DECIMAL(10,2) NOT NULL,
  paga_data_vencimento DATE NOT NULL,
  paga_data_pagamento DATE NULL,
  paga_forma_pagamento ENUM('PIX', 'Cartão', 'Boleto', 'Dinheiro') NOT NULL,
  paga_status ENUM('pendente', 'aprovado', 'recusado', 'cancelado', 'reembolsado', 'expirado') NOT NULL DEFAULT 'pendente',
  paga_gateway VARCHAR(50) NOT NULL,
  paga_gateway_id VARCHAR(100) UNIQUE,
  paga_comprovante_url VARCHAR(255) NULL,
  paga_observacao TEXT NULL,
  CONSTRAINT fk_pagamento_matricula
    FOREIGN KEY (matr_id) REFERENCES matricula(matr_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- =========================
-- TABELA ATENDIMENTO
-- =========================
CREATE TABLE atendimento (
  aten_id INT AUTO_INCREMENT PRIMARY KEY,
  alun_id INT NOT NULL,
  func_id INT NOT NULL,
  aten_data_hora DATETIME NOT NULL,
  aten_tipo ENUM('matrícula', 'pagamento', 'informação', 'cancelamento', 'suporte') NOT NULL,
  aten_descricao TEXT NOT NULL,
  aten_status ENUM('finalizado', 'pendente', 'cancelado') NOT NULL DEFAULT 'finalizado',
  CONSTRAINT fk_atendimento_aluno
    FOREIGN KEY (alun_id) REFERENCES aluno(alun_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_atendimento_funcionario
    FOREIGN KEY (func_id) REFERENCES funcionario(func_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- =========================
-- TABELA AULA
-- =========================
CREATE TABLE aula (
  aula_id INT AUTO_INCREMENT PRIMARY KEY,
  turm_id INT NOT NULL,
  prof_id INT NOT NULL,
  aula_data DATE NOT NULL,
  aula_conteudo TEXT NOT NULL,
  aula_observacao TEXT NULL,
  CONSTRAINT fk_aula_turma
    FOREIGN KEY (turm_id) REFERENCES turma(turm_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_turma_professor
    FOREIGN KEY (prof_id) REFERENCES professor(prof_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- =========================
-- TABELA FREQUENCIA
-- =========================
CREATE TABLE frequencia (
  freq_id INT AUTO_INCREMENT PRIMARY KEY,
  aula_id INT NOT NULL,
  matr_id INT NOT NULL,
  freq_status ENUM('presente', 'ausente', 'justificado') NOT NULL,
  freq_observacao TEXT NULL,
  CONSTRAINT fk_frequencia_aula
    FOREIGN KEY (aula_id) REFERENCES aula(aula_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_frequencia_matricula
    FOREIGN KEY (matr_id) REFERENCES matricula(matr_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT uq_frequencia_aula_matricula UNIQUE (aula_id, matr_id)
);



-- =====================================================
-- TESTES TABELA ALUNO
-- =====================================================

INSERT INTO aluno (
  alun_nome,
  alun_cpf,
  alun_data_nascimento,
  alun_telefone,
  alun_endereco,
  alun_email,
  alun_login,
  alun_senha
) VALUES
(
  'Victor Hugo',
  '123.456.789-00',
  '2007-03-15',
  '(69)99999-1111',
  '{"rua":"Rua A","numero":"120","bairro":"Centro","cidade":"Vilhena"}',
  'victor@email.com',
  'victorh',
  'senha123'
),
(
  'Maria Oliveira',
  '987.654.321-00',
  '2005-07-20',
  '(69)99999-2222',
  '{"rua":"Rua B","numero":"50","bairro":"Jardim","cidade":"Vilhena"}',
  'maria@email.com',
  'mariao',
  'senha456'
),
(
  'Carlos Silva',
  '111.222.333-44',
  '2000-11-10',
  '(69)99999-3333',
  '{"rua":"Rua C","numero":"89","bairro":"Centro","cidade":"Vilhena"}',
  'carlos@email.com',
  'carloss',
  'senha789'
);

-- =====================================================
-- TESTES TABELA PROFESSOR
-- =====================================================

INSERT INTO professor (
  prof_nome,
  prof_cpf,
  prof_telefone,
  prof_email,
  prof_especialidade,
  prof_login,
  prof_senha
) VALUES
(
  'Ana Souza',
  '555.111.222-00',
  '(69)98888-1111',
  'ana@email.com',
  'Inglês',
  'anas',
  'senha123'
),
(
  'Pedro Lima',
  '555.111.333-00',
  '(69)98888-2222',
  'pedro@email.com',
  'Espanhol',
  'pedrol',
  'senha456'
),
(
  'Juliana Costa',
  '555.111.444-00',
  '(69)98888-3333',
  'juliana@email.com',
  'Francês',
  'julianac',
  'senha789'
);

-- =====================================================
-- TESTES TABELA FUNCIONARIO
-- =====================================================

INSERT INTO funcionario (
  func_nome,
  func_cpf,
  func_telefone,
  func_email,
  func_endereco,
  func_cargo,
  func_data_contratacao,
  func_login,
  func_senha
) VALUES
(
  'Fernanda Alves',
  '777.111.222-00',
  '(69)97777-1111',
  'fernanda@email.com',
  '{"rua":"Rua D","numero":"10","bairro":"Centro"}',
  'Atendente',
  '2024-01-15',
  'fernanda',
  'senha123'
),
(
  'Lucas Martins',
  '777.111.333-00',
  '(69)97777-2222',
  'lucas@email.com',
  '{"rua":"Rua E","numero":"20","bairro":"Centro"}',
  'Administrador',
  '2023-08-10',
  'lucasm',
  'senha456'
),
(
  'Bruna Rocha',
  '777.111.444-00',
  '(69)97777-3333',
  'bruna@email.com',
  '{"rua":"Rua F","numero":"30","bairro":"Centro"}',
  'Secretária',
  '2022-05-01',
  'brunar',
  'senha789'
);

-- =====================================================
-- TESTES TABELA CURSO
-- =====================================================

INSERT INTO curso (
  curs_nome,
  curs_nivel,
  curs_carga_horaria,
  curs_duracao_meses,
  curs_descricao,
  curs_valor,
  curs_status
) VALUES
(
  'Inglês',
  'Básico',
  120,
  6,
  'Curso básico de inglês',
  799.90,
  'ativo'
),
(
  'Espanhol',
  'Intermediário',
  100,
  5,
  'Curso intermediário de espanhol',
  899.90,
  'ativo'
),
(
  'Francês',
  'Avançado',
  140,
  8,
  'Curso avançado de francês',
  1299.90,
  'ativo'
);

-- =====================================================
-- TESTES TABELA TURMA
-- =====================================================

INSERT INTO turma (
  curs_id,
  prof_id,
  turm_nome,
  turm_periodo,
  turm_horario,
  turm_limite_alunos,
  turm_quantidade_minima,
  turm_data_inicio,
  turm_data_fim,
  turm_status
) VALUES
(
  1,
  1,
  'Inglês Básico A',
  'Noite',
  '[{"dia":"Segunda","inicio":"19:00","fim":"21:00","sala":"Sala 01"}]',
  30,
  10,
  '2026-02-01',
  '2026-07-01',
  'ativa'
),
(
  2,
  2,
  'Espanhol Intermediário',
  'Tarde',
  '[{"dia":"Terça","inicio":"14:00","fim":"16:00","sala":"Sala 02"}]',
  25,
  8,
  '2026-02-01',
  '2026-06-01',
  'ativa'
),
(
  3,
  3,
  'Francês Avançado',
  'Manhã',
  '[{"dia":"Quarta","inicio":"08:00","fim":"10:00","sala":"Sala 03"}]',
  20,
  5,
  '2026-03-01',
  '2026-10-01',
  'ativa'
);

-- =====================================================
-- TESTES TABELA PLANO
-- =====================================================

INSERT INTO plano (
  plan_tipo,
  plan_descricao,
  plan_desconto,
  plan_valor,
  plan_status
) VALUES
(
  'Mensal',
  'Plano individual mensal',
  0,
  299.90,
  'ativo'
),
(
  'Família',
  'Plano familiar com desconto',
  15,
  499.90,
  'ativo'
),
(
  'Amigos',
  'Plano para grupo de amigos',
  10,
  399.90,
  'ativo'
);

-- =====================================================
-- TESTES TABELA MATRICULA
-- =====================================================

INSERT INTO matricula (
  alun_id,
  turm_id,
  plan_id,
  matr_data,
  matr_status,
  matr_desconto,
  matr_valor_final
) VALUES
(
  1,
  1,
  1,
  '2026-01-10',
  'ativa',
  0,
  799.90
),
(
  2,
  2,
  2,
  '2026-01-12',
  'ativa',
  15,
  764.91
),
(
  3,
  3,
  3,
  '2026-01-15',
  'pendente',
  10,
  1169.91
);

-- =====================================================
-- TESTES TABELA PAGAMENTO
-- =====================================================

INSERT INTO pagamento (
  matr_id,
  paga_valor,
  paga_data_vencimento,
  paga_data_pagamento,
  paga_forma_pagamento,
  paga_status,
  paga_gateway,
  paga_gateway_id,
  paga_comprovante_url,
  paga_observacao
) VALUES
(
  1,
  299.90,
  '2026-02-05',
  '2026-02-03',
  'PIX',
  'aprovado',
  'Mercado Pago',
  'MP123456',
  'https://site.com/comprovante1.pdf',
  'Pagamento realizado com sucesso'
),
(
  2,
  499.90,
  '2026-02-10',
  NULL,
  'Boleto',
  'pendente',
  'PagSeguro',
  'PS654321',
  NULL,
  'Aguardando pagamento'
),
(
  3,
  399.90,
  '2026-02-12',
  NULL,
  'Cartão',
  'recusado',
  'Stripe',
  'ST789456',
  NULL,
  'Cartão recusado'
);

-- =====================================================
-- TESTES TABELA ATENDIMENTO
-- =====================================================

INSERT INTO atendimento (
  alun_id,
  func_id,
  aten_data_hora,
  aten_tipo,
  aten_descricao,
  aten_status
) VALUES
(
  1,
  1,
  '2026-01-05 14:00:00',
  'matrícula',
  'Aluno realizou matrícula',
  'finalizado'
),
(
  2,
  2,
  '2026-01-06 15:30:00',
  'informação',
  'Aluno pediu informações sobre cursos',
  'finalizado'
),
(
  3,
  3,
  '2026-01-07 16:00:00',
  'pagamento',
  'Aluno relatou problema no pagamento',
  'pendente'
);

-- =====================================================
-- TESTES TABELA AULA
-- =====================================================

INSERT INTO aula (
  turm_id,
  aula_data,
  aula_conteudo,
  aula_observacao
) VALUES
(
  1,
  '2026-02-10',
  'Verbo To Be',
  'Aula introdutória'
),
(
  2,
  '2026-02-11',
  'Conversação básica',
  'Participação excelente'
),
(
  3,
  '2026-02-12',
  'Gramática avançada',
  'Necessário revisar conteúdo'
);

-- =====================================================
-- TESTES TABELA FREQUENCIA
-- =====================================================

INSERT INTO frequencia (
  aula_id,
  matr_id,
  freq_status,
  freq_observacao
) VALUES
(
  1,
  1,
  'presente',
  'Aluno participou normalmente'
),
(
  2,
  2,
  'ausente',
  'Aluno faltou sem justificativa'
),
(
  3,
  3,
  'justificado',
  'Atestado médico apresentado'
);