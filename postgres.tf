resource "helm_release" "psql" {
  name       = "psql"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  namespace = "default"

  set {
    name  = "global.postgresql.auth.postgresPassword"
    value = "hello"
  }
}