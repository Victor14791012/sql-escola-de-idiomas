create database escola_idiomas;
use escola_idiomas;

create table aluno(
    alun_id int auto_increment,
    constraint pk_aluno
    primary key(alun_id),

    alun_nome text not null,
    alun_cpf varchar(14) not null unique,
    alun_data_nascimento date not null,
    alun_telefone varchar(20) not null,
    alun_endereco json not null,
    alun_email text not null,
    alun_login varchar(50) not null unique,
    alun_senha varchar(255) not null
);


create table professor(
    prof_id int auto_increment,
    constraint pk_professor
    primary key(prof_id),

    prof_nome text not null,
    prof_cpf varchar(14) not null unique,
    prof_telefone varchar(20) not null,
    prof_email text not null,
    prof_especialidade varchar(100) not null,
    prof_login varchar(50) not null unique,
    prof_senha varchar(255) not null
);


create table funcionario(
    func_id int auto_increment,
    constraint pk_funcionario
    primary key(func_id),

    func_nome text not null,
    func_cpf varchar(14) not null unique,
    func_telefone varchar(20) not null,
    func_email text not null,
    func_endereco json not null,
    func_cargo varchar(50) not null,
    func_data_contratacao date not null,
    func_login varchar(50) not null unique,
    func_senha varchar(255) not null
);

create table curso(
    curs_id int auto_increment,
    constraint pk_curso
    primary key(curs_id),

    curs_nome text not null,
    curs_nivel enum('Básico', 'Intermediário', 'Avançado') not null,
    curs_carga_horaria int not null,
    curs_duracao_meses int not null,
    curs_descricao text not null,
    curs_valor decimal(10,2) not null,
    curs_status enum('ativo', 'inativo') not null default 'ativo'
);


create table turma(
    turm_id int auto_increment,
    constraint pk_turma
    primary key(turm_id),

    curs_id int not null,
    turm_nome varchar(100) not null,
    turm_periodo enum('Manhã', 'Tarde', 'Noite') not null,
    turm_horario json not null,
    turm_limite_alunos int not null default 40,
    turm_quantidade_minima int not null,
    turm_data_inicio date not null,
    turm_data_fim date not null,
    turm_status enum('ativa', 'encerrada', 'lotada', 'cancelada') not null default 'ativa',

    constraint fk_turma_curso
    foreign key(curs_id)
    references curso(curs_id)
    on update cascade
    on delete restrict
);


create table plano(
    plan_id int auto_increment,
    constraint pk_plano
    primary key(plan_id),

    plan_tipo enum('Mensal', 'Família', 'Amigos') not null unique,
    plan_descricao text not null,
    plan_desconto decimal(5,2) not null default 0,
    plan_valor decimal(10,2) not null,
    plan_status enum('ativo', 'inativo') not null default 'ativo'
);



create table matricula(
    matr_id int auto_increment,
    constraint pk_matricula
    primary key(matr_id),

    alun_id int not null,
    turm_id int not null,
    plan_id int not null,
    matr_data date not null,
    matr_status enum('ativa', 'trancada', 'cancelada', 'concluida', 'pendente') not null default 'pendente',
    matr_desconto decimal(5,2) not null default 0,
    matr_valor_final decimal(10,2) not null,

    constraint uq_matricula_aluno_turma
    unique(alun_id, turm_id),

    constraint fk_matricula_aluno
    foreign key(alun_id)
    references aluno(alun_id)
    on update cascade
    on delete restrict,

    constraint fk_matricula_turma
    foreign key(turm_id)
    references turma(turm_id)
    on update cascade
    on delete restrict,

    constraint fk_matricula_plano
    foreign key(plan_id)
    references plano(plan_id)
    on update cascade
    on delete restrict
);


create table pagamento(
    paga_id int auto_increment,
    constraint pk_pagamento
    primary key(paga_id),

    matr_id int not null,
    paga_valor decimal(10,2) not null,
    paga_data_vencimento date not null,
    paga_data_pagamento date,
    paga_forma_pagamento enum('PIX', 'Cartão', 'Boleto', 'Dinheiro') not null,
    paga_status enum('pendente', 'aprovado', 'recusado', 'cancelado', 'reembolsado', 'expirado') not null default 'pendente',
    paga_gateway varchar(50) not null,
    paga_gateway_id varchar(100) unique,
    paga_comprovante_url varchar(255),
    paga_observacao text,

    constraint fk_pagamento_matricula
    foreign key(matr_id)
    references matricula(matr_id)
    on update cascade
    on delete restrict
);

create table atendimento(
    aten_id int auto_increment,
    constraint pk_atendimento
    primary key(aten_id),

    alun_id int not null,
    func_id int not null,
    aten_data_hora datetime not null,
    aten_tipo enum('matrícula', 'pagamento', 'informação', 'cancelamento', 'suporte') not null,
    aten_descricao text not null,
    aten_status enum('finalizado', 'pendente', 'cancelado') not null default 'finalizado',

    constraint fk_atendimento_aluno
    foreign key(alun_id)
    references aluno(alun_id)
    on update cascade
    on delete restrict,

    constraint fk_atendimento_funcionario
    foreign key(func_id)
    references funcionario(func_id)
    on update cascade
    on delete restrict
);

create table aula(
    aula_id int auto_increment,
    constraint pk_aula
    primary key(aula_id),

    turm_id int not null,
    prof_id int not null,
    aula_data date not null,
    aula_conteudo text not null,
    aula_observacao text,

    constraint fk_aula_turma
    foreign key(turm_id)
    references turma(turm_id)
    on update cascade
    on delete restrict,

    constraint fk_aula_professor
    foreign key(prof_id)
    references professor(prof_id)
    on update cascade
    on delete restrict
);

create table frequencia(
    freq_id int auto_increment,
    constraint pk_frequencia
    primary key(freq_id),

    aula_id int not null,
    matr_id int not null,
    freq_status enum('presente', 'ausente', 'justificado') not null,
    freq_observacao text,

    constraint uq_frequencia_aula_matricula
    unique(aula_id, matr_id),

    constraint fk_frequencia_aula
    foreign key(aula_id)
    references aula(aula_id)
    on update cascade
    on delete restrict,

    constraint fk_frequencia_matricula
    foreign key(matr_id)
    references matricula(matr_id)
    on update cascade
    on delete restrict
);

create table nota(
    nota_id int auto_increment,
    constraint pk_nota
    primary key(nota_id),

    matr_id int not null,
    nota_tipo enum('prova', 'atividade', 'mensal', 'bimestral', 'semestral') not null,
    nota_valor decimal(4,2) not null,
    nota_data datetime not null,
    nota_observacao text,

    constraint fk_nota_matricula
    foreign key(matr_id)
    references matricula(matr_id)
    on update cascade
    on delete restrict
);

create table relatorio(
    rela_id int auto_increment,
    constraint pk_relatorio
    primary key(rela_id),

    func_id int,
    prof_id int,
    rela_tipo enum('financeiro', 'frequência', 'acadêmico', 'matrículas', 'turmas', 'pagamentos', 'notas') not null,
    rela_inicio date not null,
    rela_fim date not null,
    rela_data_geracao datetime not null,
    rela_filtros json,

    constraint fk_relatorio_funcionario
    foreign key(func_id)
    references funcionario(func_id)
    on update cascade
    on delete restrict,

    constraint fk_relatorio_professor
    foreign key(prof_id)
    references professor(prof_id)
    on update cascade
    on delete restrict
);