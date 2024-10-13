#!/bin/bash
# Script para instalar las dependencias de Python en Linux/macOS

echo "Actualizando pip"
pip install --upgrade pip

echo "Instalando dependencias de Python"
pip install ollama weaviate-client vertexai fastapi uvicorn google-cloud PyPDf2 python-docx python-pptx pytesseract opencv-python numpy

echo "Dependencias instaladas correctamente"
