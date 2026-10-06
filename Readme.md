# Check Point 2 — Microservices and Web Engineering

API REST desenvolvida em **Java + Spring Boot** com persistência em **SQL Server**, conforme o requisito do Check Point 2 do 2º semestre de 2026.

## Objetivo

O projeto disponibiliza uma API REST funcional para realizar operações de consulta, inserção, alteração e exclusão de dados persistidos em um banco **SQL Server**.

A implementação utiliza:

- Java 17;
- Spring Boot 4.0.3;
- Spring MVC;
- Spring Data JPA / Hibernate;
- Microsoft SQL Server;
- Maven;
- Swagger / OpenAPI;
- Docker;
- Lombok;
- ModelMapper;
- Bean Validation.

> **Importante:** este projeto não utiliza o projeto `study-apir`.

## Arquitetura

A aplicação está organizada em camadas:

```text
Cliente HTTP
    ↓
Controller
    ↓
DTO / Mapper
    ↓
Service
    ↓
Repository
    ↓
Entity JPA
    ↓
SQL Server
```

- **Controller:** recebe as requisições HTTP e retorna as respostas da API.
- **DTO:** define os dados de entrada e saída.
- **Mapper:** converte DTOs e entidades.
- **Service:** concentra as operações da aplicação.
- **Repository:** utiliza Spring Data JPA para acessar o banco.
- **Entity:** representa as tabelas persistidas no SQL Server.

## Domínios da API

### Finanças

A entidade `Financa` representa registros de títulos financeiros.

Tabela utilizada:

```text
financas
```

Campos:

| Campo | Tipo |
|---|---|
| id | Long |
| taxa | double |
| emissor | String |
| risco | String |
| vencimento | String |
| quantidade | int |

### Copa do Mundo

A entidade `Futebol` representa edições da Copa do Mundo.

Tabela utilizada:

```text
futebois
```

Campos:

| Campo | Tipo |
|---|---|
| id | Long |
| ano | int |
| capeao | String |
| sede | String |
| vice | String |
| melhorJogador | String |

O campo `capeao` é mantido dessa forma para preservar o contrato da API já existente.

## Configuração do SQL Server

A aplicação utiliza o driver oficial JDBC do SQL Server:

```xml
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <scope>runtime</scope>
</dependency>
```

A conexão é configurada por variáveis de ambiente.

### Variáveis

| Variável | Descrição | Exemplo |
|---|---|---|
| `DB_SERVER_URL` | Servidor/IP do SQL Server | `localhost` |
| `DB_SERVER_PORT` | Porta do SQL Server | `1433` |
| `DB_SCHEMA` | Nome do banco | `cp04_microservice` |
| `DB_USER` | Usuário | `sa` |
| `DB_PWD` | Senha | definida localmente |
| `DB_ENCRYPT` | Criptografia JDBC | `false` |
| `DB_TRUST_SERVER_CERTIFICATE` | Confia no certificado do servidor | `true` |

**Não coloque a senha real do SQL Server no GitHub.**

### Configuração local

O arquivo `application.properties` usa:

```properties
spring.datasource.url=jdbc:sqlserver://${DB_SERVER_URL:localhost}:${DB_SERVER_PORT:1433};databaseName=${DB_SCHEMA:cp04_microservice};encrypt=${DB_ENCRYPT:false};trustServerCertificate=${DB_TRUST_SERVER_CERTIFICATE:true}
spring.datasource.username=${DB_USER:sa}
spring.datasource.password=${DB_PWD:}
```

Para a avaliação, substitua as variáveis pelos dados do **SQL Server disponibilizado pelo professor**.

O profile local utiliza:

```properties
spring.jpa.hibernate.ddl-auto=update
```

Assim, o Hibernate pode criar/atualizar as tabelas correspondentes às entidades quando a aplicação é executada pela primeira vez.

## Profile de produção

O arquivo `application-prd.properties` exige as informações do banco por variáveis de ambiente e utiliza:

```properties
spring.jpa.hibernate.ddl-auto=none
```

Nesse modo, o banco e as tabelas precisam existir previamente.

Para executar:

```bash
DB_SERVER_URL=SEU_SERVIDOR \
DB_SERVER_PORT=1433 \
DB_SCHEMA=SEU_BANCO \
DB_USER=SEU_USUARIO \
DB_PWD=SUA_SENHA \
SPRING_PROFILES_ACTIVE=prd \
mvn spring-boot:run
```

## Execução rápida com Docker + SQL Server

O repositório já possui um `docker-compose.yml` para subir o SQL Server com os mesmos dados do comando fornecido para o Check Point:

```bash
docker compose up -d sqlserver
```

Isso cria o container `sqlserver`, publica a porta `1433` e utiliza:

- usuário: `sa`
- senha: `1q2w3e4R@`
- porta: `1433`

### Criar o banco e as tabelas

Depois que o SQL Server estiver iniciado, execute o conteúdo de:

```text
database/create-database.sql
```

Esse script cria o banco `cp04_microservice` e as tabelas `financas` e `futebois`, caso ainda não existam.

Você pode executar o script pelo SQL Server Management Studio (SSMS), Azure Data Studio ou outra ferramenta conectada ao SQL Server local.

Conexão:

```text
Servidor: localhost,1433
Usuário: sa
Senha: 1q2w3e4R@
Banco: cp04_microservice
```

### Iniciar a API

Com o banco criado:

```bash
mvn clean spring-boot:run
```

A configuração local já possui os valores padrão para esse SQL Server Docker. Também é possível sobrescrevê-los por variáveis de ambiente.

API:

```text
http://localhost:8080
```

Swagger:

```text
http://localhost:8080/
```

### Fluxo recomendado para a demonstração

1. Subir o SQL Server com `docker compose up -d sqlserver`.
2. Criar o banco usando `database/create-database.sql`.
3. Iniciar a API com `mvn clean spring-boot:run`.
4. Abrir o Swagger em `http://localhost:8080/`.
5. Fazer POST em `/financas` ou `/copa`.
6. Fazer GET para comprovar a persistência.
7. Fazer PUT para comprovar alteração.
8. Fazer DELETE para comprovar exclusão.
9. Fazer um GET novamente para comprovar a remoção.

> **Segurança:** a senha acima é a senha do ambiente SQL Server local usado no exercício. Não reutilize essa senha em um servidor real ou ambiente de produção.

## Pré-requisitos

Para executar localmente:

- Java 17 ou superior;
- Maven;
- SQL Server;
- banco disponibilizado pelo professor ou SQL Server local;
- acesso à porta do SQL Server.

## Execução local

Configure as variáveis de ambiente e execute:

```bash
mvn spring-boot:run
```

No Windows PowerShell:

```powershell
$env:DB_SERVER_URL="localhost"
$env:DB_SERVER_PORT="1433"
$env:DB_SCHEMA="cp04_microservice"
$env:DB_USER="sa"
$env:DB_PWD="SUA_SENHA"
$env:DB_ENCRYPT="false"
$env:DB_TRUST_SERVER_CERTIFICATE="true"

mvn spring-boot:run
```

Quando a aplicação iniciar, a API ficará disponível em:

```text
http://localhost:8080
```

## Swagger / OpenAPI

Com a aplicação em execução:

- Swagger UI: `http://localhost:8080/`
- OpenAPI JSON: `http://localhost:8080/v3/api-docs`

O Swagger pode ser utilizado para demonstrar os endpoints durante a avaliação.

## Endpoints

### Finanças — `/financas`

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/financas` | Insere uma finança |
| GET | `/financas` | Consulta todas |
| GET | `/financas/{id}` | Consulta por ID |
| PUT | `/financas/{id}` | Altera uma finança |
| DELETE | `/financas/{id}` | Exclui uma finança |

Exemplo de POST:

```json
{
  "emissor": "Tesouro Nacional",
  "taxa": 12.5,
  "risco": "baixo",
  "vencimento": "2030-01-01",
  "quantidade": 10
}
```

Resposta esperada: `201 Created`.

### Copa do Mundo — `/copa`

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/copa` | Insere uma edição |
| GET | `/copa` | Consulta todas |
| GET | `/copa/{id}` | Consulta por ID |
| PUT | `/copa/{id}` | Altera uma edição |
| DELETE | `/copa/{id}` | Exclui uma edição |

Exemplo de POST:

```json
{
  "ano": 2022,
  "capeao": "Argentina",
  "vice": "França",
  "sede": "Catar",
  "melhorJogador": "Lionel Messi"
}
```

Resposta esperada: `201 Created`.

## Testando o CRUD

### 1. Inserir

```http
POST /financas
Content-Type: application/json
```

Body:

```json
{
  "emissor": "Tesouro Nacional",
  "taxa": 12.5,
  "risco": "baixo",
  "vencimento": "2030-01-01",
  "quantidade": 10
}
```

### 2. Consultar

```http
GET /financas
```

### 3. Consultar por ID

```http
GET /financas/1
```

### 4. Alterar

```http
PUT /financas/1
Content-Type: application/json
```

Body:

```json
{
  "emissor": "Tesouro Nacional",
  "taxa": 13.0,
  "risco": "baixo",
  "vencimento": "2030-01-01",
  "quantidade": 15
}
```

### 5. Excluir

```http
DELETE /financas/1
```

O mesmo fluxo pode ser demonstrado utilizando o recurso `/copa`.

## Docker

O projeto possui um Dockerfile para gerar a aplicação.

Build:

```bash
docker build -t cp04-microservice .
```

Execução:

```bash
docker run --rm -p 8080:8080 \
  -e DB_SERVER_URL=host.docker.internal \
  -e DB_SERVER_PORT=1433 \
  -e DB_SCHEMA=cp04_microservice \
  -e DB_USER=sa \
  -e DB_PWD=SUA_SENHA \
  -e DB_ENCRYPT=false \
  -e DB_TRUST_SERVER_CERTIFICATE=true \
  cp04-microservice
```

Quando a API estiver em container e o SQL Server estiver na máquina host, `host.docker.internal` pode ser utilizado no Docker Desktop.

## Estrutura do projeto

```text
src/
├── main/
│   ├── java/br/com/fiap/cp01_api01/
│   │   ├── controller/
│   │   │   ├── FinancasController.java
│   │   │   └── FutebolController.java
│   │   ├── dto/
│   │   ├── model/
│   │   │   ├── Financa.java
│   │   │   └── Futebol.java
│   │   ├── repository/
│   │   │   ├── FinancaRepository.java
│   │   │   └── FutebolRepository.java
│   │   ├── service/
│   │   └── Application.java
│   └── resources/
│       ├── application.properties
│       └── application-prd.properties
└── test/
```

## Checklist do Check Point 2

- [x] Java com Spring Boot
- [x] API REST
- [x] Endpoints funcionando
- [x] Configuração de conexão com SQL Server
- [x] Driver JDBC do SQL Server
- [x] Spring Data JPA
- [x] Entidades JPA
- [x] Consulta de dados
- [x] Inserção de dados
- [x] Alteração de dados
- [x] Exclusão de dados
- [x] Organização em camadas
- [x] README com execução, banco e endpoints
- [x] Ambiente SQL Server local via Docker Compose
- [x] Script SQL para criação do banco e tabelas
- [x] Configuração local da conexão SQL Server
- [ ] Validar a conexão com o SQL Server disponibilizado pelo professor, caso seja diferente do ambiente local
- [ ] Demonstrar CRUD durante a avaliação

## Repositório

https://github.com/Enzo-Grisolia/cp04_microservice
