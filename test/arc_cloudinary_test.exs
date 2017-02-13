defmodule Avatar do
  use Arc.Definition

  @versions [:original]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def acl(:thumb, _), do: :public_read

  def validate({file, _}) do
    # file_extension = file.file_name |> Path.extname |> String.downcase
    # Enum.member?(@extension_whitelist, file_extension)
    true
  end

  def cloudinary_versions do
    [:original, :thumb]
  end

  def cloudinary_transform(:thumb) do
    %{crop: "fill", gravity: "face", width: 100, height: 100}
  end

  def cloudinary_transform(:original) do
    %{}
  end

  def transform(:thumb, _) do
    :noaction
  end

  def filename(version, { file, scope}) do
    data = file.path
    |> File.read!

    sha = :crypto.hash(:md5, data)
    |> Base.encode16
    |> String.downcase

    sha
  end

  def storage_dir(_version, {file, _scope}) do
    "photos"
  end

  def default_url(:thumb) do
    "https://placehold.it/100x100"
  end
end

defmodule Arc.Storage.CloudinaryTest do
  use ExUnit.Case
  doctest Arc.Storage.Cloudinary

  @test_file "test/support/test.png"

  test "basic test" do
    {:ok, some_file} = Avatar.store(@test_file)
    some_file
    |> IO.inspect
  end

  test "url for store retrieves image and checks the sha" do
    {:ok, some_file} = Avatar.store("https://placeholdit.imgix.net/~text?txtsize=9&txt=100%C3%97100&w=100&h=100")
    some_file
    |> IO.inspect
  end

  test "retrieving URL via Arc gives us the cloudinary url" do
    IO.inspect Avatar.url("photos/123.jpg", :original)
  end



end
