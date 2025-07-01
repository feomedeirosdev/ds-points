# DS Points

## **Esquema de Dados – `database.db`**

Abaixo estão listadas as tabelas do banco de dados e suas respectivas variáveis.

**Tabela: `customers`**

- **`idCustomer`** (`TEXT`): Identificador único do cliente.
- **`PointsCustomer`** (`BIGINT`): Total de pontos acumulados pelo cliente (no momento da coleta).
- **`flEmail`** (`BIGINT`): Flag indicando presença de e-mail cadastrado (0 = não, 1 = sim).

**Tabela: `transactions`**

- **`idTransaction`** (`TEXT`): Identificador único da transação realizada.
- **`idCustomer`** (`TEXT`): Chave estrangeira referenciando o cliente que realizou a transação.
- **`dtTransaction`** (`TEXT`): Data e hora da transação (string no formato ISO ou semelhante).
- **`pointsTransaction`** (`BIGINT`): Quantidade de pontos atribuídos à transação.

**Tabela: `transactions_product`**

- **`idTransactionCart`** (`TEXT`): dentificador único do item no carrinho da transação.
- **`idTransaction`** (`TEXT`): Chave estrangeira referenciando a transação associada ao item.
- **`NameProduct`** (`TEXT`): Nome do produto adquirido na transação.
- **`QuantityProduct`** (`BIGINT`): Quantidade do produto adquirida na transação.

---

# DS Points – Feature Store Documentation

Este projeto organiza e documenta as features utilizadas em modelos de dados de pontos, transações, comportamento e engajamento.

---

## Organização das Features Store

**General Feature**

- **`idCustomer`:** identificador único do item no carrinho da transação.
- **`recendiaDias`:**
- **`frequenciaDias`:**
- **`valorPoints`:**
- **`idadeBaseDias`:**
- **`tempoBaseDias`:**
- **`flEmail`:**

**Points Feature**

- **`idCustomer`:** identificador único do item no carrinho da transação.
- **`saldoPoints`:**
- **`pointsAcumuladosD7`:**
- **`pointsResgatadosD7`:**
- **`pointsAcumuladosD14`:**
- **`pointsResgatadosD14`:**
- **`pointsAcumuladosD21`:**
- **`pointsResgatadosD21`:**
- **`pointsAcumulado`:**
- **`pointsResgatados`:**
- **`saldoPoints:1`:**
- **`pointsAcumuladosVida`:**
- **`pointsResgatadosVida`:**
- **`pointsPorDia`:**

## KanBan Status

### General Features

| Feature           | Status |
| ----------------- | ------ |
| `idCustomer`      | 🟢     |
| `recendiaDias`    | 🟢     |
| `frequenciaDias:` | 🟢     |
| `valorPoints:`    | 🟢     |
| `idadeBaseDias:`  | 🟢     |
| `tempoBaseDias:`  | 🟢     |
| `flEmail:`        | 🟢     |

---

### Pontos D7, D14, D21, Vida (D28)

| Feature                | Status |
| ---------------------- | ------ |
| `idCustomer`           | 🟢     |
| `saldoPoints`          | 🟢     |
| `pointsAcumuladosD7`   | 🟢     |
| `pointsResgatadosD7`   | 🟢     |
| `pointsAcumuladosD14`  | 🟢     |
| `pointsResgatadosD14`  | 🟢     |
| `pointsAcumuladosD21`  | 🟢     |
| `pointsResgatadosD21`  | 🟢     |
| `pointsAcumulado`      | 🟢     |
| `pointsResgatados`     | 🟢     |
| `saldoPoints:1`        | 🟢     |
| `pointsAcumuladosVida` | 🟢     |
| `pointsResgatadosVida` | 🟢     |
| `pointsPorDia`         | 🟢     |

---

### Transações

| Feature                          | Descrição                                               | Status |
| -------------------------------- | ------------------------------------------------------- | ------ |
| `frequencia_dias`                | Frequência média de transações em dias                  | 🔴     |
| `quantidade_total_transacoes`    | Total de transações realizadas                          | 🔴     |
| `transacoes_por_dia_de_vida`     | Média de transações por dia ativo                       | 🔴     |
| `tempo_entre_msgs_no_dia_max`    | Tempo máximo entre 1ª e última mensagem no mesmo dia    | 🔴     |
| `tempo_entre_msgs_no_dia_min`    | Tempo mínimo entre 1ª e última mensagem no mesmo dia    | 🔴     |
| `tempo_entre_msgs_no_dia_avg`    | Tempo médio entre 1ª e última mensagem no mesmo dia     | 🔴     |
| `tempo_entre_msgs_no_dia_median` | Tempo mediano entre 1ª e última mensagem no mesmo dia   | 🔴     |
| `tempo_entre_msgs_no_dia_sum`    | Soma do tempo entre mensagens no mesmo dia              | 🔴     |
| `indice_forca_relativa`          | Índice composto para medir consistência de participação | 🔴     |

---

### Produtos

| Feature                         | Descrição                                           | Status |
| ------------------------------- | --------------------------------------------------- | ------ |
| `quantidade_pontos_por_produto` | Total de pontos associados a cada produto           | 🔴     |
| `percentual_pontos_por_produto` | Proporção dos pontos totais associados a um produto | 🔴     |
| `quantidade_chat_msg_por_live`  | Número de mensagens enviadas por live               | 🔴     |

---

### Horários da Live

| Feature                             | Descrição                                       | Status |
| ----------------------------------- | ----------------------------------------------- | ------ |
| `quantidade_transacoes_por_horario` | Número total de transações por faixa de horário | 🔴     |
| `quantidade_pontos_por_horario`     | Pontos totais por faixa de horário              | 🔴     |

---

## Convenções

- Nome de variáveis em `snake_case`
- Colunas com valores numéricos representam **contagens**, **médias**, **somatórios** ou **proporções**
- Variáveis categóricas devem ser tratadas via `OneHotEncoding` ou `TargetEncoding`, dependendo do modelo

---

## Atualização

Este `README.md` será atualizado conforme novas features forem implementadas e documentadas.  
Você pode alterar o status de cada linha conforme avança no projeto:

- 🟢 `To Do`
- 🟠 `In Progress`
- 🔴 `Done`

---

> **Dica de ouro**: Feature boa é feature que gera sinal. Feature sem sinal é só coluna no CSV.  
> Mate-as sem piedade. 🧹
