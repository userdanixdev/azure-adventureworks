# Migration Azure Database - AdventureWorksDW2022

Esta branch apresenta os estudos relacionados à possibilidade de migrar o banco de dados **AdventureWorksDW2022**, atualmente restaurado em uma **Azure SQL Managed Instance**, para um serviço de banco de dados que permita acesso independente da Managed Instance.

O objetivo não é simplesmente mover os arquivos físicos do SQL Server, mas compreender como funciona a migração de um banco SQL Server para serviços gerenciados da Azure, especialmente o **Azure SQL Database**.

## Contexto passado:

O projeto possui um backup do AdventureWorksDW2022 armazenado no **Azure Blob Storage**.

A arquitetura atual é:

```text
AdventureWorksDW2022.bak
          │
          ▼
Azure Blob Storage
          │
          │ RESTORE
          ▼
Azure SQL Managed Instance
          │
          ▼
AdventureWorksDW2022
```

A Managed Instance funciona como o ambiente SQL Server responsável por restaurar e executar o banco.

Quando a instância está ativa, o banco pode ser acessado normalmente através de Python, Power BI, DBeaver e outras ferramentas compatíveis.

Quando a instância está desativada, o banco continua associado à infraestrutura, mas não fica disponível para conexões.

## Por que não basta mover o arquivo do banco?

Um banco SQL Server possui arquivos físicos, como:

```text
AdventureWorksDW2022.mdf
AdventureWorksDW2022.ndf
AdventureWorksDW2022.ldf
```

Esses arquivos fazem parte da implementação física do SQL Server.

Entretanto, o **Azure SQL Database** funciona como um serviço PaaS gerenciado.

Nesse modelo, o usuário não possui acesso direto ao sistema operacional e ao armazenamento físico da infraestrutura para simplesmente copiar um `.mdf`, `.ndf` ou `.ldf` para dentro do serviço.

Portanto:

```text
SQL Server
    │
    ├── MDF
    ├── NDF
    └── LDF
    │
    X
    │
    └── Não podem simplesmente ser copiados
        para o Azure SQL Database
```

O AdventureWorksDW2022 é um banco desenvolvido para o ecossistema SQL Server.

Por isso, uma migração para outro serviço SQL da Azure pode aproveitar diversos componentes e conceitos existentes no SQL Server, como:

* T-SQL;
* tabelas;
* views;
* índices;
* constraints;
* relacionamentos;
* funções;
* procedures;
* estruturas de dados;
* modelos dimensionais.

Entretanto, **SQL Server, Azure SQL Managed Instance e Azure SQL Database não são produtos idênticos**.

Existem diferenças de arquitetura, recursos, permissões e funcionalidades disponíveis.

Por esse motivo, antes de migrar um banco SQL Server para Azure SQL Database, é necessário verificar a compatibilidade do workload.

> Por isso, o Blob Storage funciona como armazenamento do backup, e não como substituto direto de um servidor SQL.

## Por que considerar a migração?

A decisão de migrar geralmente envolve sair de um cenário de alto custo, engessamento ou manutenção pesada para um ambiente moderno e eficiente. Aqui estão os principais motivos para considerar a migração:

### 1. Redução Drástica de Custos:
- Fim da manutenção de hardware: Em ambientes locais (on-premises), você gasta com servidores físicos, energia, refrigeração, licenças caras de sistema operacional e equipe para cuidar do hardware. Na nuvem, tudo isso desaparece.

- Modelos flexíveis de pagamento: No Azure SQL Database, você paga apenas pelo que usa. Se o seu banco fica ocioso à noite ou nos fins de semana, você pode usar opções como o modelo Serverless, que pausa a computação automaticamente e reduz drasticamente a fatura.

- O Azure SQL Database possui opções de entrada mais econômicas, além de modelos de cobrança como o Serverless (onde o banco "dorme" ou reduz o custo ao mínimo quando não está sendo usado).

- O Managed Instance exige uma estrutura de instância dedicada (vCores fixos e infraestrutura de rede mais complexas), o que torna o custo mensal base consideravelmente mais alto, ideal apenas para grandes empresas que precisam migrar sistemas legados complexos sem alterar códigos.

### 2. Escalabilidade Instantânea
- Em um servidor físico ou instância rígida, se o seu volume de dados crescer ou se o Power BI exigir muito processamento, você precisará comprar um servidor novo (o que leva semanas e é caro).

- Na nuvem, você muda a capacidade (vCores ou armazenamento) com um clique ou via script, dimensionando os recursos para cima ou para baixo conforme a demanda do seu negócio em tempo real.

### 3. Eliminação da Manutenção de Infraestrutura (PaaS)
Com o Banco de Dados como Serviço (PaaS), você não precisa se preocupar com:
- Instalação de atualizações de segurança do sistema operacional.
- Patches de correção do SQL Server.
- Configuração manual de instâncias de alta disponibilidade e espelhamento.

A própria Microsoft gerencia a infraestrutura básica, garantindo atualizações automáticas e alta disponibilidade nativa, permitindo que a sua equipe foque apenas nos dados e nas regras de negócio.

### 4. Segurança e Conformidade Avançadas:

O Azure oferece camadas de segurança de nível corporativo prontas para uso, como criptografia de dados em repouso e em trânsito por padrão, mascaramento de dados confidenciais, detecção de ameaças orientada por inteligência artificial e conformidade com normas globais (LGPD, ISO, SOC, etc.). Implementar isso do zero em um ambiente local exige um esforço técnico e financeiro gigantesco.

### 5. Facilidade de Integração com o ecossistema de Dados e IA:

Migrar para o Azure coloca o seu banco de dados no centro de um ecossistema moderno. Fica extremamente simples conectar seus dados a ferramentas de nuvem como Azure Data Factory, Power BI Service, Azure Synapse, ferramentas de Inteligência Artificial e Machine Learning, criando um fluxo de dados rápido e sem fricções de rede.

### 6. Escalabilidade Elástica para Picos de Carga do Power BI:

Quando o Power BI atualiza um conjunto de dados pesado (DirectQuery ou importações massivas), ele dispara muitas consultas simultâneas que consomem bastante CPU e memória do banco.

O Azure SQL Database permite usar Elastic Pools (Pools Elásticos) ou redimensionar recursos computacionais de forma instantânea (subir ou descer vCores com poucos cliques ou via código) para absorver essa carga sem pagar o preço de uma instância dedicada o tempo todo.

## Análise de custos (estimativa):

Considerando uma simulação de 3 dias (72 horas) de processamento ou uso contínuo, vamos usar a base de cálculo real de preços públicos do Azure (região East US, Camada General Purpose, modelo de vCore provisionado sem descontos de licença prévia).

### Cenário de Comparação:

- Recurso: 4 vCores e armazenamento padrão de 250 GB.
- Período da Simulação: 3 Dias (72 horas contínuas).

### Opção 1: Azure SQL Database (vCore - General Purpose)

O Azure SQL Database cobra separadamente a computação por hora e o armazenamento por mês (proporcionalizado por dia).

- Custo de Computação (4 vCores):
Taxa por hora aprox.: ~$1.01 USD por hora.

- Para 72 horas: $1.01 x 72 = **$72.72 USD**
- Custo de Armazenamento (250 GB por 3 dias): Taxa mensal aprox. do armazenamento LRS: ~$0.115 por GB/mês.

- Custo total de armazenamento no mês:**$250 X 0.115 = $28.75**. Proporcional a 3 dias ($3/30$ avos): **$2.88 USD**
- Total Estimado para 3 dias (Azure SQL Database): **75.60 USD**

### Opção 2: Azure SQL Managed Instance 

A Instância Gerenciada possui um custo base de infraestrutura e licenciamento mais elevado porque entrega uma instância isolada com rede virtual dedicada, cobrando um mínimo de armazenamento base incluído. 

- Custo de Computação e Instância (4 vCores):
O custo horário para uma Managed Instance de 4 vCores gira em torno de ~$1.47 USD por hora (incluindo licença base e infraestrutura de rede gerenciada).

- Para 72 horas: $1.47 X 72 = **$105.84 USD** 
*(Nota: dependendo da série de hardware e região, instâncias menores de MI podem cobrar taxas fixas mensais rateadas).*

- Custo de Armazenamento (32 GB a 250 GB inclusos na base):Proporcional a 3 dias de infraestrutura de dados alocada: aprox. **15.00  USD**

- Total Estimado para 3 dias (Managed Instance): **120.84 USD** (podendo ser consideravelmente maior dependendo da complexidade da VNet e dos custos ocultos de backup de instância).


| Componente de Análise | Azure SQL Database | Azure SQL Managed Instance |
| :--- | :--- | :--- |
| **Custo de Computação (72h)** | ~$72.72 | ~$105.84 |
| **Custo de Armazenamento (Proporcional)** | ~$2.88 | ~$15.00 |
| **Custo Total do Projeto (3 Dias)** | **~$75.60 USD** | **~$120.84 USD** |
| **Diferença Percentual** | Referência base (Mais econômico) | **~60% mais caro** para o mesmo período |

A branch `migration-azure-database` existe para estudar justamente essa possibilidade. O objetivo não é substituir imediatamente a arquitetura, mas avaliar:

1. Compatibilidade do AdventureWorksDW2022 com Azure SQL Database.
2. Estratégias de migração.
3. Transferência de schema e dados.
4. Ferramentas disponíveis na Azure.
5. Possíveis limitações.
6. Impacto sobre Power BI.
7. Impacto sobre as conexões Python.
8. Custo da nova arquitetura.
9. Benefícios de manter o banco disponível independentemente da Managed Instance.

## Conclusão

O Azure SQL Database é um serviço PaaS que abstrai a infraestrutura física do SQL Server. Por isso, a transferência para esse serviço exige uma estratégia de migração compatível com sua arquitetura.

O arquivo `.bak` continua sendo extremamente útil como backup e pode permanecer no Azure Blob Storage independentemente da execução da Managed Instance.

A SQL Managed Instance permanece como o ambiente atual para restauração e execução do AdventureWorksDW2022.

A migração para Azure SQL Database representa uma possível evolução arquitetural para um cenário em que seja desejável utilizar o banco fora da Managed Instance atual.

*A decisão final deve considerar principalmente **compatibilidade, disponibilidade, complexidade operacional e custo**.*

## 🗂️ Estrutura do Projeto

O repositório está organizado em módulos que separam as etapas de restauração de backup, auditoria estrutural (inventário), planejamento e implantação do schema no Azure:

```text
project_adventureworksDW2022/
│
├── .vscode/                 # Configurações do editor
├── inventory/               # Dados estruturais extraídos da origem
│   └── adventureworks_inventory.json  # Snapshot completo do schema original
│
├── migration/               # Scripts de engenharia e deploy para o Azure SQL
│   ├── 01_create_schema_and_tables.sql  # DDL limpo gerado para o Azure
│   ├── deploy_schema.py     # Script de conexão e execução automatizada via ODBC
│   ├── migration_plan.json  # Plano estruturado e mapeado de tipos de dados
│   ├── migration_plan.py    # Conversor/Planejador de migração inteligente
│   └── migration_schema.py  # Gerador de código DDL em Raw SQL (sem ORM)
│   └── load_data.py         # Extrair os dados de origem
│
├── restore_database/        # Módulo de manipulação e auditoria na Managed Instance
│   ├── 1.restore_bak.py     # Automação de restore do .bak via Blob Storage
│   ├── 2.queries.py         # Consultas de validação inicial
│   ├── 3.inventory.py       # Extração de metadados, PKs, FKs e contagem de linhas
│   ├── a.restore_status.py  # Monitoramento do status do banco
│   └── connection.py        # Configuração centralizada de conexão com a MI
│
├── .env                     # Variáveis de ambiente e credenciais (excluído do Git)
├── .gitignore               # Arquivos ignorados pelo controle de versão
├── environment.yml          # Dependências e ambiente conda do projeto
└── README.md                # Documentação oficial da arquitetura e projeto
```

# migration/

Esta pasta contém os scripts e recursos responsáveis pelo processo de migração e modernização do banco de dados **AdventureWorksDW2022**.

O processo foi desenvolvido de forma modular, utilizando **Python e T-SQL**, permitindo analisar a estrutura do banco de origem, gerar um inventário dos objetos, planejar a migração, adaptar o schema para o ambiente de destino e realizar o carregamento dos dados.

O fluxo da migração segue as seguintes etapas:

![](/images/fluxo_migration.png)


[Clique aqui para ver os códigos plano de migração](https://github.com/userdanixdev/azure-adventureworks/tree/migration-azure-database/migration)

*Os scripts desta pasta fazem parte da evolução do projeto, permitindo compreender e controlar cada etapa da migração entre os serviços Azure.*

## Fluxo de Migração:

![](/images/fluxo_project_adventure%20(1).png)
---

*A evolução arquitetural documentada nesta branch demonstra que a transição de um ambiente pesado de SQL Managed Instance para um serviço enxuto e escalável como o Azure SQL Database traz ganhos expressivos em termos de agilidade de desenvolvimento, automação via código Python e otimização financeira significativa (especialmente através do modelo Serverless e do controle de infraestrutura ociosa).*

*Com a infraestrutura de banco de dados modelada, deployada e validada com sucesso, o projeto encerra sua fase de infraestrutura de dados e está pronto para avançar para a camada analítica e de visualização utilizando o Power BI.*

↩️ [Voltar para o plano de Restauração - SQL Server - Azure](https://github.com/userdanixdev/azure-adventureworks)

➡️ [Seguir para Documentação e Visualização BI](https://github.com/userdanixdev/azure-adventureworks/tree/data-visualization)

