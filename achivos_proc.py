import PyPDF2
from docx import Document
from pptx import Presentation
import re
import pytesseract
import cv2
import io
import numpy as np
from fastapi import FastAPI, File, UploadFile
import uvicorn

app = FastAPI()

def archivo_procesado(archivo_binario: bytes) -> str:
    def identificar_tipo_archivo(archivo_binario):
        if archivo_binario.startswith(b'%PDF'):
            return 'pdf'
        elif archivo_binario.startswith(b'PK'):
            if b'word/' in archivo_binario:
                return 'docx'
            elif b'ppt/' in archivo_binario:
                return 'pptx'
        elif archivo_binario.startswith((b'\xff\xd8', b'\x89PNG')):
            return 'image'
        else:
            return 'txt'

    pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

    tipo_archivo = identificar_tipo_archivo(archivo_binario)
    print(tipo_archivo)

    regex = re.compile(r'\t|\n|\r|  ')
    texto = []

    if tipo_archivo == 'txt':
        texto = archivo_binario.decode('utf-8').splitlines()
    elif tipo_archivo == 'pdf':
        lector_pdf = PyPDF2.PdfReader(io.BytesIO(archivo_binario))
        num_paginas = len(lector_pdf.pages)
        for i in range(num_paginas):
            pagina = lector_pdf.pages[i]
            texto.extend(pagina.extract_text().split('\n'))
    elif tipo_archivo == 'docx':
        documento = Document(io.BytesIO(archivo_binario))
        for parrafo in documento.paragraphs:
            texto.append(parrafo.text)
    elif tipo_archivo == 'pptx':
        presentacion = Presentation(io.BytesIO(archivo_binario))
        for diapositiva in presentacion.slides:
            for forma in diapositiva.shapes:
                if hasattr(forma, "text"):
                    texto.append(forma.text)
    elif tipo_archivo == 'image':
        img = cv2.imdecode(np.frombuffer(archivo_binario, np.uint8), cv2.IMREAD_COLOR)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        _, binary = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY_INV)
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (1, 1))
        dilated = cv2.dilate(binary, kernel, iterations=1)
        eroded = cv2.erode(dilated, kernel, iterations=1)
        texto = pytesseract.image_to_string(eroded, lang='spa')

    texto_filtrado = []
    if tipo_archivo != 'image':
        for linea in texto:
            nueva_linea = ''.join(char if not regex.match(char) else ' ' for char in linea)
            prev_char = ''
            nueva_linea2 = ''
            for char in nueva_linea:
                if char == ' ' and prev_char == ' ':
                    continue
                else:
                    nueva_linea2 += char
                prev_char = char
            texto_filtrado.append(nueva_linea2)
        texto_final = ''
        for linea in texto_filtrado:
            texto_final += linea + '' if linea.endswith(' ') else linea + ' '
    else:
        texto_final = ""
        for char in texto:
            if not regex.match(char):
                texto_final += char

    print(texto_final)
    return texto_final

if __name__ == '__main__':
    #archivo_procesado('a.jpg')
    #archivo_procesado('ejemplo.txt')
    #archivo_procesado('prueba.pdf')
    #archivo_procesado('prueba.docx')
    archivo_procesado('ejemplo.pptx')