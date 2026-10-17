# Ejecutar DESDE la raiz del repositorio (PowerShell). No subas terraform.tfvars.
Set-Location ./infra
Copy-Item ./terraform.tfvars.example ./terraform.tfvars
notepad ./terraform.tfvars
# Luego edita TU suscripcion y nombre unico, y ejecuta estos comandos manualmente:
# az login
# az account set --subscription "TU-ID"
# terraform init
# terraform fmt -recursive
# terraform validate
# terraform plan -out=practica.tfplan
# terraform apply practica.tfplan
# terraform output
# Cuando concluyas y tengas evidencia: terraform destroy
