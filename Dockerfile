# Etapa 1: Usar la imagen oficial de Inngest como "donante" de la aplicación
FROM inngest/inngest:latest AS builder

# Etapa 2: Construir nuestra imagen final sobre una base ligera (Alpine)
FROM alpine:latest

# Instalar las herramientas que necesitamos: un shell (viene con alpine) y curl
RUN apk update && apk add --no-cache curl

# Copiar el binario desde su ubicación correcta
COPY --from=builder /usr/bin/inngest /usr/local/bin/inngest

# En lugar de usar ENTRYPOINT y CMD, usamos solo CMD con la ruta completa
CMD ["/usr/local/bin/inngest", "start"]