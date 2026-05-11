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
  prof_id INT NOT NULL,
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
    ON DELETE RESTRICT,
  CONSTRAINT fk_turma_professor
    FOREIGN KEY (prof_id) REFERENCES professor(prof_id)
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
  aula_data DATE NOT NULL,
  aula_conteudo TEXT NOT NULL,
  aula_observacao TEXT NULL,
  CONSTRAINT fk_aula_turma
    FOREIGN KEY (turm_id) REFERENCES turma(turm_id)
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