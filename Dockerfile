# Etapa 1: Usar la imagen oficial de Inngest como "donante" de la aplicación
FROM inngest/inngest AS builder

# Etapa 2: Construir nuestra imagen final sobre una base ligera (Alpine)
FROM alpine:latest

# Instalar las herramientas que necesitamos: un shell (viene con alpine) y curl
RUN apk update && apk add --no-cache curl

# Copiar la aplicación Inngest y sus archivos desde la imagen "donante"
COPY --from=builder / /

# Definir el comando por defecto para que el contenedor funcione igual que el original
ENTRYPOINT ["/inngest"]
CMD ["start"]