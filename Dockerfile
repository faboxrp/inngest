# Etapa 1: Usar la imagen oficial de Inngest como "donante" de la aplicación
FROM inngest/inngest:latest AS builder

# Etapa 2: Construir nuestra imagen final sobre una base ligera (Alpine)
FROM alpine:latest

# Instalar las herramientas que necesitamos: un shell (viene con alpine) y curl
RUN apk update && apk add --no-cache curl

# Copiar el binario desde su ubicación correcta, que está en el PATH de la imagen original
COPY --from=builder /usr/local/bin/inngest /usr/local/bin/inngest

# Definir el comando por defecto para que el contenedor funcione igual que el original
ENTRYPOINT ["/usr/local/bin/inngest"]
CMD ["start"]