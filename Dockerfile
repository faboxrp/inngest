# Etapa 1: Usar la imagen oficial de Inngest como "donante" de la aplicación
FROM inngest/inngest AS builder

# Etapa 2: Construir nuestra imagen final sobre una base ligera (Alpine)
FROM alpine:latest

# Instalar las herramientas que necesitamos: un shell (viene con alpine) y curl
RUN apk update && apk add --no-cache curl

# Copiar ÚNICAMENTE el binario de la aplicación a una ubicación estándar
COPY --from=builder /inngest /usr/local/bin/inngest

# Apuntar el ENTRYPOINT a la nueva ubicación del binario
ENTRYPOINT ["/usr/local/bin/inngest"]
CMD ["start"]