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
PORT=8080
SECRET_KEY=secret_key
```

3. Run the following command to start the development environment

```bash
docker build -t banorte .
docker run -d -p 22:22 -p 80:80 -p 9092:9092 -e ROOT_PASSWORD=awdrqwer12 --name banorte-server banorte 
```