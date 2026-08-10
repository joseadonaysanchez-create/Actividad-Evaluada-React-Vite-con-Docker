#ETAPA 1

# Imagen base para levantar el entorno

FROM node:22-alpine AS build

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar pnpm 

RUN corepack enable

# Copiar primero solo los archivos de dependencias 

COPY package.json pnpm-lock.yaml ./

# Instalar dependencias 

RUN pnpm install --frozen-lockfile

#Copiar el codigo del proyecto
COPY . . 

#Ejecutar el proyecto 
RUN pnpm build

# ETAPA 2 Produccion 

FROM nginx:alpine AS production

# Copiar hacia Nginx resultado del build (carpeta dist)

COPY --from=build /app/dist /usr/share/nginx/html

# Exponer el puerto 80

EXPOSE 80

# Comando por defecto (iniciar Nginx en primer plano)

CMD ["nginx", "-g", "daemon off;"]



