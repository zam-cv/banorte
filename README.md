# Banorte

## Desarrollo

### Prerequisitos

- [Docker](https://docs.docker.com/engine/install/)
- [Git](https://git-scm.com/downloads)
- [VSCode](https://code.visualstudio.com/download)
- [Python](https://www.python.org/downloads/)
- [FastApi](https://fastapi.tiangolo.com/#installation)
- [Ollama](https://ollama.com/)
- [Golang](https://golang.org/doc/install)
- [Nodejs](https://nodejs.org/en/download/package-manager)
- [Dart](https://dart.dev/get-dart)
- [Flutter](https://docs.flutter.dev/get-started/install)
- [Vertex](https://cloud.google.com/vertex-ai?hl=es-419)

### Desarrollo

1. Clona el repositorio

```bash
git clone https://github.com/zam-cv/banorte
```

2. Entra a la carpeta de la aplicacion

```bash
cd app\
```

3. Instala dependencias de Flutter

```bash
flutter pub get
```

4. Corre la aplicacion

```bash
flutter run
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