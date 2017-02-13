use Mix.Config
config :cloudex,
  cloudinary_api: Cloudex.CloudinaryApi.Test,
  api_key: "my-api-key",
  secret: "my-secret",
  cloud_name: "my-cloud-name"


config :arc,
  storage: Arc.Storage.Cloudinary
