defmodule Arc.Storage.Cloudinary do
  @moduledoc """
  Storage provider for Arc that allows for uploading received files to Cloudinary.
  """

  def put(definition, version, {file, scope}) do
    version
    destination_dir = definition.storage_dir(version, {file, scope})
    full_path = Path.join(destination_dir, file.file_name)

    {:ok, uploaded_file} = Cloudex.upload(file.path, %{ public_id: Path.basename(file.file_name, Path.extname(file.file_name)) })
    uploaded_file

    filemap = Map.from_struct(uploaded_file)
    {:ok, "v#{filemap.version}/#{file.file_name}"}
    ##{:ok, file.file_name}
  end

  def url(definition, version, {file, scope}, options \\ []) do
    Cloudex.Url.for(file.file_name, definition.cloudinary_transform(version))
  end

end
