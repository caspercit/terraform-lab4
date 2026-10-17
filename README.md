# CafeSoft | Infraestructura Azure con Terraform (practica de red virtual)

Proyecto basado en el ZIP de **Terraform Laboratorio 3**. Se conserva el concepto de Resource Group, App Service, Log Analytics y Application Insights, y se amplia con **Virtual Network**, subredes delegadas, Network Security Group, Storage privado y PostgreSQL Flexible Server. La infraestructura es para el sistema CafeSoft (API Java, web React y app movil React Native consumiendo HTTPS).

## 1. Organizacion (cinco modulos, un solo estado Terraform)

| Ruta | Funcion |
| --- | --- |
| `infra/modules/network` | VNet 10.30.0.0/16, tres subredes y NSG de gestion |
| `infra/modules/storage` | Storage Account LRS y contenedor privado `evidencias` |
| `infra/modules/monitoring` | Log Analytics y Application Insights |
| `infra/modules/apps` | Plan Linux compartido, frontend Node y API Java 17 (sin desplegar la aplicacion) |
| `infra/modules/database` | PostgreSQL Flexible Server privado, DNS privado y base `cafesoft` |

```text
Internet / React Native / React web
              | HTTPS
       Azure Web App - API Java ---- salida por VNet: snet-app-integration
                                           |
VNet 10.30.0.0/16                          | DNS privado
  snet-app-integration   10.30.1.0/24       +--- PostgreSQL (10.30.2.0/24)
  snet-postgresql        10.30.2.0/24
  snet-management        10.30.3.0/24 ---- NSG (reglas entrantes por defecto)
       Storage Blob privado + observabilidad (servicios Azure administrados)
GitHub -> Jenkins / GitHub Actions (valida IaC; no hace deploy automaticamente)
```

**Importante**: las subredes son red virtual, no servidores. El frontend React Native corre en el telefono, NO dentro de Azure. App Service usa integracion VNet para salida hacia base de datos privada, pero las URL HTTPS de las aplicaciones siguen siendo publicas. La cuenta Storage esta privada para datos; no equivale a un NAT Gateway de salida a internet. No se ha desplegado ningun codigo Java/React ni autentificacion de usuarios; faltan los pipelines y configuracion de secretos de la aplicacion.

## 2. Inicio desde cero (Windows PowerShell)

Instala Terraform 1.13+, Azure CLI y Git. Verifica disponibilidad/cuotas de tu suscripcion **Azure for Students** en la region deseada.

```powershell
git clone https://github.com/TU-USUARIO/TU-REPO.git
cd TU-REPO\infra
Copy-Item terraform.tfvars.example terraform.tfvars
notepad terraform.tfvars
az login
az account list --output table
az account set --subscription "TU-SUSCRIPCION"
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=practica.tfplan
terraform apply practica.tfplan
terraform output
```

Si usas ZIP sin repositorio remoto: extrae el ZIP y abre PowerShell en `infra`. **No ejecutes `apply` antes de revisar el plan y los costos.** El nombre `unique_suffix` debe ser exclusivo (por ejemplo `uri2026`). No compartas la suscripcion real ni contrasenas. No subas `terraform.tfvars`, `.tfstate`, `.tfplan` ni secretos a Git; los filtros estan en `.gitignore`.

## 3. Modo base y modo completo

- **Modo base**: `enable_apps=false`, `enable_database=false`, `enable_monitoring=false`, `enable_storage=true`. Crea RG, VNet, 3 subredes, NSG, cuenta de Storage privada. Storage puede facturar por uso.
- **Modo ampliado**: cambia `enable_apps=true`, `enable_database=true`, `enable_monitoring=true`. Crea ademas 2 Azure Web Apps, un App Service Plan **B1**, PostgreSQL privado, Private DNS, Log Analytics y Application Insights. **Se generan costos incluso sin trafico** en App Service/PostgreSQL. `F1` no permite la integracion de red virtual indicada. Confirma regiones, cuotas y SKU; la cuenta de estudiante podria rechazarlos.

Antes de desplegar base de datos en PowerShell:

```powershell
$env:TF_VAR_postgres_admin_password = 'TU_CLAVE_SEGURA_AQUI'
terraform plan -out=practica.tfplan
```

Establece una clave real y compleja; **no uses literalmente la de ejemplo**. Incluso con variable sensible, la contrasena quedara dentro de `terraform.tfstate`; protege este archivo y usa backend remoto seguro para trabajo real. El proyecto NO pasa la contrasena a App Service: hay que integrar un secreto mediante un gestor seguro como Azure Key Vault antes de ejecutar la API.

## 4. Evidencias para el Word

1. `terraform version` y `az account show --output table` (oculta datos sensibles).
2. `terraform init` y descarga de proveedores.
3. `terraform fmt -check -recursive` y `terraform validate`.
4. `terraform plan` con `Plan: N to add, 0 to change, 0 to destroy` (N depende de banderas).
5. `terraform apply` con el resumen real, solo tras aprobar costos.
6. `terraform output`, portal Azure: Resource Group, VNet, las 3 subredes, NSG y Storage.
7. Si activaste los servicios: App Service, PostgreSQL, Application Insights y Log Analytics.
8. `git log --oneline --graph --all` y URL del repositorio remoto GitHub.

`git remote -v` solo muestra un remoto despues de que tu lo configures y publiques; este ZIP contiene el historial **local** de Git, pero no esta subido a GitHub.

## 5. Git y publicacion

```powershell
git log --oneline --graph --all
# Crea un repositorio VACIO en github.com y, desde la raiz del proyecto:
git remote add origin https://github.com/TU-USUARIO/TU-REPOSITORIO.git
git branch -M main
git push -u origin main
```

GitHub Actions y Jenkins hacen `fmt`/`validate`, **no** hacen `apply`. Requieren acceso a Terraform/proveedores en el agente. Para implementar el CD debes disenar credenciales federadas/gestionadas y aprobaciones por separado.

## 6. Limpieza

```powershell
cd infra
terraform destroy
```

Conserva el estado original hasta terminar el `destroy`. Antes de eliminar revisa la opcion `terraform plan -destroy` y evita borrar recursos compartidos. No ejecutes `destroy` si necesitas conservar evidencias de Azure.

## 7. Fuentes

- VNet: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
- Subnet: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
- Linux Web App: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
- PostgreSQL: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server
- Provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest

## Alcance / honestidad de las evidencias

El material se genero localmente con archivos Terraform. Sin el acceso a Azure no se puede afirmar que `terraform init/validate/plan/apply` se hayan ejecutado, ni generar capturas reales del portal. El archivo Word incluye las secciones que debes completar con tus capturas. La carpeta `evidencias/` contiene una lista para levantar las capturas, no capturas inventadas.
