class Task



  def import_heroclass
    f = PfrpgImport::HeroclassImporter.new('adept.csv', @path)

  end
end
