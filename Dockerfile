FROM n8nio/n8n:1.88.0
# Diretório de trabalho
WORKDIR /home/node
# Usuário root para instalar pacotes
USER root

RUN mkdir -p /home/node/temp /home/node/scripts /home/node/input /home/node/output && \
    chmod -R 777 /home/node/temp /home/node/scripts /home/node/input /home/node/output

# instalar dependências do sistema operacional
RUN apk update && \
    apk add --no-cache \
    python3 \
    py3-pip \
    poppler-utils \
    libmagic \
    nano \
    && apk upgrade --available

# Criar ambiente virtual Python
RUN python3 -m venv /home/node/venv

# Variáveis de ambiente para o Python
ENV PATH="/home/node/venv/bin:$PATH"

# Instalar bibliotecas Python no ambiente virtual
RUN pip install --upgrade pip && \
    pip install pypdf  #PyPDF2  Ou use PyPDF2 se preferir
RUN pip install PyPDF2
RUN pip install --no-cache-dir pdf2image pillow

# Instalar bibliotecas Node.js globais necessárias para código customizado
RUN npm install --global --production pdf-lib axios-ntlm
# Permitir acesso ao ambiente para o usuário do n8n
#RUN chown -R node:node /opt/venv /app
# Copia scripts Python para o diretório correto
COPY extrair_por_cva.py /home/node/scripts
COPY dividir_arquivo.py /home/node/scripts
COPY split_files.py /home/node/scripts
# Muda pro usuário node (por segurança)
USER node

# Configurar NODE_PATH para encontrar globais
ENV NODE_PATH=/home/node/.n8n/nodes:/usr/local/lib/node_modules:/home/node/node_modules

# Comando padrão já definido pelo n8n base image (entrypoint)
