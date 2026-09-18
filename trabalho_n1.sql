-- ==========================================================
-- Trabalho N1 - Laboratório de Banco de Dados
-- Conteúdo: criação de tabelas, população e manipulação de dados
-- ==========================================================

-- Limpeza (opcional para reexecução)
DROP TABLE IF EXISTS matriculas;
DROP TABLE IF EXISTS disciplinas;
DROP TABLE IF EXISTS alunos;
DROP TABLE IF EXISTS cursos;

-- ==========================================================
-- 1) Scripts de criação das tabelas
-- ==========================================================
CREATE TABLE cursos (
    id_curso INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_horaria_total INTEGER NOT NULL CHECK (carga_horaria_total > 0)
);

CREATE TABLE alunos (
    id_aluno INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    id_curso INTEGER NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos (id_curso)
);

CREATE TABLE disciplinas (
    id_disciplina INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INTEGER NOT NULL CHECK (carga_horaria > 0),
    id_curso INTEGER NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES cursos (id_curso)
);

CREATE TABLE matriculas (
    id_matricula INTEGER PRIMARY KEY,
    id_aluno INTEGER NOT NULL,
    id_disciplina INTEGER NOT NULL,
    nota_final DECIMAL(4,2),
    situacao VARCHAR(20) NOT NULL DEFAULT 'EM_ANDAMENTO'
        CHECK (situacao IN ('APROVADO', 'REPROVADO', 'EM_ANDAMENTO')),
    UNIQUE (id_aluno, id_disciplina),
    FOREIGN KEY (id_aluno) REFERENCES alunos (id_aluno),
    FOREIGN KEY (id_disciplina) REFERENCES disciplinas (id_disciplina)
);

-- ==========================================================
-- 2) Scripts de inserção de dados (população)
-- ==========================================================
INSERT INTO cursos (id_curso, nome, carga_horaria_total) VALUES
(1, 'Sistemas de Informação', 3000),
(2, 'Análise e Desenvolvimento de Sistemas', 2400);

INSERT INTO alunos (id_aluno, nome, email, id_curso) VALUES
(1, 'Ana Souza', 'ana.souza@universidade.edu', 1),
(2, 'Bruno Lima', 'bruno.lima@universidade.edu', 1),
(3, 'Carla Mendes', 'carla.mendes@universidade.edu', 2);

INSERT INTO disciplinas (id_disciplina, nome, carga_horaria, id_curso) VALUES
(1, 'Banco de Dados I', 80, 1),
(2, 'Engenharia de Software', 80, 1),
(3, 'Modelagem de Dados', 60, 2);

INSERT INTO matriculas (id_matricula, id_aluno, id_disciplina, nota_final, situacao) VALUES
(1, 1, 1, 8.50, 'APROVADO'),
(2, 1, 2, NULL, 'EM_ANDAMENTO'),
(3, 2, 1, 5.75, 'REPROVADO'),
(4, 3, 3, 9.10, 'APROVADO');

-- ==========================================================
-- 3) Scripts de manipulação de dados
-- ==========================================================

-- 3.1 SELECTs para consulta
-- Lista alunos com seus cursos
SELECT a.id_aluno, a.nome AS aluno, a.email, c.nome AS curso
FROM alunos a
JOIN cursos c ON c.id_curso = a.id_curso
ORDER BY a.nome;

-- Histórico de matrícula com disciplina e situação
SELECT m.id_matricula, a.nome AS aluno, d.nome AS disciplina, m.nota_final, m.situacao
FROM matriculas m
JOIN alunos a ON a.id_aluno = m.id_aluno
JOIN disciplinas d ON d.id_disciplina = m.id_disciplina
ORDER BY a.nome, d.nome;

-- Média de nota por disciplina (apenas notas preenchidas)
SELECT d.nome AS disciplina, AVG(m.nota_final) AS media_nota
FROM matriculas m
JOIN disciplinas d ON d.id_disciplina = m.id_disciplina
WHERE m.nota_final IS NOT NULL
GROUP BY d.nome
ORDER BY d.nome;

-- 3.2 UPDATEs para atualização
-- Atualiza nota e situação de uma matrícula em andamento
UPDATE matriculas
SET nota_final = 7.80,
    situacao = 'APROVADO'
WHERE id_matricula = 2;

-- Corrige carga horária de uma disciplina
UPDATE disciplinas
SET carga_horaria = 90
WHERE id_disciplina = 2;
