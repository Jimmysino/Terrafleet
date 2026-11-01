# TerraFleet

Plataforma web para alquilar maquinaria pesada. En este repositorio está la infraestructura de cómputo en AWS, escrita con Terraform y desplegada con GitHub Actions.

Laboratorio 09 de Infraestructura como Código, UPAO (NRC 12712). Docente: Walter Iván Leturia Rodríguez.

INTEGRANTES:
- Aliaga Vasquez, Cristian Leonardo
- Banda Orbegoso, André Alejandro
- Chavez Romero, Diego Carlo Jaren
- Lavado Mejia, Alvaro Elias
- Melendez Tapia, Jimmy Leito

## Problemática

Quien necesita una máquina pesada tiene que comparar equipos, saber dónde están, cuánto cuestan y en qué fechas están libres. Hoy esa información está repartida entre varias empresas y hay que consultarla una por una, así que coordinar una sola reserva toma mucho más tiempo del necesario. A las empresas dueñas de los equipos les pasa algo parecido: no tienen un lugar común donde publicar su flota y recibir solicitudes.

## ¿Para qué sirve TerraFleet?

TerraFleet junta todo en una sola aplicación:

- Las empresas publican sus equipos con fotos, tarifa y ubicación.
- Los clientes buscan por ciudad, categoría, marca o tarifa, revisan las fechas libres y piden la reserva desde el computador o el celular.
- El pago se hace con una pasarela externa, el estado de la reserva se actualiza y se avisa por correo a ambas partes.
- Cada equipo puede enviar su posición con un dispositivo GPS, para que el propietario y el cliente vean dónde está y por dónde se ha movido.

  <img width="2008" height="1544" alt="Diagrama Terrafleet" src="https://github.com/user-attachments/assets/e3182235-a26d-4f03-8c62-33b3da617ba6" />


## Qué desplegamos 

| Recurso | Para qué lo usamos |
|---|---|
| 5 Lambdas (`lab09-buscar-equipos`, `lab09-ver-disponibilidad`, `lab09-publicar-equipo`, `lab09-subir-foto`, `lab09-crear-reserva`) | Cada una representa una operación del marketplace. Por ahora devuelven un "hola mundo" en Node.js 22.x. |
| API Gateway `lab09-terrafleet-api` | Da una ruta de entrada por cada Lambda y publica el stage `dev`. |
| 3 colas SQS (`lab09-reservas`, `lab09-resultados`, `lab09-notificaciones`) | Guardan el trabajo pendiente entre reserva, pago y aviso. |

Todo está en `us-east-2` y con el prefijo `lab09-`.

## Cómo lo montamos

### 1. Preparar la cuenta de AWS

| Paso | Para qué sirve |
|---|---|
| MFA en la cuenta root | Cuidar la cuenta principal. |
| Usuario `admin-lab` con MFA | Trabajar con un usuario propio en lugar de root. |
| Región us-east-2 (Ohio) | Que todos los recursos estén en el mismo lugar. |
| Presupuesto mensual con aviso | Enterarnos si el gasto sube. |
| Bucket S3 para el estado, creado a mano | Guardar el `terraform.tfstate` en la nube, con versionado, cifrado y acceso público bloqueado. |

### 2. Conectar GitHub con AWS

| Paso | Para qué sirve |
|---|---|
| Proveedor OIDC de GitHub en IAM | Que AWS reconozca a GitHub Actions. |
| Rol `lab09-github-actions-dev` | Es el rol que usa el workflow; solo confía en este repositorio y en el entorno `dev`. |
| Política `lab09-terraform-deploy` | Le da al rol lo justo para trabajar con S3, Lambda, API Gateway, SQS, logs e IAM. |
| Entorno `dev` | Solo deja desplegar desde `development` y pide que un revisor apruebe. |
| Variables `AWS_REGION`, `AWS_ROLE_ARN` y `TF_STATE_BUCKET` | Pasar al workflow la región, el rol y el bucket. |

### 3. Escribir el Terraform

El código está en `terraform/`. Ahí definimos los roles IAM y las 5 Lambdas con sus logs, la API con sus rutas, permisos, deployment y stage, las 3 colas y los outputs (la URL de la API y las de las colas). El estado se guarda en el bucket de S3. El archivo `backend.hcl` con el nombre real del bucket queda en `.gitignore`.

### 4. Probar en local

Antes de subir nada corrimos estos comandos para confirmar que la configuración funcionaba:

```bash
terraform -chdir=terraform init -backend-config=backend.hcl
terraform -chdir=terraform validate
terraform -chdir=terraform plan
```

### 5. Crear los workflows

| Workflow | Cuándo corre | Qué hace |
|---|---|---|
| `deploy.yml` | Con cada push a `development` | Entra a AWS con el rol por OIDC, ejecuta `init`, `validate`, `plan` y `apply`, y espera la aprobación del entorno `dev`. |
| `destroy.yml` | Lo lanzamos a mano desde `development` | Entra con el mismo rol, ejecuta `init` y `terraform destroy`. |

### 6. Aplicar y destruir

1. **Apply:** hicimos push a `development`, aprobamos el despliegue y el workflow terminó con `Apply complete!`. Revisamos en la consola de AWS que estuvieran las Lambdas, el API y las colas.
2. **Destroy:** lanzamos el workflow `destroy` y confirmamos en la consola que los recursos ya no existían.
