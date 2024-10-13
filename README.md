# Banorte

## Development

### Prerequisites

- [Docker](https://docs.docker.com/engine/install/)
- [Git](https://git-scm.com/downloads)
- [VSCode](https://code.visualstudio.com/download)
- [Python](https://www.python.org/downloads/)
- [Ollama](https://ollama.com/)
- [Golang](https://golang.org/doc/install)

### Development

1. Clone the repository

```bash
git clone https://github.com/zam-cv/banorte
```

2. Create a `.env` file in the `api_gateway` directory with the following content

```bash
PORT=3000
SECRET_KEY=secret_key
LLM_HOST=127.0.0.1
LLM_PORT=8000
```

3. Run the following command to start the development environment

```bash
docker run -d --name=redpanda \
  -p 9092:9092 \
  -p 9644:9644 \
  docker.redpanda.com/vectorized/redpanda:latest \
  redpanda start
```