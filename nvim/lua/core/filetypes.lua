vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
    [".gitlab-ci.yml"] = "yaml.gitlab",
    [".gitlab-ci.yaml"] = "yaml.gitlab",
  },
  pattern = {
    [".*/templates/.*%.ya?ml"] = "yaml.helm-values",
    [".*/helm/.*/values%.ya?ml"] = "yaml.helm-values",
    ["values%.ya?ml"] = "yaml.helm-values",
  },
})
