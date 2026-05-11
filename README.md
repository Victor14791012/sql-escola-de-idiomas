# sql-escola-de-idiomas
Documento desenvolvido anteriormete que foi usado para criar a estrutura SQL.
https://docs.google.com/document/d/16E1imBgh17QSSE-fFs_obWcQRGM_6oBb/edit


# Resumo das Cardinalidades — Diagrama Lógico

## 1. Curso → Turma
### Relacionamento:
Um curso pode possuir várias turmas, mas uma turma pertence a apenas um curso.

### Cardinalidade:
```text
Curso (1) ──────── (N) Turma
```

---

# 2. Professor → Turma
### Relacionamento:
Um professor pode lecionar várias turmas, mas cada turma possui apenas um professor responsável.

### Cardinalidade:
```text
Professor (1) ──────── (N) Turma
```

---

# 3. Aluno → Matrícula
### Relacionamento:
Um aluno pode possuir várias matrículas ao longo do tempo.

### Cardinalidade:
```text
Aluno (1) ──────── (N) Matrícula
```

---

# 4. Turma → Matrícula
### Relacionamento:
Uma turma pode possuir vários alunos matriculados.

### Cardinalidade:
```text
Turma (1) ──────── (N) Matrícula
```

---

# 5. Plano → Matrícula
### Relacionamento:
Um plano pode ser utilizado em várias matrículas.

### Cardinalidade:
```text
Plano (1) ──────── (N) Matrícula
```

---

# 6. Matrícula → Pagamento
### Relacionamento:
Uma matrícula pode possuir vários pagamentos/mensalidades.

### Cardinalidade:
```text
Matrícula (1) ──────── (N) Pagamento
```

---

# 7. Aluno → Atendimento
### Relacionamento:
Um aluno pode receber vários atendimentos.

### Cardinalidade:
```text
Aluno (1) ──────── (N) Atendimento
```

---

# 8. Funcionário → Atendimento
### Relacionamento:
Um funcionário pode realizar vários atendimentos.

### Cardinalidade:
```text
Funcionário (1) ──────── (N) Atendimento
```

---

# 9. Turma → Aula
### Relacionamento:
Uma turma possui várias aulas registradas.

### Cardinalidade:
```text
Turma (1) ──────── (N) Aula
```

---

# 10. Aula → Frequência
### Relacionamento:
Uma aula possui vários registros de frequência.

### Cardinalidade:
```text
Aula (1) ──────── (N) Frequência
```

---

# 11. Matrícula → Frequência
### Relacionamento:
Uma matrícula pode possuir várias frequências ao longo das aulas.

### Cardinalidade:
```text
Matrícula (1) ──────── (N) Frequência
```

---

# Relacionamento N:N Resolvido

Existe um relacionamento muitos-para-muitos entre:
- Aluno
- Turma

Porque:
- um aluno pode estar em várias turmas;
- uma turma possui vários alunos.

Esse relacionamento foi corretamente resolvido pela tabela:

```text
Matrícula
```

Então no DER:
- NÃO desenha N:N diretamente;
- usa a entidade associativa Matrícula.

---

# Estrutura Geral do DER

```text
Curso ───< Turma >─── Professor

Aluno ───< Matrícula >─── Turma
                 |
                 v
               Plano

Matrícula ───< Pagamento

Aluno ───< Atendimento >─── Funcionário

Turma ───< Aula ───< Frequência >─── Matrícula
```

---

# Observações Finais

- Todas as cardinalidades estão coerentes com o minimundo do projeto.
- O banco contempla controle acadêmico, financeiro e operacional da escola.
- A estrutura permite expansão futura sem necessidade de grandes alterações.

