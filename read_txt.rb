module ReadTxt
  def img_file(file_name)
    path = File.join(File.dirname(__FILE__), 'img', file_name)
    img = File.read(path)
  end
end